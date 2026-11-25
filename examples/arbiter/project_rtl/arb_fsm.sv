// Grant state machine: alternates the grant when both ports request.
module arb_fsm (
  input  logic clk,
  input  logic reset_n,
  input  logic req_a,
  input  logic req_b,
  input  logic ack_i,
  output logic grant_a,
  output logic grant_b
);
  typedef enum logic [1:0] { IDLE = 2'd0, GRANT_A = 2'd1, GRANT_B = 2'd2, WAIT_ACK = 2'd3 } state_t;
  state_t state, next;
  logic   last_b;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state  <= IDLE;
      last_b <= 1'b1;
    end else begin
      state <= next;
      if (state == GRANT_A) last_b <= 1'b0;
      if (state == GRANT_B) last_b <= 1'b1;
    end
  end

  always_comb begin
    next = state;
    case (state)
      IDLE:     if (req_a && (!req_b || last_b)) next = GRANT_A;
                else if (req_b)                  next = GRANT_B;
      GRANT_A:  next = WAIT_ACK;
      GRANT_B:  next = WAIT_ACK;
      WAIT_ACK: if (ack_i) next = IDLE;
    endcase
  end

  assign grant_a = (state == GRANT_A);
  assign grant_b = (state == GRANT_B);
endmodule
