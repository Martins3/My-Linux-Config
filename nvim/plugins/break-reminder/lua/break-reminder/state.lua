local uv = vim.uv or vim.loop

local M = {}

local function now()
  return os.time()
end

function M.new(config)
  local state_dir = vim.fn.stdpath("state") .. "/break-reminder"
  local state_file = state_dir .. "/state.json"
  local log_file = state_dir .. "/events.jsonl"
  local stats_file = state_dir .. "/stats.json"
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

  local function append_file(path, content)
    local file = assert(io.open(path, "a"))
    file:write(content)
    file:close()
  end

  local function normalize_timestamp(value)
    if value == nil or value == vim.NIL then
      return vim.NIL
    end

    return tonumber(value) or vim.NIL
  end

  local function default_state(generation)
    return {
      version = 2,
      generation = generation or 0,
      phase = "idle",
      interval_minutes = config.interval_minutes,
      deadline_ts = vim.NIL,
      remaining_seconds = vim.NIL,
      run_started_at = vim.NIL,
      elapsed_seconds = 0,
      fired_at = vim.NIL,
      updated_at = now(),
    }
  end

  local function default_stats()
    return {
      version = 1,
      total_kicks = 0,
      starts = 0,
      pauses = 0,
      resumes = 0,
      auto_fires = 0,
      finishes = 0,
      acknowledgements = 0,
      completed_cycles = 0,
      interrupted_cycles = 0,
      total_focus_seconds = 0,
      updated_at = now(),
    }
  end

  local function get_elapsed_seconds(state, at_ts)
    local elapsed = math.max(tonumber(state.elapsed_seconds) or 0, 0)
    if state.phase == "running" and state.run_started_at ~= vim.NIL then
      elapsed = elapsed + math.max((at_ts or now()) - state.run_started_at, 0)
    end
    return elapsed
  end

  local function get_remaining_seconds(state, at_ts)
    if state.phase == "running" and state.deadline_ts ~= vim.NIL then
      return math.max(state.deadline_ts - (at_ts or now()), 0)
    end
    if state.phase == "paused" and state.remaining_seconds ~= vim.NIL then
      return math.max(tonumber(state.remaining_seconds) or 0, 0)
    end
    if state.phase == "fired" then
      return 0
    end
    return nil
  end

  local function normalize_state(raw)
    if type(raw) ~= "table" then
      return nil
    end

    local current_now = now()
    local generation = tonumber(raw.generation) or 0
    local interval_minutes = tonumber(raw.interval_minutes) or config.interval_minutes
    local deadline_ts = normalize_timestamp(raw.deadline_ts)
    local remaining_seconds = normalize_timestamp(raw.remaining_seconds)
    local run_started_at = normalize_timestamp(raw.run_started_at)
    local fired_at = normalize_timestamp(raw.fired_at)
    local elapsed_seconds = math.max(tonumber(raw.elapsed_seconds) or 0, 0)

    local phase = "idle"
    if raw.phase == "waiting" or raw.phase == "running" then
      phase = "running"
    elseif raw.phase == "paused" then
      phase = "paused"
    elseif raw.phase == "fired" then
      phase = "fired"
    end

    if phase == "running" then
      if deadline_ts == vim.NIL then
        local fallback_remaining = remaining_seconds ~= vim.NIL and remaining_seconds or interval_minutes * 60
        deadline_ts = current_now + math.max(fallback_remaining, 0)
      end
      if run_started_at == vim.NIL then
        run_started_at = math.max(deadline_ts - interval_minutes * 60, 0)
      end
      remaining_seconds = vim.NIL
    elseif phase == "paused" then
      if remaining_seconds == vim.NIL then
        if deadline_ts ~= vim.NIL then
          remaining_seconds = math.max(deadline_ts - current_now, 0)
        else
          remaining_seconds = interval_minutes * 60
        end
      end
      deadline_ts = vim.NIL
      run_started_at = vim.NIL
    elseif phase == "fired" then
      deadline_ts = vim.NIL
      remaining_seconds = 0
      run_started_at = vim.NIL
      if fired_at == vim.NIL then
        fired_at = current_now
      end
    else
      deadline_ts = vim.NIL
      remaining_seconds = vim.NIL
      run_started_at = vim.NIL
      fired_at = vim.NIL
      elapsed_seconds = 0
    end

    return {
      version = tonumber(raw.version) or 2,
      generation = generation,
      phase = phase,
      interval_minutes = interval_minutes,
      deadline_ts = deadline_ts,
      remaining_seconds = remaining_seconds,
      run_started_at = run_started_at,
      elapsed_seconds = elapsed_seconds,
      fired_at = fired_at,
      updated_at = tonumber(raw.updated_at) or current_now,
    }
  end

  local function normalize_stats(raw)
    if type(raw) ~= "table" then
      return nil
    end

    local stats = default_stats()
    stats.version = tonumber(raw.version) or stats.version
    stats.total_kicks = math.max(tonumber(raw.total_kicks) or 0, 0)
    stats.starts = math.max(tonumber(raw.starts) or 0, 0)
    stats.pauses = math.max(tonumber(raw.pauses) or 0, 0)
    stats.resumes = math.max(tonumber(raw.resumes) or 0, 0)
    stats.auto_fires = math.max(tonumber(raw.auto_fires) or 0, 0)
    stats.finishes = math.max(tonumber(raw.finishes) or 0, 0)
    stats.acknowledgements = math.max(tonumber(raw.acknowledgements) or 0, 0)
    stats.completed_cycles = math.max(tonumber(raw.completed_cycles) or 0, 0)
    stats.interrupted_cycles = math.max(tonumber(raw.interrupted_cycles) or 0, 0)
    stats.total_focus_seconds = math.max(tonumber(raw.total_focus_seconds) or 0, 0)
    stats.updated_at = tonumber(raw.updated_at) or stats.updated_at
    return stats
  end

  local function read_json(path, normalizer)
    local content = read_file(path)
    if not content or content == "" then
      return nil
    end

    local ok, decoded = pcall(vim.json.decode, content)
    if not ok then
      return nil
    end

    return normalizer(decoded)
  end

  local function read_state()
    return read_json(state_file, normalize_state)
  end

  local function write_state(state)
    write_file(state_file, vim.json.encode(state))
  end

  local function read_stats()
    return read_json(stats_file, normalize_stats)
  end

  local function write_stats(stats)
    write_file(stats_file, vim.json.encode(stats))
  end

  local function append_event(event)
    ensure_dir()

    local timestamp = tonumber(event.ts) or now()
    local state = event.state
    local record = {
      ts = timestamp,
      action = event.action,
      trigger = event.trigger,
      previous_phase = event.previous_phase,
      next_phase = event.next_phase,
      completed_cycle = event.completed_cycle == true,
      interrupted_cycle = event.interrupted_cycle == true,
    }

    if state ~= nil then
      record.generation = state.generation
      record.phase = state.phase
      record.interval_minutes = state.interval_minutes
      record.remaining_seconds = get_remaining_seconds(state, timestamp)
      record.elapsed_seconds = get_elapsed_seconds(state, timestamp)
    end

    if event.segment_seconds ~= nil then
      record.segment_seconds = math.max(tonumber(event.segment_seconds) or 0, 0)
    end

    append_file(log_file, vim.json.encode(record) .. "\n")

    local stats = read_stats() or default_stats()
    if record.trigger == "kick" then
      stats.total_kicks = stats.total_kicks + 1
    end

    if record.action == "start" then
      stats.starts = stats.starts + 1
    elseif record.action == "pause" then
      stats.pauses = stats.pauses + 1
    elseif record.action == "resume" then
      stats.resumes = stats.resumes + 1
    elseif record.action == "auto_fire" then
      stats.auto_fires = stats.auto_fires + 1
    elseif record.action == "finish" then
      stats.finishes = stats.finishes + 1
    elseif record.action == "acknowledge" then
      stats.acknowledgements = stats.acknowledgements + 1
    end

    if record.segment_seconds ~= nil then
      stats.total_focus_seconds = stats.total_focus_seconds + record.segment_seconds
    end
    if record.completed_cycle then
      stats.completed_cycles = stats.completed_cycles + 1
    end
    if record.interrupted_cycle then
      stats.interrupted_cycles = stats.interrupted_cycles + 1
    end
    stats.updated_at = timestamp

    write_stats(stats)
    return record
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

  local function start_countdown(trigger)
    return with_lock(function()
      local current_now = now()
      local state = read_state() or default_state(0)
      if state.phase ~= "idle" then
        return state, false
      end

      local next = default_state(state.generation + 1)
      next.phase = "running"
      next.deadline_ts = current_now + config.interval_minutes * 60
      next.run_started_at = current_now
      next.updated_at = current_now
      write_state(next)
      append_event({
        action = "start",
        trigger = trigger or "command",
        previous_phase = "idle",
        next_phase = "running",
        state = next,
        ts = current_now,
      })
      return next, true
    end)
  end

  local function transition_to_fired()
    return with_lock(function()
      local current_now = now()
      local state = read_state() or default_state(0)
      if state.phase ~= "running" or state.deadline_ts == vim.NIL or current_now < state.deadline_ts then
        return state, false
      end

      local segment_seconds = 0
      if state.run_started_at ~= vim.NIL then
        segment_seconds = math.max(current_now - state.run_started_at, 0)
      end

      state.elapsed_seconds = get_elapsed_seconds(state, current_now)
      state.phase = "fired"
      state.deadline_ts = vim.NIL
      state.remaining_seconds = 0
      state.run_started_at = vim.NIL
      state.fired_at = current_now
      state.updated_at = current_now
      write_state(state)
      append_event({
        action = "auto_fire",
        trigger = "timer",
        previous_phase = "running",
        next_phase = "fired",
        state = state,
        segment_seconds = segment_seconds,
        ts = current_now,
      })
      return state, true
    end) or ensure_state()
  end

  local function finish_cycle(trigger)
    return with_lock(function()
      local current_now = now()
      local state = read_state() or default_state(0)
      if state.phase == "idle" then
        return state, false
      end

      local previous_phase = state.phase
      local segment_seconds = 0
      if previous_phase == "running" and state.run_started_at ~= vim.NIL then
        segment_seconds = math.max(current_now - state.run_started_at, 0)
        state.remaining_seconds = get_remaining_seconds(state, current_now) or 0
        state.elapsed_seconds = get_elapsed_seconds(state, current_now)
        state.run_started_at = vim.NIL
      end

      local next = default_state(state.generation)
      next.updated_at = current_now
      write_state(next)
      append_event({
        action = "finish",
        trigger = trigger or "command",
        previous_phase = previous_phase,
        next_phase = "idle",
        state = state,
        segment_seconds = segment_seconds,
        completed_cycle = previous_phase == "fired",
        interrupted_cycle = previous_phase ~= "fired",
        ts = current_now,
      })
      return next, true
    end)
  end

  local function kick()
    return with_lock(function()
      local current_now = now()
      local state = read_state() or default_state(0)

      if state.phase == "idle" then
        local next = default_state(state.generation + 1)
        next.phase = "running"
        next.deadline_ts = current_now + config.interval_minutes * 60
        next.run_started_at = current_now
        next.updated_at = current_now
        write_state(next)
        append_event({
          action = "start",
          trigger = "kick",
          previous_phase = "idle",
          next_phase = "running",
          state = next,
          ts = current_now,
        })
        return next, "start"
      end

      if state.phase == "running" then
        local segment_seconds = 0
        if state.run_started_at ~= vim.NIL then
          segment_seconds = math.max(current_now - state.run_started_at, 0)
        end

        state.elapsed_seconds = get_elapsed_seconds(state, current_now)
        state.remaining_seconds = get_remaining_seconds(state, current_now) or 0
        state.deadline_ts = vim.NIL
        state.run_started_at = vim.NIL
        state.phase = "paused"
        state.updated_at = current_now
        write_state(state)
        append_event({
          action = "pause",
          trigger = "kick",
          previous_phase = "running",
          next_phase = "paused",
          state = state,
          segment_seconds = segment_seconds,
          ts = current_now,
        })
        return state, "pause"
      end

      if state.phase == "paused" then
        local remain = get_remaining_seconds(state, current_now) or config.interval_minutes * 60
        state.phase = "running"
        state.deadline_ts = current_now + remain
        state.remaining_seconds = vim.NIL
        state.run_started_at = current_now
        state.updated_at = current_now
        write_state(state)
        append_event({
          action = "resume",
          trigger = "kick",
          previous_phase = "paused",
          next_phase = "running",
          state = state,
          ts = current_now,
        })
        return state, "resume"
      end

      local previous_state = state
      local next = default_state(previous_state.generation)
      next.updated_at = current_now
      write_state(next)
      append_event({
        action = "acknowledge",
        trigger = "kick",
        previous_phase = "fired",
        next_phase = "idle",
        state = previous_state,
        completed_cycle = true,
        ts = current_now,
      })
      return next, "acknowledge"
    end)
  end

  local function get_stats()
    ensure_dir()
    return read_stats() or default_stats()
  end

  return {
    now = now,
    ensure_state = ensure_state,
    transition_to_fired = transition_to_fired,
    start_countdown = start_countdown,
    finish_cycle = finish_cycle,
    kick = kick,
    get_stats = get_stats,
    get_elapsed_seconds = get_elapsed_seconds,
    get_remaining_seconds = get_remaining_seconds,
    get_state_dir = function()
      return state_dir
    end,
  }
end

return M
