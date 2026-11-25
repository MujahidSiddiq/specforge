// Invented example design for specforge: a two-port request arbiter.
package arb_pkg;
  typedef struct packed {
    logic [1:0]  id;
    logic [7:0]  addr;
    logic [15:0] data;
  } req_pkt_t;
endpackage
