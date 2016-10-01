module enemy_controller(
	input clk,
	input [2:0] random_3,
	input [9:0] laser_h,
	input laser_enable,
	input [1:0]  state,
	output reg [9:0] enemy_0_v,
	output reg [9:0] enemy_1_v,
	output reg [9:0] enemy_2_v,
	output reg [9:0] enemy_3_v,
	output reg [9:0] enemy_4_v,
	output reg [9:0] enemy_5_v,
	output reg [9:0] enemy_6_v,
	output reg [9:0] enemy_7_v,
	output reg [7:0] enemy_enable,
	output reg [3:0] attack_valid,
	output reg [9:0] attack_v
);
	
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_enable <= 0;
			1:	if(enemy_enable[random_3] == 0) enemy_enable[random_3] <= 1;
				else if(attack_v >= 10 && laser_enable && attack_valid < 8) enemy_enable[attack_valid] <= 0;
				else enemy_enable <= enemy_enable;
			2:	enemy_enable <= enemy_enable;
			3:	enemy_enable <= enemy_enable;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	attack_valid <= 8;
			1:	if(laser_enable) begin
					if(laser_h >= 40 && laser_h < 60) attack_valid <= 0;
					else if(laser_h >= 70 && laser_h < 90) attack_valid <= 1;
					else if(laser_h >= 100 && laser_h < 120) attack_valid <= 2;
					else if(laser_h >= 130 && laser_h < 150) attack_valid <= 3;
					else if(laser_h >= 160 && laser_h < 180) attack_valid <= 4;
					else if(laser_h >= 190 && laser_h < 210) attack_valid <= 5;
					else if(laser_h >= 220 && laser_h < 240) attack_valid <= 6;
					else if(laser_h >= 250 && laser_h < 270) attack_valid <= 7;
					else attack_valid <= 8;
				end
				else attack_valid <= 8;
			2:	attack_valid <= 8;
			3:	attack_valid <= 8;
		endcase
	end
	
	always @(*) begin
		case(attack_valid)
			0:	attack_v = enemy_0_v;
			1:	attack_v = enemy_1_v;
			2:	attack_v = enemy_2_v;
			3:	attack_v = enemy_3_v;
			4:	attack_v = enemy_4_v;
			5:	attack_v = enemy_5_v;
			6:	attack_v = enemy_6_v;
			7:	attack_v = enemy_7_v;
			default: attack_v = 0;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_0_v <= 0;
			1:	if(enemy_enable[0]) begin
					if(enemy_0_v < 380)enemy_0_v <= enemy_0_v + 1;
					else enemy_0_v <= enemy_0_v;
				end
				else enemy_0_v <= 0;
			2:	enemy_0_v <= enemy_0_v;
			3:	enemy_0_v <= enemy_0_v;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_1_v <= 0;
			1:	if(enemy_enable[1]) begin
					if(enemy_1_v < 380)enemy_1_v <= enemy_1_v + 1;
					else enemy_1_v <= enemy_1_v;
				end
				else enemy_1_v <= 0;
			2:	enemy_1_v <= enemy_1_v;
			3:	enemy_1_v <= enemy_1_v;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_2_v <= 0;
			1:	if(enemy_enable[2]) begin
					if(enemy_2_v < 380)enemy_2_v <= enemy_2_v + 1;
					else enemy_2_v <= enemy_2_v;
				end
				else enemy_2_v <= 0;
			2:	enemy_2_v <= enemy_2_v;
			3:	enemy_2_v <= enemy_2_v;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_3_v <= 0;
			1:	if(enemy_enable[3]) begin
					if(enemy_3_v < 380)enemy_3_v <= enemy_3_v + 1;
					else enemy_3_v <= enemy_3_v;
				end
				else enemy_3_v <= 0;
			2:	enemy_3_v <= enemy_3_v;
			3:	enemy_3_v <= enemy_3_v;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_4_v <= 0;
			1:	if(enemy_enable[4]) begin
					if(enemy_4_v < 380)enemy_4_v <= enemy_4_v + 1;
					else enemy_4_v <= enemy_4_v;
				end
				else enemy_4_v <= 0;
			2:	enemy_4_v <= enemy_4_v;
			3:	enemy_4_v <= enemy_4_v;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_5_v <= 0;
			1:	if(enemy_enable[5]) begin
					if(enemy_5_v < 380)enemy_5_v <= enemy_5_v + 1;
					else enemy_5_v <= enemy_5_v;
				end
				else enemy_5_v <= 0;
			2:	enemy_5_v <= enemy_5_v;
			3:	enemy_5_v <= enemy_5_v;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_6_v <= 0;
			1:	if(enemy_enable[6]) begin
					if(enemy_6_v < 380)enemy_6_v <= enemy_6_v + 1;
					else enemy_6_v <= enemy_6_v;
				end
				else enemy_6_v <= 0;
			2:	enemy_6_v <= enemy_6_v;
			3:	enemy_6_v <= enemy_6_v;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_7_v <= 0;
			1:	if(enemy_enable[7]) begin
					if(enemy_7_v < 380)enemy_7_v <= enemy_7_v + 1;
					else enemy_7_v <= enemy_7_v;
				end
				else enemy_7_v <= 0;
			2:	enemy_7_v <= enemy_7_v;
			3:	enemy_7_v <= enemy_7_v;
		endcase
	end
endmodule
