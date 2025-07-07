module PWM (
    input wire clk,
    input wire rst_n,
    input wire [31:0] duty_cycle, // duty cycle final = duty_cycle / period
    input wire [31:0] period, // pwm_freq = clk_freq / period
    output reg pwm_out
);

    reg [31:0] counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 0;
            pwm_out <= 0;
        end
        else begin
            if (counter >= period-1) begin
                counter <= 32'b0;
            end
            else begin
                counter <= counter + 1;
            end
            pwm_out <= (counter < duty_cycle) ? 1'b1 : 1'b0; 
        end
    end

endmodule