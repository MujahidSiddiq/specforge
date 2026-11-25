# Packet FIFO (invented example design for specforge)

## Purpose

`pkt_fifo` buffers up to four packets between a producer and a consumer
that run on the same clock. Both sides use a valid/ready handshake.

## Packet

A packet `pkt_t` has two fields, most significant first:

- `len`, 8 bits: number of valid payload bytes, 1 to 4.
- `payload`, 32 bits: the data.

## Interface

- `clk`: clock.
- `rst_n`: asynchronous reset, active low. Empties the FIFO.
- `in_valid` (input, 1 bit): the producer offers `in_pkt`.
- `in_ready` (output, 1 bit): the FIFO can take a packet. Low when full.
- `in_pkt` (input, `pkt_t`, 40 bits): the offered packet.
- `out_valid` (output, 1 bit): `out_pkt` holds the oldest packet.
- `out_ready` (input, 1 bit): the consumer takes `out_pkt`.
- `out_pkt` (output, `pkt_t`): the oldest packet.
- `count` (output, 3 bits): number of stored packets, 0 to 4.

A packet is written when `in_valid` and `in_ready` are high at a rising
edge, and read when `out_valid` and `out_ready` are high.

## Blocks

- `WR` (`wr_ctrl`): write pointer `wr_ptr` (2 bits) and `wr_en`; drives
  `in_ready` from `count`.
- `MEM` (`pkt_mem`): four entries of `pkt_t`; written at `wr_ptr` when
  `wr_en`; `rd_data` is the entry at `rd_ptr`.
- `RD` (`rd_ctrl`): read pointer `rd_ptr` (2 bits), `rd_en`, `out_valid`,
  and the counter `count`, which `wr_en` increments and `rd_en`
  decrements (no change when both are high).

## Read control

`rd_ctrl` has two states:

- `EMPTY`: `out_valid` is 0. Goes to `VALID` when `count` is not 0.
- `VALID`: `out_valid` is 1. On a read (`out_ready`), goes to `EMPTY` if
  this was the last packet and no packet is written in the same cycle;
  otherwise it stays in `VALID` and shows the next packet in the next
  cycle.

Reset puts it in `EMPTY`.

## Same cycle

A write and a read in the same cycle are both done; `count` does not
change. When the FIFO is full, `in_ready` is low even if a read happens in
the same cycle.
