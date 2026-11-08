// Copyright (c) 2026 Tej Sanghavi.

// Generic closed-loop CDC synchronizer.

// The sending domain toggles an initiate bit and holds the associated data.
// The toggle is resynchronized into the receiving domain with sync_bit and
// either edge is detected to sample the data. The receiving domain then
// toggles a complete bit which is resynchronized back to the sending domain
// and edge-detected to flag that the round trip has finished.

// Integration protocol:
// 1. Drive the payload on i_sendData and pulse i_sendInitiateSync_p for one
//    i_sendClk cycle. The payload is latched internally on that cycle, so
//    i_sendData need not be held stable afterwards.
// 2. In the receiving domain, o_receiveSample_p pulses for one i_receiveClk
//    cycle when the transfer arrives; o_receiveData presents the captured
//    payload and holds it until the next transfer.
// 3. o_sendSyncComplete_p then pulses for one i_sendClk cycle to acknowledge
//    that the payload has been sampled and the round trip is complete.
// NOTE: Do not pulse i_sendInitiateSync_p again until o_sendSyncComplete_p
//       has pulsed: only one transfer may be in flight at a time.

`default_nettype none

module closedLoopSynchronizer
#(parameter int unsigned DATA_WIDTH  = 1
  // Number of synchronizer stages in sync_bit.
, parameter int unsigned SYNC_STAGES = 2
)
( // Sending clock domain
  input  var logic                  i_sendClk
, input  var logic                  i_sendArst_n
, input  var logic [DATA_WIDTH-1:0] i_sendData
, input  var logic                  i_sendInitiateSync_p
, output var logic                  o_sendSyncComplete_p
  // Receiving clock domain
, input  var logic                  i_receiveClk
, input  var logic                  i_receiveArst_n
, output var logic [DATA_WIDTH-1:0] o_receiveData
, output var logic                  o_receiveSample_p
);

  // {{{ Sending domain: initiate toggle and data hold
  // Each sync request flips the initiate toggle; the toggle edge carries the
  // event across the CDC. The payload is held for the whole round trip so the
  // multi-bit crossing is stable while the toggle traverses the synchronizer.

  logic sendInitiateToggle_q;

  always_ff @(posedge i_sendClk, negedge i_sendArst_n)
    if (!i_sendArst_n)
      sendInitiateToggle_q <= '0;
    else if (i_sendInitiateSync_p)
      sendInitiateToggle_q <= !sendInitiateToggle_q;
    else
      sendInitiateToggle_q <= sendInitiateToggle_q;

  logic [DATA_WIDTH-1:0] sendDataHold_q;

  always_ff @(posedge i_sendClk, negedge i_sendArst_n)
    if (!i_sendArst_n)
      sendDataHold_q <= '0;
    else if (i_sendInitiateSync_p)
      sendDataHold_q <= i_sendData;
    else
      sendDataHold_q <= sendDataHold_q;

  // }}} Sending domain: initiate toggle and data hold

  // {{{ Receiving domain: resynchronize, edge detect and sample
  // The initiate toggle is resynchronized and delayed one cycle so that either
  // edge produces a one-cycle sample event. The sample pulse and the captured
  // payload are registered on the same event so o_receiveSample_p and
  // o_receiveData are aligned. The complete toggle then flips to start the
  // return path.

  logic receiveInitiateSync;

  sync_bit
  #(.LEVELS        (SYNC_STAGES)
  , .RST_REG_VALUE (0)
  , .CELL_TYPE     ("V")
  ) u_receiveInitiateSync
  ( .clk       (i_receiveClk)
  , .rst_n     (i_receiveArst_n)
  , .raw_input (sendInitiateToggle_q)
  , .sync_out  (receiveInitiateSync)
  );

  logic receiveInitiateSync_q;

  always_ff @(posedge i_receiveClk, negedge i_receiveArst_n)
    if (!i_receiveArst_n)
      receiveInitiateSync_q <= '0;
    else
      receiveInitiateSync_q <= receiveInitiateSync;

  logic receiveSampleEvent_p;

  always_ff @(posedge i_receiveClk, negedge i_receiveArst_n)
    if (!i_receiveArst_n)
      o_receiveSample_p <= '0;
    else
      o_receiveSample_p <= receiveSampleEvent_p;

  always_ff @(posedge i_receiveClk, negedge i_receiveArst_n)
    if (!i_receiveArst_n)
      o_receiveData <= '0;
    else if (receiveSampleEvent_p)
      o_receiveData <= sendDataHold_q;
    else
      o_receiveData <= o_receiveData;

  always_comb
    receiveSampleEvent_p = receiveInitiateSync ^ receiveInitiateSync_q;

  logic receiveCompleteToggle_q;

  always_ff @(posedge i_receiveClk, negedge i_receiveArst_n)
    if (!i_receiveArst_n)
      receiveCompleteToggle_q <= '0;
    else if (receiveSampleEvent_p)
      receiveCompleteToggle_q <= !receiveCompleteToggle_q;
    else
      receiveCompleteToggle_q <= receiveCompleteToggle_q;

  // }}} Receiving domain: resynchronize, edge detect and sample

  // {{{ Sending domain: resynchronize and edge detect complete
  // The complete toggle is resynchronized back to the sending domain and
  // delayed one cycle; either edge produces the registered
  // o_sendSyncComplete_p pulse that ends the round trip.

  logic sendCompleteSync;

  sync_bit
  #(.LEVELS        (SYNC_STAGES)
  , .RST_REG_VALUE (0)
  , .CELL_TYPE     ("V")
  ) u_sendCompleteSync
  ( .clk       (i_sendClk)
  , .rst_n     (i_sendArst_n)
  , .raw_input (receiveCompleteToggle_q)
  , .sync_out  (sendCompleteSync)
  );

  logic sendCompleteSync_q;

  always_ff @(posedge i_sendClk, negedge i_sendArst_n)
    if (!i_sendArst_n)
      sendCompleteSync_q <= '0;
    else
      sendCompleteSync_q <= sendCompleteSync;

  logic sendCompleteEvent_p;

  always_ff @(posedge i_sendClk, negedge i_sendArst_n)
    if (!i_sendArst_n)
      o_sendSyncComplete_p <= '0;
    else
      o_sendSyncComplete_p <= sendCompleteEvent_p;

  always_comb
    sendCompleteEvent_p = sendCompleteSync ^ sendCompleteSync_q;

  // }}} Sending domain: resynchronize and edge detect complete

endmodule

`resetall
