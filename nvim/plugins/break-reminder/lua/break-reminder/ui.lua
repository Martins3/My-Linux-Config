local M = {}

function M.new(config, state_api)
  local local_state = {
    timer = nil,
    current_state = nil,
  }

  local group_key = "break-reminder"
  local annote = "Break Reminder"
  local statusline_icons = vim.tbl_deep_extend("force", {
    running = "⏳",
    paused = "⏸",
    fired = "🔔",
  }, config.statusline_icons or {})

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

  local function echo_message(message, level)
    local hl = "None"
    if level == vim.log.levels.ERROR then
      hl = "ErrorMsg"
    elseif level == vim.log.levels.WARN then
      hl = "WarningMsg"
    end

    vim.api.nvim_echo({ { message, hl } }, true, {})
  end

  local function set_current_state(state)
    local previous_phase = local_state.current_state and local_state.current_state.phase or nil
    local_state.current_state = state
    if previous_phase ~= state.phase then
      vim.schedule(function()
        vim.cmd("redrawstatus")
      end)
    end
  end

  local function format_seconds(seconds)
    local total = math.max(math.floor(tonumber(seconds) or 0), 0)
    local hours = math.floor(total / 3600)
    local minutes = math.floor((total % 3600) / 60)
    local remain = total % 60

    if hours > 0 then
      return string.format("%dh %02dm %02ds", hours, minutes, remain)
    end
    return string.format("%dm %02ds", minutes, remain)
  end

  local function format_timestamp(ts)
    if ts == nil or ts == vim.NIL then
      return nil
    end

    return os.date("%H:%M:%S", ts)
  end

  local function action_label(prefix)
    local labels = {
      acknowledge = "ack",
      finished = "finish",
      fired = "fired",
      pause = "kick",
      resume = "kick",
      start = "kick",
      started = "start",
      status = "status",
    }
    return labels[prefix] or prefix
  end

  local function build_status_message(state)
    local stats = state_api.get_stats()
    local parts = { "break reminder [" .. state.phase .. "]" }

    if state.phase == "idle" then
      table.insert(parts, "interval " .. format_seconds(config.interval_minutes * 60))
      table.insert(parts, "done " .. tostring(stats.completed_cycles))
      table.insert(parts, "focus " .. format_seconds(stats.total_focus_seconds))
    else
      table.insert(parts, "cycle #" .. tostring(state.generation))
      local remaining = state_api.get_remaining_seconds(state)
      if remaining ~= nil then
        table.insert(parts, "remaining " .. format_seconds(remaining))
      end
      table.insert(parts, "focused " .. format_seconds(state_api.get_elapsed_seconds(state)))
      if state.phase == "fired" then
        local fired_at = format_timestamp(state.fired_at)
        if fired_at ~= nil then
          table.insert(parts, "fired at " .. fired_at)
        end
      end
    end

    return table.concat(parts, ", ")
  end

  local function show_notification(state)
    notify(table.concat({
      config.message,
      "",
      build_status_message(state),
    }, "\n"), vim.log.levels[config.level] or vim.log.levels.WARN, {
      group = group_key,
      key = "active",
      annote = annote,
      ttl = math.huge,
    })
  end

  local function sync()
    local state = state_api.ensure_state()
    if state.phase == "running" and state.deadline_ts ~= vim.NIL and state_api.now() >= state.deadline_ts then
      state = state_api.transition_to_fired()
    end

    set_current_state(state)
    if state.phase == "fired" then
      show_notification(state)
      return state
    end

    clear_notification()
    return state
  end

  local function show_status(state, prefix)
    set_current_state(state)

    local message = build_status_message(state)
    local label = action_label(prefix)
    if label and label ~= "" then
      message = label .. ": " .. message
    end

    local level = vim.log.levels.INFO
    if state.phase ~= "fired" then
      echo_message(message, level)
      return
    end

    notify(message, level, {
      group = group_key,
      key = "status",
      annote = annote,
      ttl = 10,
      skip_history = true,
    })
  end

  local function get_statusline_indicator()
    local state = local_state.current_state or state_api.ensure_state()
    return statusline_icons[state.phase]
  end

  return {
    local_state = local_state,
    clear_notification = clear_notification,
    sync = sync,
    show_status = show_status,
    get_statusline_indicator = get_statusline_indicator,
  }
end

return M
