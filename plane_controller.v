module plane_controller(
	input clk,
	input [1:0] state,
	input [511:0] key_down,
	input [8:0] last_change,
	input been_ready,
	output reg [9:0] plane_h,
	output reg laser_attack
);
	
	parameter press_start = 0, playing = 1, gamover = 2;
	
	parameter Initial = 145;
	parameter LimitL = 40;
	parameter LimitR = 250;

	parameter [8:0] MoveLEFT  = 9'b0_0001_1100; //A
	parameter [8:0] MoveRIGHT = 9'b0_0010_0011; //D
	parameter [8:0] LaserEnable = 9'b0_0001_1101; //w
	
	always @(posedge clk) begin
		case(state)
			0:	plane_h <= Initial;
			1:	if(key_down[MoveLEFT] == 1'b1) begin
				if(plane_h == LimitL) plane_h <= plane_h;
				else plane_h <= plane_h - 1;
				end
				else if(key_down[MoveRIGHT] == 1'b1) begin
					if(plane_h == LimitR) plane_h <= plane_h;
					else plane_h <= plane_h + 1;
				end
			2:	plane_h <= plane_h;
			3:	plane_h <= Initial;
		endcase
	end
	
	always @(posedge clk) begin
		if(key_down[LaserEnable] == 1'b1) laser_attack <= 1;
		else laser_attack <= 0;
	end
	
endmodule
