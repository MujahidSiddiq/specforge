# 3. Interfaces

## 3.1 External Signals

Table 3.1 lists every signal of `req_arbiter`. All outputs change on the
rising edge of `clk`.

**Table 3.1.** Signals of `req_arbiter`.

| Signal | Width | Direction | Description |
|---|---|---|---|
| `clk` | 1 | Input | Clock. |
| `reset_n` | 1 | Input | Asynchronous reset, active low. Resets the state to `IDLE`, `valid_o` and `pkt_o` to 0, and makes port A win the first tie. |
| `req_a` | 1 | Input | Port A has a packet on `pkt_a`. Held until `grant_a`. |
| `pkt_a` | 26 | Input | Request packet of port A (`req_pkt_t`, Table 3.2). Valid while `req_a` is high. |
| `req_b` | 1 | Input | Port B has a packet on `pkt_b`. Held until `grant_b`. |
| `pkt_b` | 26 | Input | Request packet of port B (`req_pkt_t`). Valid while `req_b` is high. |
| `ack_i` | 1 | Input | The output has taken `pkt_o`. Ends the transfer. |
| `grant_a` | 1 | Output | High for one cycle when the packet of port A is taken. |
| `grant_b` | 1 | Output | High for one cycle when the packet of port B is taken. |
| `valid_o` | 1 | Output | `pkt_o` holds a packet. High from the cycle after the grant until the cycle after `ack_i`. |
| `pkt_o` | 26 | Output | The forwarded request packet (`req_pkt_t`). Valid while `valid_o` is high. |

## 3.2 Request Packet

**Table 3.2.** Fields of the request packet `req_pkt_t`, from the most significant bit.

| Field | Width | Meaning |
|---|---|---|
| `id` | 2 | Identifier of the request. |
| `addr` | 8 | Address. |
| `data` | 16 | Data. |

The arbiter does not interpret the fields; it forwards the packet
unchanged.

## 3.3 Protocol

A port raises its request with a packet and holds both until its grant. The
output acknowledges a packet with `ack_i` while `valid_o` is high; the
next transfer can be granted from the cycle after the acknowledgement.
Figure 4.2 shows one transfer.
