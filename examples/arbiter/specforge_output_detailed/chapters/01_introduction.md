# 1. Introduction

## 1.1 Purpose and Scope

The Request Arbiter (`req_arbiter`) is an invented example design of
specforge. It forwards request packets from two ports, A and B, to one
output, one packet at a time, and alternates between the ports when both
request in the same cycle. This document describes the complete design:
its organization, every interface signal, the request packet, the grant
state machine and the timing of one transfer.

## 1.2 Terminology

**Table 1.1.** Terms used in this document.

| Term | Meaning |
|---|---|
| Port | One of the two request sources, A or B. |
| Request packet | The `req_pkt_t` structure that a port sends with its request. |
| Grant | The one-cycle signal that tells a port that its packet is taken. |
| Transfer | One packet, from its grant to the acknowledgement of the output. |
