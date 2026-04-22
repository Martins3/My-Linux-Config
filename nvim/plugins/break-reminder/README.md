# break-reminder

## 目标
- 尽量只用一个主键位完成 break reminder 的主要交互。
- 每次 `kick` 都展示当前状态的详细信息。
- 记录操作日志，并累计基础统计。
- 在 status line 中用 emoji 展示当前阶段。

## 状态机
```text
idle --kick--> running --time up--> fired --kick--> idle
                  |
                  +--kick--> paused --kick--> running
```

- `idle`: 没开始。
- `running`: 正在倒计时。
- `paused`: 倒计时暂停，保留剩余时间。
- `fired`: 到点后持续提醒，等待确认。

## 命令
- `:BreakReminderKick`
  - `idle -> running`
  - `running -> paused`
  - `paused -> running`
  - `fired -> idle`
  - 每次执行都会自动展示当前状态 message

## 键位
- `<space>tg`: `:BreakReminderKick`

日常只保留这一个键位。它的行为完全取决于当前状态：
- `idle -> running`
- `running -> paused`
- `paused -> running`
- `fired -> idle`

## 状态提示
每次执行 `BreakReminderKick` 时，都会自动展示当前详细信息，包括：
- 当前 phase
- 当前 cycle 编号
- 剩余时间
- 已专注时长
- 空闲时的累计完成次数和累计专注时长

## Status Line
- `running`: `⏳`
- `paused`: `⏸`
- `fired`: `🔔`
- `idle`: 不显示，避免状态栏噪音

## 持久化文件
状态目录位于 `stdpath("state") .. "/break-reminder"`。

一般是: $HOME/.local/state/nvim/break-reminder/events.jsonl

- `state.json`: 当前状态机快照
- `events.jsonl`: 事件日志
- `stats.json`: 累计统计

`events.jsonl` 会记录这些关键动作：
- `start`
- `pause`
- `resume`
- `auto_fire`
- `finish`
- `acknowledge`
