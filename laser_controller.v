module laser_controller(
	input clk,
	input [1:0] state,
	input laser_attack,
	input [9:0] plane_h,
	output laser_enable,
	output [9:0] laser_h,
	output [11:0] power_left,
	output [11:0] power_RGB
);

	parameter press_start = 0, playing = 1, gamover = 2;
	
	reg [11:0] counter;

	always @(posedge clk) begin
		case(state)
			0:	counter <= 12'hfff;
			1:	if(laser_attack && counter > 0) counter <= counter - 1;
				else counter <= counter;
			2:	counter <= counter;
			3:	counter <= 0;
		endcase
	end
	
	assign laser_h = (laser_enable == 1'b1)?plane_h+10:0;
	assign laser_enable = (state==1 && laser_attack && counter>0)?1:0;
	assign power_left = counter;
	assign power_RGB[11:8] = (counter[11:4]>0)?4'hf:counter[3:0];
	assign power_RGB[7:4] = (counter[11:8]>0)?4'hf:counter[7:4];
	assign power_RGB[3:0] = counter[11:8];
endmodule
