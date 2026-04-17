# break-reminder.nvim

A small shared break timer for Neovim.

Features:

- Share one countdown across multiple Neovim instances through a state file.
- Use a simple directory lock to avoid concurrent state writes.
- Poll and sync local notification UI with shared state.
- Render notifications through `j-hui/fidget.nvim`.
- Expose `:BreakReminderStart`, `:BreakReminderFinish`, and `:BreakReminderStatus`.
- Leave keymaps to user config instead of defining them inside the plugin.

The plugin only provides commands; keymaps should live in your own config.
