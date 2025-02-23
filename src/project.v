/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

/*
 * Binary-coded Base 60 Clock 
 * ==========================
 * The hour is represented using 4 bits (12 hours).
 * The minute is represented using 6 bits (60 minutes).
 * The meridiems (AM and PM) are represented using 1 bit (AM=0 PM=1)
 * There are not enough outputs available to include seconds
 *
 * The final design with the LEDs in place should look like this example:   
 * ----------------------------------
 * Bit      | 32 16 8 4 2 1 | Decimal
 * ----------------------------------
 * Hours    |       0 1 1 0 | 6
 * Minutes  |  1  0 0 1 0 1 | 37
 * Seconds  |  0  1 0 0 1 0 | 18
 * ----------------------------------
 */

`default_nettype none

module tt_um_obliviouX (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  tt_bin_clock bin_clock (      // internal sub module to make routing easier/more understandable
    .clk_i(clk),                // internal clock
    .rstn_i(rst_n),             // internal reset

    .time_set(ui_in[4]),       // switch to choose to set the time (=1) or let the clock run (=0)
    .id_switch(ui_in[3]),      // switch to choose increment (=1) or decrement (=0)

    .hour_id(ui_in[2]),       // hour increment/decrement
    .minute_id(ui_in[1]),     // minute increment/decrement
    .seconds_id(ui_in[0]),    // seconds increment/decrement

    .hour_out(uo_out[7:4]),                    // hour LED output, 4 LEDs
    .minute_out({uo_out[3:0], uio_out[7:6]}),  // minute LED output, 6 LEDs , this needs to be split between uo_out and uio_out
    .seconds_out(uio_out[5:0])                 // seconds LED output, 6 LEDs
  );

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_oe[7:0]  = 1; // want all the configurable IOs to be outputs

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, ui_in[7:5], 1'b0};

endmodule
