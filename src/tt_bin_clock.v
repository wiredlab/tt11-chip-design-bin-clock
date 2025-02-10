`default_nettype none

module tt_bin_clock (
    input wire clk_i,
    input wire rstn_i,
    input wire [1:0] hour_id,
    input wire [1:0] minute_id,
    input wire [1:0] seconds_id,
    output reg [3:0] hour_out,
    output reg [5:0] minute_out,
    output reg [5:0] seconds_out

);

endmodule

//`default_nettype wire // unsure if this is needed