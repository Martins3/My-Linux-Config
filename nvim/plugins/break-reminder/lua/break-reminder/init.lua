local uv = vim.uv or vim.loop

local state_module = require("break-reminder.state")
local ui_module = require("break-reminder.ui")

local M = {}

local default_config = {
  interval_minutes = 22,
  poll_interval_ms = 2000,
  lock_timeout_ms = 800,
  stale_lock_seconds = 30,
  message = table.concat({
    "起来休息一下",
  }, "\n"),
  level = "WARN",
}

local plugin_state = {
  configured = false,
}

local function setup_commands(config, state_api, ui)
  pcall(vim.api.nvim_del_user_command, "BreakReminderStart")
  vim.api.nvim_create_user_command("BreakReminderStart", function()
    local _, started = state_api.start_countdown()
    local state = ui.sync()
    if started then
      ui.show_status(state, "started")
    else
      ui.show_status(state, "status")
    end
  end, { desc = "Start break reminder timer or show status" })

  pcall(vim.api.nvim_del_user_command, "BreakReminderFinish")
  vim.api.nvim_create_user_command("BreakReminderFinish", function()
    local state, finished = state_api.finish_cycle()
    ui.clear_notification()
    if finished then
      ui.show_status(state, "finished")
    else
      ui.show_status(state, "status")
    end
  end, { desc = "Dismiss break reminder and stop current timer" })

  pcall(vim.api.nvim_del_user_command, "BreakReminderStatus")
  vim.api.nvim_create_user_command("BreakReminderStatus", function()
    local state = ui.sync()
    ui.show_status(state, "status")
  end, { desc = "Show break reminder status" })
end

local function setup_autocmds(config, ui)
  local group = vim.api.nvim_create_augroup("BreakReminderPlugin", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
    group = group,
    callback = function()
      vim.schedule(function()
        ui.sync()
      end)
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if plugin_state.ui and plugin_state.ui.local_state.timer ~= nil then
        plugin_state.ui.local_state.timer:stop()
        plugin_state.ui.local_state.timer:close()
        plugin_state.ui.local_state.timer = nil
      end
    end,
  })
end

local function start_timer(config, ui)
  if ui.local_state.timer ~= nil then
    ui.local_state.timer:stop()
    ui.local_state.timer:close()
  end

  ui.local_state.timer = uv.new_timer()
  ui.local_state.timer:start(
    config.poll_interval_ms,
    config.poll_interval_ms,
    vim.schedule_wrap(function()
      ui.sync()
    end)
  )
end

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", default_config, opts or {})
  local state_api = state_module.new(config)
  local ui = ui_module.new(config, state_api)

  plugin_state.configured = true
  plugin_state.state_api = state_api
  plugin_state.ui = ui

  setup_commands(config, state_api, ui)
  setup_autocmds(config, ui)
  start_timer(config, ui)
  vim.schedule(function()
    ui.sync()
  end)
end

return M
