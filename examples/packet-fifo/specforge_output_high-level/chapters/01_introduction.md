# 1. Introduction

## 1.1 Purpose and Scope

The Packet FIFO (`pkt_fifo`) is an invented example design of specforge.
It buffers up to four packets between a producer and a consumer on the
same clock; both sides use a valid/ready handshake. This document
describes the complete design: its blocks, every interface signal, the
packet, the read state machine and the outcome of simultaneous operations.

## 1.2 Terminology

**Table 1.1.** Terms used in this document.

| Term | Meaning |
|---|---|
| Producer | The block that writes packets into `pkt_fifo`. |
| Consumer | The block that reads packets from `pkt_fifo`. |
| Write | A cycle in which `in_valid` and `in_ready` are both high. |
| Read | A cycle in which `out_valid` and `out_ready` are both high. |
