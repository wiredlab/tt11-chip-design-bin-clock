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
    reg[3:0] hours = 0;     // registers to hold time values
    reg[5:0] minutes = 0;
    reg[5:0] seconds = 0;

    // button state registers
    reg prev_hour_id = 0;
    reg prev_minute_id = 0;
    reg prev_seconds_id = 0;
    
    always @(posedge clk_i or posedge reset_i) begin   
        if (reset_i) begin  // reset handler
            clk_cnt <= -1;
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
            prev_hour_id <= 0;
            prev_minute_id <= 0;
            prev_seconds_id <= 0;
        end
        else if (time_set) begin
            if (id_switch) begin       // if increment chosen
                if (seconds_id && !prev_seconds_id) begin
                    seconds <= seconds + 1;
                    if (seconds == 59) begin
                        seconds <= 0;
                    end
                end
                else if (minute_id && !prev_minute_id) begin
                    minutes <= minutes + 1;
                    if (minutes == 59) begin
                    minutes <= 0;
                    end
                end
                else if (hour_id && !prev_hour_id) begin
                    hours <= hours + 1;
                    if (hours == 12) begin
                        hours <= 1;
                    end
                end
            end
            else if (id_switch == 0) begin     // if decrement chosen
                if (seconds_id == 1 && !prev_seconds_id) begin
                    seconds <= seconds - 1;
                    if ((seconds == -1) || (seconds == 0)) begin
                        seconds <= 59;
                    end
                end
                else if (minute_id && !prev_minute_id) begin
                    minutes <= minutes - 1;
                    if ((minutes == -1) || (minutes == 0)) begin
                        minutes <= 59;
                    end
                end
                else if (hour_id && !prev_hour_id) begin
                    hours <= hours - 1;
                    if ((hours == 1) || (hours == 0)) begin
                        hours <= 12;
                    end
                end
            end
            // reset the clk_cnt to fully count one second
            clk_cnt <= -1;   

            // update previous registers for next clk cycle
            prev_seconds_id <= seconds_id;  
            prev_minute_id <= minute_id;
            prev_hour_id <= hour_id;
        end
        else begin       // clock operation

            // check one clock cycle ahead of time to set the roll over hour at the correct clk cycle
            if ((clk_cnt == 98) && (hours == 12) && (minutes == 59) && (seconds == 59)) begin
                hours <= 0;
            end
            
            // every 100 clk cycles is one second
            if (clk_cnt == 99) begin    
                clk_cnt <= 0;
                seconds <= seconds + 1;
                if (seconds == 59) begin
                    seconds <= 0;
                    minutes <= minutes + 1;
                    if (minutes == 59) begin
                        minutes <= 0;
                        hours <= hours + 1;
                    end
                end
            end
            else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end
    
    // wires cannot be assigned inside an always block
    assign seconds_out = seconds;   
    assign minute_out = minutes;
    assign hour_out = hours;

endmodule
