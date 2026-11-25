// Top level: forwards one request packet at a time from port A or B.
module req_arbiter
  import arb_pkg::*;
(
  input  logic     clk,
  input  logic     reset_n,
  input  logic     req_a,
  input  req_pkt_t pkt_a,
  input  logic     req_b,
  input  req_pkt_t pkt_b,
  input  logic     ack_i,
  output logic     grant_a,
  output logic     grant_b,
  output logic     valid_o,
  output req_pkt_t pkt_o
);

  arb_fsm FSM (
    .clk, .reset_n, .req_a, .req_b, .ack_i,
    .grant_a, .grant_b
  );

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      valid_o <= 1'b0;
      pkt_o   <= '0;
    end else if (grant_a || grant_b) begin
      valid_o <= 1'b1;
      pkt_o   <= grant_b ? pkt_b : pkt_a;
    end else if (ack_i) begin
      valid_o <= 1'b0;
    end
  end
endmodule
