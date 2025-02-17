`default_nettype none

module tt_bin_clock (
    input wire clk_i,
    input wire rstn_i,

    input wire time_set,     // 1 bit - change time or let clock run
    input wire id_switch,    // 1 bit - choose to increment or decrement time

    input wire hour_id,     // 1 bit - hour increment/decrement
    input wire minute_id,   // 1 bit - minute increment/decrement
    input wire seconds_id,  // 1 bit - seconds increment/decrement

    output wire [3:0] hour_out,      // 4 bits (for decimal 1-12)
    output wire [5:0] minute_out,    // 5 bits (for decimal 0-60)
    output wire [5:0] seconds_out    // 5 bits (for decimal 0-60)

);

// for testing
assign hour_out = 11;        // 1011
assign minute_out = 30;      // 0111 10
assign seconds_out = 45;     // 101101

endmodule

//`default_nettype wire // unsure if this is needed