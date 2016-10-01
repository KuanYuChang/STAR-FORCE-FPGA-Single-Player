
module pixel_gen(
	input clk,
	input clk19,
	input reset,
	input [1:0] state,
	input [9:0] plane_h,
	input [9:0] laser_h,
	input [9:0] enemy_0_v,
	input [9:0] enemy_1_v,
	input [9:0] enemy_2_v,
	input [9:0] enemy_3_v,
	input [9:0] enemy_4_v,
	input [9:0] enemy_5_v,
	input [9:0] enemy_6_v,
	input [9:0] enemy_7_v,
	input [11:0] power_RGB,
	input [11:0] power_left,
	input [9:0] h_cnt,
	input [9:0] v_cnt,
	input valid,
	input [7:0] enemy_waring_enable,
	input [7:0] enemy_laser_enable,
	output reg [9:0] enemy_laser_h,
	output [3:0] vgaRed,
	output [3:0] vgaGreen,
	output [3:0] vgaBlue
);
	
	parameter press_start = 0, playing = 1, gamover = 2;
	
	reg [11:0] RGB;
	
	wire [13:0] press_start_addr;
	wire [11:0] press_start_pixel;
	wire [9:0] press_start_h_cnt;
	wire [9:0] press_start_v_cnt;
	
	wire [11:0] game_over_addr;
	wire [11:0] game_over_pixel;
	wire [9:0] game_over_h_cnt;
	wire [9:0] game_over_v_cnt;
	
	wire [9:0] plane_addr;
	wire [11:0] plane_pixel;
	wire [9:0] plane_pixel_h_cnt;
	wire [9:0] plane_pixel_v_cnt;
	
	wire [11:0] laser_addr;
	wire [11:0] laser_pixel;
	wire [9:0] laser_pixel_h_cnt;
	wire [9:0] laser_pixel_v_cnt;
	wire [9:0] power_position = (power_left>>4)+320+25;
	
	reg [9:0] enemy_laser_v;
	wire [11:0] enemy_laser_addr;
	wire [11:0] enemy_laser_pixel;
	wire [9:0] enemy_laser_pixel_h_cnt;
	wire [9:0] enemy_laser_pixel_v_cnt;
	
	wire [9:0] enemy_addr;
	wire [11:0] enemy_pixel;
	wire [11:0] enemy_waring_pixel;
	reg [9:0] enemy_pixel_h_cnt;
	reg [9:0] enemy_pixel_v_cnt;
	
	wire [16:0] background_addr;
	wire [11:0] background_pixel;
	wire [9:0] background_pixel_h_cnt;
	wire [9:0] background_pixel_v_cnt;
	reg [8:0] position;
	
	wire [16:0] information_addr;
	wire [11:0] information_pixel;
	wire [9:0] information_pixel_h_cnt;
	wire [9:0] information_pixel_v_cnt;
	
	assign vgaRed = RGB[11:8];
	assign vgaGreen = RGB[7:4];
	assign vgaBlue = RGB[3:0];
	
	assign press_start_h_cnt = (h_cnt>=GameL+45 && h_cnt<GameR-45)?h_cnt-(GameL+45):0;
	assign press_start_v_cnt = (v_cnt>=GameT+150 && v_cnt<GameB-150)?v_cnt-(GameT+150):0;
	assign press_start_addr = press_start_h_cnt + press_start_v_cnt*150;
	
	assign game_over_h_cnt = (h_cnt>=GameL+20 && h_cnt<GameR-20)?h_cnt-(GameL+20):0;
	assign game_over_v_cnt = (v_cnt>=GameT+190 && v_cnt<GameB-190)?v_cnt-(GameT+190):0;
	assign game_over_addr = game_over_h_cnt + game_over_v_cnt*200;
	
	assign plane_pixel_h_cnt = (h_cnt>=plane_h && h_cnt<plane_h+ObjSize)?h_cnt-plane_h:0;
	assign plane_pixel_v_cnt = (v_cnt>=Plane_v && v_cnt<Plane_v+ObjSize)?v_cnt-Plane_v:0;
	assign plane_addr = plane_pixel_h_cnt + plane_pixel_v_cnt*30;
	
	assign laser_pixel_h_cnt = (h_cnt>=laser_h && h_cnt<laser_h+LaserSize)?h_cnt-laser_h:0;
	assign laser_pixel_v_cnt = (v_cnt>=GameT && v_cnt<Plane_v)?v_cnt-GameT:0;
	assign laser_addr = laser_pixel_h_cnt + laser_pixel_v_cnt*10;
	
	assign enemy_laser_pixel_h_cnt = (h_cnt>=enemy_laser_h && h_cnt<enemy_laser_h+LaserSize)?h_cnt-enemy_laser_h:0;
	assign enemy_laser_pixel_v_cnt = (v_cnt>=enemy_laser_v && v_cnt<GameB)?v_cnt-enemy_laser_v:0;
	assign enemy_laser_addr = enemy_laser_pixel_h_cnt + enemy_laser_pixel_v_cnt*10;
	
	assign enemy_addr = enemy_pixel_h_cnt + enemy_pixel_v_cnt*30;
	
	assign background_pixel_h_cnt = (h_cnt>=GameL && h_cnt<GameR)?h_cnt-GameL:0;
	assign background_pixel_v_cnt = (v_cnt>=GameT && v_cnt<GameB)?v_cnt-GameT:0;
	assign background_addr = (background_pixel_h_cnt + background_pixel_v_cnt*240 + position*240) % 96000;
	
	assign information_pixel_h_cnt = (h_cnt>=320 && h_cnt<640)?h_cnt-320:0;
	assign information_pixel_v_cnt = (v_cnt>=10 && v_cnt<410)?v_cnt-10:0;
	assign information_addr = 127999 - (information_pixel_h_cnt + information_pixel_v_cnt*320);
	
	parameter ObjSize = 30;	
	parameter LaserSize = 10;
	parameter BorderL = 30, BorderR = 290, BorderT = 30, BorderB = 450;
	parameter GameL = 40, GameR = 280, GameT = 40, GameB = 440;
	parameter Boundary = 320;
	parameter Plane_v = 410;
	parameter enemy_0_h = 40;
	parameter enemy_1_h = 70;
	parameter enemy_2_h = 100;
	parameter enemy_3_h = 130;
	parameter enemy_4_h = 160;
	parameter enemy_5_h = 190;
	parameter enemy_6_h = 220;
	parameter enemy_7_h = 250;
	
	always @(*) begin
		if(!valid) RGB = 12'h000;
		else begin
			//left side: border + game
			if(v_cnt>=BorderT && v_cnt<BorderB && h_cnt>=BorderL && h_cnt<BorderR) begin
				//game
				if(v_cnt>=GameT && v_cnt<GameB && h_cnt>=GameL && h_cnt<GameR) begin
					case(state)
						0:	if(v_cnt>=GameT+150 && v_cnt<GameB-150 && h_cnt>=GameL+45 && h_cnt<GameR-45) RGB = (press_start_pixel==0)?background_pixel:press_start_pixel;
							else if(v_cnt>=Plane_v && v_cnt<Plane_v+ObjSize && h_cnt>=plane_h && h_cnt<plane_h+ObjSize)	RGB = (plane_pixel==0)?background_pixel:plane_pixel;
							else RGB = background_pixel;
						1:	if(h_cnt>=enemy_laser_h && h_cnt<enemy_laser_h+LaserSize && v_cnt>=enemy_laser_v && v_cnt<GameB) RGB = (enemy_laser_pixel==0)?background_pixel:enemy_laser_pixel;
							else if(v_cnt>=Plane_v && v_cnt<Plane_v+ObjSize && h_cnt>=plane_h && h_cnt<plane_h+ObjSize)	RGB = (plane_pixel==0)?background_pixel:plane_pixel;
							else if(v_cnt>=GameT && v_cnt<Plane_v && h_cnt>=laser_h && h_cnt<laser_h+LaserSize)	RGB = (laser_pixel==0)?background_pixel:laser_pixel;
							else if(v_cnt>=enemy_0_v && v_cnt<enemy_0_v+ObjSize && h_cnt>=enemy_0_h && h_cnt<enemy_0_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[0]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_1_v && v_cnt<enemy_1_v+ObjSize && h_cnt>=enemy_1_h && h_cnt<enemy_1_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[1]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_2_v && v_cnt<enemy_2_v+ObjSize && h_cnt>=enemy_2_h && h_cnt<enemy_2_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[2]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_3_v && v_cnt<enemy_3_v+ObjSize && h_cnt>=enemy_3_h && h_cnt<enemy_3_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[3]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_4_v && v_cnt<enemy_4_v+ObjSize && h_cnt>=enemy_4_h && h_cnt<enemy_4_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[4]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_5_v && v_cnt<enemy_5_v+ObjSize && h_cnt>=enemy_5_h && h_cnt<enemy_5_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[5]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_6_v && v_cnt<enemy_6_v+ObjSize && h_cnt>=enemy_6_h && h_cnt<enemy_6_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[6]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_7_v && v_cnt<enemy_7_v+ObjSize && h_cnt>=enemy_7_h && h_cnt<enemy_7_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[7]==1)?enemy_waring_pixel:enemy_pixel);
							else RGB = background_pixel;
						2:	if(v_cnt>=GameT+190 && v_cnt<GameB-190 && h_cnt>=GameL+20 && h_cnt<GameR-20) RGB = (game_over_pixel==0)?background_pixel:game_over_pixel;
							else if(h_cnt>=enemy_laser_h && h_cnt<enemy_laser_h+LaserSize && v_cnt>=enemy_laser_v && v_cnt<GameB) RGB = (enemy_laser_pixel==0)?background_pixel:enemy_laser_pixel;
							else if(v_cnt>=Plane_v && v_cnt<Plane_v+ObjSize && h_cnt>=plane_h && h_cnt<plane_h+ObjSize)	RGB = (plane_pixel==0)?background_pixel:plane_pixel;
							else if(v_cnt>=enemy_0_v && v_cnt<enemy_0_v+ObjSize && h_cnt>=enemy_0_h && h_cnt<enemy_0_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[0]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_1_v && v_cnt<enemy_1_v+ObjSize && h_cnt>=enemy_1_h && h_cnt<enemy_1_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[1]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_2_v && v_cnt<enemy_2_v+ObjSize && h_cnt>=enemy_2_h && h_cnt<enemy_2_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[2]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_3_v && v_cnt<enemy_3_v+ObjSize && h_cnt>=enemy_3_h && h_cnt<enemy_3_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[3]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_4_v && v_cnt<enemy_4_v+ObjSize && h_cnt>=enemy_4_h && h_cnt<enemy_4_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[4]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_5_v && v_cnt<enemy_5_v+ObjSize && h_cnt>=enemy_5_h && h_cnt<enemy_5_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[5]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_6_v && v_cnt<enemy_6_v+ObjSize && h_cnt>=enemy_6_h && h_cnt<enemy_6_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[6]==1)?enemy_waring_pixel:enemy_pixel);
							else if(v_cnt>=enemy_7_v && v_cnt<enemy_7_v+ObjSize && h_cnt>=enemy_7_h && h_cnt<enemy_7_h+ObjSize) RGB = (enemy_pixel==0)?background_pixel:((enemy_waring_enable[7]==1)?enemy_waring_pixel:enemy_pixel);
							else RGB = background_pixel;
						3:	RGB = background_pixel;
					endcase
				end
				//border
				else RGB = 12'hfff;
			end
			//information_addr
			else if(v_cnt>=10 && v_cnt<410 && h_cnt>=320 && h_cnt<640) RGB = information_pixel;
			//power
			else if(v_cnt>=430 && v_cnt<440 && h_cnt>=345 && h_cnt<power_position) RGB = power_RGB;
			else RGB = 12'h000;
		end
	end
	
	always @(*) begin	
		if(h_cnt>=enemy_0_h && h_cnt<enemy_0_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_0_h;
		else if(h_cnt>=enemy_1_h && h_cnt<enemy_1_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_1_h;
		else if(h_cnt>=enemy_2_h && h_cnt<enemy_2_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_2_h;
		else if(h_cnt>=enemy_3_h && h_cnt<enemy_3_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_3_h;
		else if(h_cnt>=enemy_4_h && h_cnt<enemy_4_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_4_h;
		else if(h_cnt>=enemy_5_h && h_cnt<enemy_5_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_5_h;
		else if(h_cnt>=enemy_6_h && h_cnt<enemy_6_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_6_h;
		else if(h_cnt>=enemy_7_h && h_cnt<enemy_7_h+ObjSize) enemy_pixel_h_cnt = h_cnt - enemy_7_h;
		else enemy_pixel_h_cnt = 0;
	end

	always @(*) begin	
		if(h_cnt>=enemy_0_h && h_cnt<enemy_0_h+ObjSize && v_cnt>=enemy_0_v && v_cnt<enemy_0_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_0_v;
		else if(h_cnt>=enemy_1_h && h_cnt<enemy_1_h+ObjSize && v_cnt>=enemy_1_v && v_cnt<enemy_1_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_1_v;
		else if(h_cnt>=enemy_2_h && h_cnt<enemy_2_h+ObjSize && v_cnt>=enemy_2_v && v_cnt<enemy_2_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_2_v;
		else if(h_cnt>=enemy_3_h && h_cnt<enemy_3_h+ObjSize && v_cnt>=enemy_3_v && v_cnt<enemy_3_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_3_v;
		else if(h_cnt>=enemy_4_h && h_cnt<enemy_4_h+ObjSize && v_cnt>=enemy_4_v && v_cnt<enemy_4_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_4_v;
		else if(h_cnt>=enemy_5_h && h_cnt<enemy_5_h+ObjSize && v_cnt>=enemy_5_v && v_cnt<enemy_5_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_5_v;
		else if(h_cnt>=enemy_6_h && h_cnt<enemy_6_h+ObjSize && v_cnt>=enemy_6_v && v_cnt<enemy_6_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_6_v;
		else if(h_cnt>=enemy_7_h && h_cnt<enemy_7_h+ObjSize && v_cnt>=enemy_7_v && v_cnt<enemy_7_v+ObjSize) enemy_pixel_v_cnt = v_cnt - enemy_7_v;
		else enemy_pixel_v_cnt = 0;
	end
	
	always @(posedge clk19 or posedge reset) begin
		if(reset) position <= 200;
		else begin
			case(state)
				0:	if(position > 0) position <= position - 1;
					else position <= 400;
				1:	if(position > 0) position <= position - 1;
					else position <= 400;
				2:	position <= position;
				3:	position <= position;
			endcase
		end
	end
	
	always @(*) begin
		if(enemy_laser_enable[0]) enemy_laser_h = enemy_0_h+10;
		else if(enemy_laser_enable[1]) enemy_laser_h = enemy_1_h+10;
		else if(enemy_laser_enable[2]) enemy_laser_h = enemy_2_h+10;
		else if(enemy_laser_enable[3]) enemy_laser_h = enemy_3_h+10;
		else if(enemy_laser_enable[4]) enemy_laser_h = enemy_4_h+10;
		else if(enemy_laser_enable[5]) enemy_laser_h = enemy_5_h+10;
		else if(enemy_laser_enable[6]) enemy_laser_h = enemy_6_h+10;
		else if(enemy_laser_enable[7]) enemy_laser_h = enemy_7_h+10;
		else enemy_laser_h = 0;
	end
	
	always @(*) begin
		if(enemy_laser_enable[0]) enemy_laser_v = enemy_0_v+30;
		else if(enemy_laser_enable[1]) enemy_laser_v = enemy_1_v+30;
		else if(enemy_laser_enable[2]) enemy_laser_v = enemy_2_v+30;
		else if(enemy_laser_enable[3]) enemy_laser_v = enemy_3_v+30;
		else if(enemy_laser_enable[4]) enemy_laser_v = enemy_4_v+30;
		else if(enemy_laser_enable[5]) enemy_laser_v = enemy_5_v+30;
		else if(enemy_laser_enable[6]) enemy_laser_v = enemy_6_v+30;
		else if(enemy_laser_enable[7]) enemy_laser_v = enemy_7_v+30;
		else enemy_laser_v = 0;
	end
	
	press_start press_start_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(press_start_addr),
		.dina(0),
		.douta(press_start_pixel)
	);
	
	game_over game_over_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(game_over_addr),
		.dina(0),
		.douta(game_over_pixel)
	);
	
	plane plane_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(plane_addr),
		.dina(0),
		.douta(plane_pixel)
	);

	laser laser_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(laser_addr),
		.dina(0),
		.douta(laser_pixel)
	);
	
	enemy enemy_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(enemy_addr),
		.dina(0),
		.douta(enemy_pixel)
	);
	
	enemy_laser enemy_laser_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(enemy_laser_addr),
		.dina(0),
		.douta(enemy_laser_pixel)
	);
	
	enemy_waring enemy_waring_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(enemy_addr),
		.dina(0),
		.douta(enemy_waring_pixel)
	);	
	
	background background_pixel_gen(
		.clka(clk),
		.wea(0),
		.addra(background_addr),
		.dina(0),
		.douta(background_pixel)
	);
	
	information_read_only information_pixel_gen(
		.addr(information_addr),
		.pixel(information_pixel)
	);
endmodule
