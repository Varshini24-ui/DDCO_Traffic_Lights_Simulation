`timescale 1s/100ms

module traffic_light_4way_tb();
reg clk;      // Clock signal we'll control
reg rst;      // Reset signal we'll control
wire [2:0] north_light;  // 3-bit output from traffic controller for north
wire [2:0] west_light;
wire [2:0] south_light;
wire [2:0] east_light;

    // Instantiate the traffic light controller
    traffic_light_controller uut(
        .clk(clk),
        .rst(rst),
        .north_light(north_light),
        .west_light(west_light),
        .south_light(south_light),
        .east_light(east_light)
    );

    // Generate clock (1 second period)
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;  // Toggle every 0.5 seconds
    end

    // Test scenario
initial begin
    $dumpfile("traffic_light_4way.vcd");  // Create waveform file
    $dumpvars(0, traffic_light_4way_tb);  // Dump all variables
    
    // Reset sequence
    rst = 1;   // Assert reset
    #2         // Wait 2 seconds
    rst = 0;   // De-assert reset
    
    // Run simulation
    #240       // Run for 240 seconds
    
    $display("Simulation complete");  // Print completion message
    $finish;   // End simulation
end

    // Monitor changes
    always @(north_light, west_light, south_light, east_light) begin
        $display("Time=%0t North=%b West=%b South=%b East=%b", $time, north_light, west_light, south_light, east_light);
    end
endmodule