module score_controller(
	input clk,
	input [1:0] state,
	input [7:0] enemy_enable,
	input laser_enable,
	input [3:0] attack_valid,
	input [9:0] attack_v,
	output [15:0] score
);
	
	reg [3:0] ones, tens, hundreds, thousands;
	
	always @(posedge clk) begin
		case(state)
			0:	ones <= 0;
			1:	if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && ones<9) ones <= ones + 1;
				else if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && ones>=9) ones <= 0;
				else ones <= ones;
			2:	ones <= ones;
			3:	ones <= ones;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	tens <= 0;
			1:	if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && tens<9 && ones>=9) tens <= tens + 1;
				else if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && tens>=9 && ones>=9) tens <= 0;
				else tens <= tens;
			2:	tens <= tens;
			3:	tens <= tens;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	hundreds <= 0;
			1:	if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && hundreds<9 && tens>=9 && ones>=9) hundreds <= hundreds + 1;
				else if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && hundreds>=9 && tens>=9 && ones>=9) hundreds <= 0;
				else hundreds <= hundreds;
			2:	hundreds <= hundreds;
			3:	hundreds <= hundreds;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	thousands <= 0;
			1:	if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && thousands<9 && hundreds>=9 && tens>=9 && ones>=9) thousands <= thousands + 1;
				else if(attack_v>=10 && laser_enable && attack_valid<8 && enemy_enable[attack_valid]==0 && thousands>=9 && hundreds>=9 && tens>=9 && ones>=9) thousands <= 0;
				else thousands <= thousands;
			2:	thousands <= thousands;
			3:	thousands <= thousands;
		endcase
	end
	
	assign score = {thousands, hundreds, tens, ones};
endmodule
