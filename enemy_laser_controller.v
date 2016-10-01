module enemy_laser_controller(
	input clk,
	input [2:0] random_3,
	input [1:0] state,
	input [7:0] enemy_enable,
	output reg [7:0] enemy_waring_enable,
	output reg [7:0] enemy_laser_enable
);	
	always @(posedge clk) begin
		case(state)
			0:	enemy_waring_enable <= 0;
			1:	if(enemy_waring_enable[random_3]==0 && enemy_enable[random_3]==1 && enemy_laser_enable[random_3]==0) enemy_waring_enable[random_3] <= 1;
				else enemy_waring_enable <= 0;
			2:	enemy_waring_enable <= enemy_waring_enable;
			3:	enemy_waring_enable <= enemy_waring_enable;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			0:	enemy_laser_enable <= 0;
			1:	enemy_laser_enable <= enemy_waring_enable;
			2:	enemy_laser_enable <= enemy_laser_enable;
			3:	enemy_laser_enable <= enemy_laser_enable;
		endcase
	end
endmodule