# DDCO_Traffic_Lights_Simulation
This Verilog project simulates a 4-way traffic light controller for North, East, South, and West directions. The controller operates cyclically, granting green, yellow, and red signals to each direction in turn using an FSM (Finite State Machine) design.

 # FSM-based traffic light control

Time-multiplexed control for all 4 directions
Encoded light outputs for each direction:
001: Green
010: Yellow
100: Red
Repeats the light cycle sequentially: North → East → South → West

Each direction receives a Green → Yellow → Red sequence.
The transitions are managed based on clock cycles.
# Signal encodings:
north_light[2:0], east_light[2:0], south_light[2:0], west_light[2:0]
Initial direction is North (001), while others are 100 (Red).
The sequence then progresses clockwise every ~30 seconds.
