module state_controller(
	input clk,
	input reset,
	input start,
	input [9:0] enemy_laser_h,
	input [9:0] plane_h,
	input [9:0] enemy_0_v,
	input [9:0] enemy_1_v,
	input [9:0] enemy_2_v,
	input [9:0] enemy_3_v,
	input [9:0] enemy_4_v,
	input [9:0] enemy_5_v,
	input [9:0] enemy_6_v,
	input [9:0] enemy_7_v,
	output reg [1:0] state
);

	parameter press_start = 0, playing = 1, gamover = 2;
	parameter gameover_condition = 380;
	
	reg [1:0] next_state;
	
	always @(posedge clk or posedge reset) begin
		if(reset) state <= 0;
		else state <= next_state;
	end
	
	always @(*) begin
		case(state)
			0:	if(start) next_state = playing;
				else next_state = state;
			1:	if(enemy_laser_h >= plane_h && enemy_laser_h < plane_h+20) next_state = gamover;
				else if(enemy_0_v >= 380) next_state = gamover;
				else if(enemy_1_v >= 380) next_state = gamover;
				else if(enemy_2_v >= 380) next_state = gamover;
				else if(enemy_3_v >= 380) next_state = gamover;
				else if(enemy_4_v >= 380) next_state = gamover;
				else if(enemy_5_v >= 380) next_state = gamover;
				else if(enemy_6_v >= 380) next_state = gamover;
				else if(enemy_7_v >= 380) next_state = gamover;
				else next_state = state;
			2:	next_state = state;
			3:	next_state = state;
		endcase
	end
endmodule
