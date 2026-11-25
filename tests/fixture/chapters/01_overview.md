# 1. Overview

The Event Counter (EVC) is an invented design used only to test specforge on a computer. It counts events and is shown in Figure 1.1.

![Block diagram](../figures/fig-evc.svg)

**Figure 1.1.** Block diagram of `evc_top`.

Table 1.1 holds text that must appear exactly as written.

**Table 1.1.** Characters with a meaning in LaTeX.

| Case | Text |
|---|---|
| percent | `duty_50%` |
| hash | `#(WIDTH)` |
| braces | `{msb,lsb}` |
| stray brace | `data}` |
| backslash | `\escaped.name` |
| pipe | `ready | valid` |
| injection | `x}\textbf{INJECTED` |
| dollar | `$clog2(DEPTH)` |
| [row] | a row that starts with a bracket & an ampersand |

## 1.1 Timing

Figure 1.2 shows the count in two cycles.

![Timing](../figures/fig-wave-evc.svg)

**Figure 1.2.** Counting one event.

## 1.2 Control

The control state machine of Figure 1.3 has three states; Table 1.2 gives
every transition.

![Control state machine](../figures/fig-fsm-evc.svg)

**Figure 1.3.** Control state machine. A state is kept when no transition condition holds.

**Table 1.2.** Transitions of the control state machine.

| Current state | Condition | Next state | Outputs |
|---|---|---|---|
| `IDLE` | `event` | `COUNT` | -- |
| `COUNT` | `event && !full` | `COUNT` | `inc` = 1 |
| `COUNT` | `clear` | `IDLE` | `done` = 1 |
| `COUNT` | `stall` | `HOLD` | -- |
| `HOLD` | `clear` (priority 2) | `IDLE` | -- |
| `HOLD` | `!stall` | `COUNT` | -- |
