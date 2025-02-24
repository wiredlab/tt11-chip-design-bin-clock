`default_nettype none

module tt_bin_clock (
    input wire clk_i,
    input wire reset_i,

    input wire time_set,     // 1 bit - change time or let clock run
    input wire id_switch,    // 1 bit - choose to increment or decrement time

    input wire hour_id,     // 1 bit - hour increment/decrement
    input wire minute_id,   // 1 bit - minute increment/decrement
    input wire seconds_id,  // 1 bit - seconds increment/decrement

    output wire [3:0] hour_out,      // 4 bits (for decimal 1-12)
    output wire [5:0] minute_out,    // 5 bits (for decimal 0-60)
    output wire [5:0] seconds_out    // 5 bits (for decimal 0-60)

);

    reg[99:0] clk_cnt = 0;  // external clk is 100Hz, so need to count to 100 to output at 1Hz
    reg[3:0] hours = 0;     // registers to hold time values
    reg[5:0] minutes = 0;
    reg[5:0] seconds = 0;

    always @(posedge reset_i) begin   // reset handler
        if (reset_i) begin
            clk_cnt <= 0;
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
        end
    end

    always @(posedge time_set) begin    // if switch to set time is on
        if (id_switch == 1) begin       // if increment chosen
            if (seconds_id == 1) begin
                seconds <= seconds + 1;
            end
            else if (minute_id == 1) begin
                minutes <= minutes + 1;
            end
            else if (hour_id == 1) begin
                hours <= hours + 1;
            end
        else                            // if decrement chosen
            if (seconds_id == 1) begin
                seconds <= seconds - 1;
            end
            else if (minute_id == 1) begin
                minutes <= minutes - 1;
            end
            else if (hour_id == 1) begin
                hours <= hours - 1;
            end
        end
    end

endmodule

//`default_nettype wire // unsure if this is needed