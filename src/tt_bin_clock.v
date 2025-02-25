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

    reg[7:0] clk_cnt = -1;  // external clk is 100Hz, so need to count to 100 to output at 1Hz
    reg[3:0] hours = 0;    // registers to hold time values
    reg[5:0] minutes = 0;
    reg[5:0] seconds = 0;

    always @(posedge clk_i or posedge reset_i) begin   
        if (reset_i) begin  // reset handler
            clk_cnt <= 0;
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
        end
        else if (!time_set) begin       // clock operation
            if (clk_cnt == 99) begin    // every 100 clk cycles is one second
                clk_cnt <= 0;
                seconds <= seconds + 1;
                if (seconds == 59) begin
                    seconds <= 0;
                    minutes <= minutes + 1;
                    if (minutes == 59) begin
                        minutes <= 0;
                        hours <= hours + 1;
                        if (hours == 13) begin
                            hours <= 1;
                        end
                    end
                end
            end
            else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end

    always @(posedge time_set) begin    // if switch to set time is on
        if (id_switch == 1) begin       // if increment chosen
            if (seconds_id == 1) begin
                seconds <= seconds + 1;
                if (seconds == 60) begin
                    seconds <= 0;
                end
            end
            else if (minute_id == 1) begin
                minutes <= minutes + 1;
                if (minutes == 60) begin
                    minutes <= 0;
                end
            end
            else if (hour_id == 1) begin
                hours <= hours + 1;
                if (hours == 13) begin
                    hours <= 1;
                end
            end
        else                            // if decrement chosen
            if (seconds_id == 1) begin
                seconds <= seconds - 1;
                if (seconds == -1) begin
                    seconds <= 59;
                end
            end
            else if (minute_id == 1) begin
                minutes <= minutes - 1;
                if (minutes == -1) begin
                    minutes <= 59;
                end
            end
            else if (hour_id == 1) begin
                hours <= hours - 1;
                if (hours == 0) begin
                    hours <= 12;
                end
            end
        end
    end

    assign seconds_out = seconds;   // wires cannot be assigned inside an always block
    assign minute_out = minutes;
    assign hour_out = hours;

endmodule