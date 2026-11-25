# 3. Interfaces

## 3.1 External Signals

**Table 3.1.** Signals of `pkt_fifo`.

| Signal | Width | Direction | Description |
|---|---|---|---|
| `clk` | 1 | Input | Clock. |
| `rst_n` | 1 | Input | Asynchronous reset, active low. Empties the FIFO. |
| `in_valid` | 1 | Input | The producer offers `in_pkt`. |
| `in_ready` | 1 | Output | The FIFO can take a packet. Low when `count` is 4. |
| `in_pkt` | 40 | Input | The offered packet (`pkt_t`, Table 3.3). |
| `out_valid` | 1 | Output | `out_pkt` holds the oldest packet. |
| `out_ready` | 1 | Input | The consumer takes `out_pkt`. |
| `out_pkt` | 40 | Output | The oldest stored packet (`pkt_t`). Valid while `out_valid` is high. |
| `count` | 3 | Output | Number of stored packets, 0 to 4. |

## 3.2 Signals between the Blocks

**Table 3.2.** Signals between the blocks of `pkt_fifo`.

| Signal | Width | From, to | Description |
|---|---|---|---|
| `wr_en` | 1 | `WR` to `MEM`, `RD` | A write happens in this cycle. |
| `wr_ptr` | 2 | `WR` to `MEM` | Entry that the next write uses. |
| `rd_ptr` | 2 | `RD` to `MEM` | Entry of the oldest packet. |
| `count` | 3 | `RD` to `WR` | Number of stored packets. |

## 3.3 Packet

**Table 3.3.** Fields of the packet `pkt_t`, from the most significant bit.

| Field | Width | Meaning |
|---|---|---|
| `len` | 8 | Number of valid payload bytes, 1 to 4. |
| `payload` | 32 | The data. |

`pkt_fifo` stores and returns packets unchanged; it does not check `len`.
