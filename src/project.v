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
 * Bit | Hours 	 Minutes 	 Meridiem
 * 32  |     	      1          
 * 16  |    	      0
 * 8 	 |  0 	      0
 * 4 	 |  1 	      1
 * 2 	 |  1 	      0         
 * 1 	 |  0 	      1          1
 * ----------------------------------
 * Dec	  6 	 :    37         PM
 * 
 * Or sideways:              
 * ----------------------------------
 * Bit      | 32 16 8 4 2 1 | Decimal
 * ----------------------------------
 * Hours    |       0 1 1 0 | 6
 * Minutes  |  1  0 0 1 0 1 | 37
 * Meridiem |             1 | PM
 * ----------------------------------
 */

`default_nettype none

module tt11_um_obliviouX (
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

    .hour_id(ui_in[4:3]),       // hour increment/decrement
    .minute_id(ui_in[2:1]),     // minute increment/decrement
    .meridiem_id(ui_in[0]),     // meridiem toggle

    .hour_out(uo_out[4:0]),     // hour LED output, 5 LEDs
    .minute_out(uio_out[6:1]),  // minute LED output, 6 LEDs
    .meridiem_out(uio_out[0])   // meridiem LED output, 1 LED
  );

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uo_out[7:5] = 0;
  assign uio_out[7] = 0;
  assign uio_oe  = 8'b00000000;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
