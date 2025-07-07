module servo #(
    parameter CLK_FREQ = 25_000_000, // 25 MHz
    parameter PERIOD = 500_000 // 50 Hz (1/50s = 20ms, 25MHz / 50Hz = 500000 cycles)
) (
    input wire clk,
    input wire rst_n,
    output wire servo_out
);

    wire [31:0] duty_cycle;
    reg [31:0] contador; // 10 secs
    reg condicional;

    assign duty_cycle = (condicional) ? (PERIOD * 0.1) : (PERIOD * 0.05); // 10% e 5%

    always @(posedge clk) begin
        if (!rst_n) begin
            contador <= 0;
            condicional <= 0;
        end
        else begin
            if (contador >= (CLK_FREQ * 10) - 1) begin // 10 vezes o ciclo do clock
                contador <= 0;
            end
            else begin
                contador <= contador + 1;
            end

            if(contador < (CLK_FREQ * 5) - 1) begin //metade do tempo
                condicional <= 0;
            end
            else begin
                condicional <= 1;
            end
        end
    end

    PWM pwm_servo(
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle),
        .period(PERIOD),
        .pwm_out(servo_out)
    );



endmodule