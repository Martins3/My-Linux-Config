local M = {}

function M.new(config, state_api)
  local local_state = {
    timer = nil,
  }

  local group_key = "break-reminder"
  local annote = "Break Reminder"

  local function clear_notification()
    local ok, notification = pcall(require, "fidget.notification")
    if not ok then
      return
    end

    notification.clear(group_key)
  end

  local function notify(message, level, opts)
    local ok, fidget = pcall(require, "fidget")
    if not ok then
      vim.notify(message, level, opts)
      return
    end

    fidget.notify(message, level, opts)
  end

  local function show_notification()
    notify(config.message, vim.log.levels[config.level] or vim.log.levels.WARN, {
      group = group_key,
      key = "active",
      annote = annote,
      ttl = math.huge,
    })
  end

  local function sync()
    local state = state_api.ensure_state()
    if state.phase == "waiting" and state.deadline_ts ~= vim.NIL and state_api.now() >= state.deadline_ts then
      state = state_api.transition_to_fired()
    end

    if state.phase == "fired" then
      show_notification()
      return state
    end

    clear_notification()
    return state
  end

  local function format_seconds(seconds)
    local minutes = math.floor(seconds / 60)
    local remain = seconds % 60
    return string.format("%dm %02ds", minutes, remain)
  end

  local function show_status(state, prefix)
    local message
    if state.phase == "idle" then
      message = "break reminder: idle"
    elseif state.phase == "waiting" and state.deadline_ts ~= vim.NIL then
      local remain = math.max(state.deadline_ts - state_api.now(), 0)
      message = "break reminder: waiting, remaining " .. format_seconds(remain)
    else
      message = "break reminder: fired"
    end

    if prefix and prefix ~= "" then
      message = prefix .. ": " .. message
    end

    notify(message, vim.log.levels.INFO, {
      group = group_key,
      key = "status",
      annote = annote,
      ttl = 10,
      skip_history = true,
    })
  end

  return {
    local_state = local_state,
    clear_notification = clear_notification,
    sync = sync,
    show_status = show_status,
  }
end

return M
