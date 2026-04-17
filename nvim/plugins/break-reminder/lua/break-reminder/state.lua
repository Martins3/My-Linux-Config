local uv = vim.uv or vim.loop

local M = {}

local function now()
  return os.time()
end

function M.new(config)
  local state_dir = vim.fn.stdpath("state") .. "/break-reminder"
  local state_file = state_dir .. "/state.json"
  local lock_dir = state_dir .. "/lock"

  local function ensure_dir()
    vim.fn.mkdir(state_dir, "p")
  end

  local function read_file(path)
    local file = io.open(path, "r")
    if not file then
      return nil
    end

    local content = file:read("*a")
    file:close()
    return content
  end

  local function write_file(path, content)
    local file = assert(io.open(path, "w"))
    file:write(content)
    file:close()
  end

  local function default_state(generation)
    return {
      version = 1,
      generation = generation or 0,
      phase = "idle",
      interval_minutes = config.interval_minutes,
      deadline_ts = vim.NIL,
      fired_at = vim.NIL,
      updated_at = now(),
    }
  end

  local function normalize_state(raw)
    if type(raw) ~= "table" then
      return nil
    end

    local generation = tonumber(raw.generation) or 0
    local interval_minutes = tonumber(raw.interval_minutes) or config.interval_minutes
    local deadline_ts = raw.deadline_ts == vim.NIL and vim.NIL or tonumber(raw.deadline_ts) or vim.NIL
    local fired_at = raw.fired_at == vim.NIL and vim.NIL or tonumber(raw.fired_at) or vim.NIL
    local phase = "idle"
    if raw.phase == "waiting" then
      phase = "waiting"
    elseif raw.phase == "fired" then
      phase = "fired"
    end

    if phase == "waiting" and deadline_ts == vim.NIL then
      deadline_ts = now() + interval_minutes * 60
    end

    return {
      version = tonumber(raw.version) or 1,
      generation = generation,
      phase = phase,
      interval_minutes = interval_minutes,
      deadline_ts = deadline_ts,
      fired_at = fired_at,
      updated_at = tonumber(raw.updated_at) or now(),
    }
  end

  local function read_state()
    local content = read_file(state_file)
    if not content or content == "" then
      return nil
    end

    local ok, decoded = pcall(vim.json.decode, content)
    if not ok then
      return nil
    end

    return normalize_state(decoded)
  end

  local function write_state(state)
    write_file(state_file, vim.json.encode(state))
  end

  local function release_lock()
    pcall(uv.fs_rmdir, lock_dir)
  end

  local function try_acquire_lock()
    local ok = uv.fs_mkdir(lock_dir, 448)
    if ok then
      return true
    end

    local stat = uv.fs_stat(lock_dir)
    if stat and stat.mtime and stat.mtime.sec then
      if now() - stat.mtime.sec > config.stale_lock_seconds then
        pcall(uv.fs_rmdir, lock_dir)
        return uv.fs_mkdir(lock_dir, 448) ~= nil
      end
    end

    return false
  end

  local function with_lock(fn)
    ensure_dir()

    local deadline = uv.hrtime() + config.lock_timeout_ms * 1000000
    while uv.hrtime() < deadline do
      if try_acquire_lock() then
        local ok, result_a, result_b = pcall(fn)
        release_lock()
        if not ok then
          error(result_a)
        end
        return result_a, result_b
      end
      vim.wait(50)
    end

    return nil
  end

  local function ensure_state()
    ensure_dir()

    local state = read_state()
    if state ~= nil then
      return state
    end

    return with_lock(function()
      local latest = read_state()
      if latest ~= nil then
        return latest
      end

      local created = default_state(0)
      write_state(created)
      return created
    end) or default_state(0)
  end

  local function transition_to_fired()
    return with_lock(function()
      local state = read_state() or default_state(0)
      if state.phase == "waiting" and state.deadline_ts ~= vim.NIL and now() >= state.deadline_ts then
        state.phase = "fired"
        state.fired_at = now()
        state.updated_at = now()
        write_state(state)
      end
      return state
    end) or ensure_state()
  end

  local function start_countdown()
    return with_lock(function()
      local state = read_state() or default_state(0)
      if state.phase ~= "idle" then
        return state, false
      end

      local next = default_state(state.generation + 1)
      next.phase = "waiting"
      next.deadline_ts = now() + config.interval_minutes * 60
      next.updated_at = now()
      write_state(next)
      return next, true
    end)
  end

  local function finish_cycle()
    return with_lock(function()
      local state = read_state() or default_state(0)
      if state.phase == "idle" then
        return state, false
      end

      local next = default_state(state.generation)
      next.updated_at = now()
      write_state(next)
      return next, true
    end)
  end

  return {
    now = now,
    ensure_state = ensure_state,
    transition_to_fired = transition_to_fired,
    start_countdown = start_countdown,
    finish_cycle = finish_cycle,
  }
end

return M
