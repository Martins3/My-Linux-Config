-- 有时候，我们在 terminal 中运行了 codex 等，等到要关闭 nvim 的时候，
-- 我也不记不清楚了，所以需要动态的判断:
-- 
-- 如果执行 qa 退出，那么 terminal 中内容直接被 kill 掉
-- 
-- wqa 退出，发现如果 nvim 打开了 terminal ，无论是 ，如果执行 wqa 会有这个错误
-- ```txt
-- E948: Job still running
-- E676: No matching autocommands for buftype= buffer
-- ```
--
-- 所以
-- terminal buffer 需要单独判断：
-- 
-- 1. 停在 zsh 提示符时自动清理 terminal
-- 2. 前台是其它程序时阻塞退出，避免误杀正在运行的任务



local M = {}

-- Idle shell buffers are safe to close. Busy terminals should block quit.
local shell_name = "zsh"

-- Query the terminal job process. We only need:
-- - comm: executable name of the terminal job, expected to be zsh for an idle shell
-- - pgid: process group of that shell
-- - tpgid: foreground process group currently owning the tty
local function run_ps_for_pid(pid)
  local result = vim.system({
    "ps",
    "-o",
    "comm=,pgid=,tpgid=",
    "-p",
    tostring(pid),
  }, { text = true }):wait()

  if result.code ~= 0 then
    local stderr = vim.trim(result.stderr or "")
    local stdout = vim.trim(result.stdout or "")
    return nil, stderr ~= "" and stderr or stdout
  end

  local output = vim.trim(result.stdout or "")
  if output == "" then
    return nil, "empty ps output"
  end

  return output
end

-- Decide whether a terminal buffer can be force-closed.
-- Safe case:
-- - terminal job is zsh
-- - tty foreground group is still zsh's own group
-- Blocked case:
-- - terminal job is some other program, such as ipython/tig/qwen
-- - or zsh has handed the tty to a foreground child process
local function classify_terminal_buffer(buf)
  local channel = vim.bo[buf].channel
  if not channel or channel == 0 then
    return {
      buf = buf,
      action = "kill",
      reason = "terminal job already disconnected",
    }
  end

  local ok, pid = pcall(vim.fn.jobpid, channel)
  if not ok or type(pid) ~= "number" or pid <= 0 then
    return {
      buf = buf,
      action = "kill",
      reason = "terminal job already exited",
    }
  end

  local output, err = run_ps_for_pid(pid)
  if not output then
    return {
      buf = buf,
      action = "block",
      reason = "failed to inspect terminal process: " .. err,
    }
  end

  local comm, pgid, tpgid = output:match("^%s*(%S+)%s+(%-?%d+)%s+(%-?%d+)%s*$")
  if not comm then
    return {
      buf = buf,
      action = "block",
      reason = "unexpected ps output: " .. output,
    }
  end

  pgid = tonumber(pgid)
  tpgid = tonumber(tpgid)

  -- The shell still owns the terminal foreground group, which usually means
  -- it is sitting at the prompt and can be cleaned up on quit.
  if comm == shell_name and tpgid == pgid then
    return {
      buf = buf,
      action = "kill",
      reason = "idle " .. shell_name .. " prompt",
    }
  end

  -- The terminal job itself is not a shell, so quitting would kill a visible
  -- foreground program. Treat that as busy and block.
  if comm ~= shell_name then
    return {
      buf = buf,
      action = "block",
      reason = "terminal root process is " .. comm,
    }
  end

  -- The terminal job is zsh, but the tty foreground group belongs to one of
  -- its children. That means zsh launched a foreground program and is waiting.
  return {
    buf = buf,
    action = "block",
    reason = shell_name .. " handed tty to foreground pgid " .. tpgid,
  }
end

-- Emulate the useful part of :wqa without touching special buffers such as
-- terminal/nofile/help. Only normal modified file buffers are written.
local function write_regular_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buftype == ""
      and vim.bo[buf].modifiable
      and vim.bo[buf].modified then
      local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
        vim.cmd("silent update")
      end)
      if not ok then
        vim.notify("Failed to save buffer " .. buf .. ": " .. tostring(err), vim.log.levels.ERROR)
        return false
      end
    end
  end

  return true
end

function M.smart_quit()
  local blocked = {}
  local killable = {}

  -- First classify every terminal. If any one of them is busy, do not quit at
  -- all, so the user does not accidentally kill a long-running task.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      local state = classify_terminal_buffer(buf)
      if state.action == "block" then
        table.insert(blocked, state)
      else
        table.insert(killable, state)
      end
    end
  end

  if #blocked > 0 then
    local details = {}
    for _, state in ipairs(blocked) do
      table.insert(details, "#" .. state.buf .. " " .. state.reason)
    end
    vim.notify("Quit blocked by terminal buffer(s): " .. table.concat(details, "; "), vim.log.levels.WARN)
    return
  end

  if not write_regular_buffers() then
    return
  end

  -- Only after saves succeed do we wipe idle shell terminals and quit.
  for _, state in ipairs(killable) do
    local ok, err = pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
    if not ok then
      vim.notify("Failed to close terminal buffer " .. state.buf .. ": " .. tostring(err), vim.log.levels.ERROR)
      return
    end
  end

  vim.cmd("confirm qa")
end

-- Expose a single command. Keymaps stay in the user's config.
pcall(vim.api.nvim_del_user_command, "SmartQuit")
vim.api.nvim_create_user_command("SmartQuit", M.smart_quit, {
  desc = "Quit Neovim while respecting terminal buffers",
})

return M
