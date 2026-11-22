# 03 - SystemVerilog and Verilog

Constructs that change what the RTL means, or that the inventory script may
miss. Check them while reading.

## Structure

- **Packages and imports** (`package`, `import p::*`): parameters, types
  and widths are often defined there; read them with the modules.
- **Parameter overrides** at instantiation (`#(.DEPTH(16))`) change a
  block's size; record the value used in the hierarchy, not only the
  default.
- **Generate blocks** (`generate`, `for`, `if` with `genvar`): the number of
  instances and the presence of logic can depend on parameters. Describe
  the result for the default configuration and state the dependency.
- **Interfaces and modports** group ports; a port of interface type is an
  interface group by itself.
- **`` `include `` and `` `define ``**: macros can define widths, constants
  or whole blocks of code. Expand them by reading the definitions; the
  inventory does not.
- **`` `ifdef ``**: code compiled only with a define. Ask which defines the
  document assumes.
- **Non-ANSI port lists** (Verilog 1995 style): directions and widths are
  declared in the module body.
- **Unpacked and packed arrays**: `logic [W-1:0] mem [D]` is D entries of W
  bits; `logic [D-1:0][W-1:0]` is a packed array, often a bus of entries.

## Behaviour

- **Sequential blocks**: `always_ff @(posedge clk or negedge rst_n)` is an
  asynchronous active-low reset; a reset tested inside
  `always_ff @(posedge clk)` is synchronous. Plain `always @(...)` with an
  edge is sequential too.
- **Registers without reset** are written in a block without the reset in
  its sensitivity list; record which state is not reset.
- **Combinational blocks** (`always_comb`, `assign`, `always @*`): outputs
  follow inputs in the same cycle.
- **Priority** follows `if`/`else if` order; `unique` and `priority`
  keywords state assumptions about exclusivity (intent to confirm).
- **Blocking (`=`) in sequential blocks** or latches (`always_latch`, an
  incomplete `always_comb`) are findings to report, not behaviour to
  describe.
- **Width truncation and wrap-around**: arithmetic on N-bit pointers wraps
  modulo 2^N; note where the behaviour depends on it.
- **`x` and `z`**: values assigned `'x` are don't-care; tri-states mean an
  external bus.

## Assertions and coverage

`assert property`, `assume property` and `cover property` state the
designer's assumptions and expectations. They are strong evidence for the
environment guarantees and boundary cases, but are still confirmed with the
user before they become statements in the specification.
