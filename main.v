// Traffic Light Controller for 4-way intersection
// North, West, South, East
module traffic_light_controller(
    input wire clk,      // Clock input (1 Hz - one tick per second)
    input wire rst,      // Reset signal
    output reg [2:0] north_light,
    output reg [2:0] west_light,
    output reg [2:0] south_light,
    output reg [2:0] east_light
);

    // State definitions
    parameter S_NORTH_GREEN  = 3'b000;  // North Green, others Red
    parameter S_NORTH_YELLOW = 3'b001;  // North Yellow, others Red
    parameter S_WEST_GREEN   = 3'b010;  // West Green, others Red 
    parameter S_WEST_YELLOW  = 3'b011;  // West Yellow, others Red
    parameter S_SOUTH_GREEN  = 3'b100;  // South Green, others Red
    parameter S_SOUTH_YELLOW = 3'b101;  // South Yellow, others Red
    parameter S_EAST_GREEN   = 3'b110;  // East Green, others Red
    parameter S_EAST_YELLOW  = 3'b111;  // East Yellow, others Red

    // Timing definitions (in seconds)
    parameter GREEN_TIME  = 25;  // Green light duration
    parameter YELLOW_TIME = 5;   // Yellow light duration
    // Red light duration = 60s - (Green + Yellow)

    // Internal signals
    reg [2:0] current_state, next_state;
    reg [5:0] timer;  // 6-bit timer can count up to 63 seconds

    // State register with reset for every positive edge trigered
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S_NORTH_GREEN;  // Start with North Green
        else
            current_state <= next_state;
    end

    // Timer counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timer <= 0;
        end
        else begin
            case (current_state)
                S_NORTH_GREEN, S_WEST_GREEN, S_SOUTH_GREEN, S_EAST_GREEN: begin
                    if (timer >= GREEN_TIME-1)  // Count 25 seconds
                        timer <= 0;
                    else
                        timer <= timer + 1;
                end
                
                S_NORTH_YELLOW, S_WEST_YELLOW, S_SOUTH_YELLOW, S_EAST_YELLOW: begin
                    if (timer >= YELLOW_TIME-1)  // Count 5 seconds
                        timer <= 0;
                    else
                        timer <= timer + 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S_NORTH_GREEN: begin
                if (timer >= GREEN_TIME-1)  // After 25 seconds
                    next_state = S_NORTH_YELLOW;
                else
                    next_state = S_NORTH_GREEN;
            end

            S_NORTH_YELLOW: begin
                if (timer >= YELLOW_TIME-1)  // After 5 seconds
                    next_state = S_WEST_GREEN;
                else
                    next_state = S_NORTH_YELLOW;
            end

            S_WEST_GREEN: begin
                if (timer >= GREEN_TIME-1)  // After 25 seconds
                    next_state = S_WEST_YELLOW;
                else
                    next_state = S_WEST_GREEN;
            end

            S_WEST_YELLOW: begin
                if (timer >= YELLOW_TIME-1)  // After 5 seconds
                    next_state = S_SOUTH_GREEN;
                else
                    next_state = S_WEST_YELLOW;
            end

            S_SOUTH_GREEN: begin
                if (timer >= GREEN_TIME-1)  // After 25 seconds
                    next_state = S_SOUTH_YELLOW;
                else
                    next_state = S_SOUTH_GREEN;
            end

            S_SOUTH_YELLOW: begin
                if (timer >= YELLOW_TIME-1)  // After 5 seconds
                    next_state = S_EAST_GREEN;
                else
                    next_state = S_SOUTH_YELLOW;
            end

            S_EAST_GREEN: begin
                if (timer >= GREEN_TIME-1)  // After 25 seconds
                    next_state = S_EAST_YELLOW;
                else
                    next_state = S_EAST_GREEN;
            end

            S_EAST_YELLOW: begin
                if (timer >= YELLOW_TIME-1)  // After 5 seconds
                    next_state = S_NORTH_GREEN;
                else
                    next_state = S_EAST_YELLOW;
            end

            default: next_state = S_NORTH_GREEN;
        endcase
    end

    // Light control logic
    always @(*) begin
        case (current_state)
            S_NORTH_GREEN: begin
                north_light = 3'b001;  // GREEN  (001)
                west_light  = 3'b100;  // RED    (100)
                south_light = 3'b100;  // RED    (100)
                east_light  = 3'b100;  // RED    (100)
            end

            S_NORTH_YELLOW: begin
                north_light = 3'b010;  // YELLOW (010)
                west_light  = 3'b100;  // RED    (100)
                south_light = 3'b100;  // RED    (100)
                east_light  = 3'b100;  // RED    (100)
            end

            S_WEST_GREEN: begin
                north_light = 3'b100;  // RED    (100)
                west_light  = 3'b001;  // GREEN  (001)
                south_light = 3'b100;  // RED    (100)
                east_light  = 3'b100;  // RED    (100)
            end

            S_WEST_YELLOW: begin
                north_light = 3'b100;  // RED    (100)
                west_light  = 3'b010;  // YELLOW (010)
                south_light = 3'b100;  // RED    (100)
                east_light  = 3'b100;  // RED    (100)
            end

            S_SOUTH_GREEN: begin
                north_light = 3'b100;  // RED    (100)
                west_light  = 3'b100;  // RED    (100)
                south_light = 3'b001;  // GREEN  (001)
                east_light  = 3'b100;  // RED    (100)
            end

            S_SOUTH_YELLOW: begin
                north_light = 3'b100;  // RED    (100)
                west_light  = 3'b100;  // RED    (100)
                south_light = 3'b010;  // YELLOW (010)
                east_light  = 3'b100;  // RED    (100)
            end

            S_EAST_GREEN: begin
                north_light = 3'b100;  // RED    (100)
                west_light  = 3'b100;  // RED    (100)
                south_light = 3'b100;  // RED    (100)
                east_light  = 3'b001;  // GREEN  (001)
            end

            S_EAST_YELLOW: begin
                north_light = 3'b100;  // RED    (100)
                west_light  = 3'b100;  // RED    (100)
                south_light = 3'b100;  // RED    (100)
                east_light  = 3'b010;  // YELLOW (010)
            end

            default: begin
                north_light = 3'b100;  // RED    (100)
                west_light  = 3'b100;  // RED    (100)
                south_light = 3'b100;  // RED    (100)
                east_light  = 3'b100;  // RED    (100)
            end
        endcase
    end

endmodule