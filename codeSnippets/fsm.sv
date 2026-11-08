// Copyright (c) 2026 Tej Sanghavi.

// This module serves as a template for a FSM.

`default_nettype none

module fsm
( input  var logic i_clk
  , input  var logic i_arst

  , input  var logic i_stateTransition1
  , input  var logic i_stateTransition2
  , input  var logic i_stateTransition3
  , input  var logic i_stateTransition4

  , output var logic o_state2
  );

  typedef enum logic [1:0]
    { STATE_IDLE
    , STATE_REQUESTING
    , STATE_GRANT
    , STATE_REVOKE
    } ty_STATE_FSM;

  ty_STATE_FSM state_q, state_d;

  always_ff @(posedge i_clk, posedge i_arst)
    if (i_arst)
      state_q <= STATE_IDLE;
    else
      state_q <= state_d;

  always_comb
    case (state_q)
      STATE_IDLE:
        state_d = i_stateTransition1 ? STATE_REQUESTING : STATE_IDLE;
      STATE_REQUESTING:
        state_d = i_stateTransition2 ? STATE_GRANT : STATE_REQUESTING;
      STATE_GRANT:
        state_d = i_stateTransition3 ? STATE_REVOKE : STATE_GRANT;
      STATE_REVOKE:
        state_d = i_stateTransition4 ? STATE_IDLE : STATE_REVOKE;
      default:
        state_d = STATE_IDLE;
    endcase

  always_comb
    if (state_q == STATE_GRANT)
      o_state2 = '1;
    else
      o_state2 = '0;

endmodule

`resetall
