module top(
	input clk,
	input rst,
	input start,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	output [3:0] vgaRed,
	output [3:0] vgaGreen,
	output [3:0] vgaBlue,
	output hsync,
	output vsync,
	output [6:0] display,
	output [3:0] digit
);

	wire clk_25MHz;
	wire clk_19;
	wire clk_20;
	wire clk_26;
	wire clk_27;
	wire valid;
	wire [9:0] h_cnt;	//640
	wire [9:0] v_cnt;	//480
	
	wire [1:0] state;
	
	wire [9:0] plane_h;
	wire [9:0] laser_h;
	wire [9:0] enemy_laser_h;
	
	wire laser_attack;
	wire laser_enable;
	wire [11:0] power_RGB;
	wire [11:0] power_left;
	
	wire [2:0] random_3;
	wire [9:0] enemy_0_v;
	wire [9:0] enemy_1_v;
	wire [9:0] enemy_2_v;
	wire [9:0] enemy_3_v;
	wire [9:0] enemy_4_v;
	wire [9:0] enemy_5_v;
	wire [9:0] enemy_6_v;
	wire [9:0] enemy_7_v;
	
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	wire [7:0] enemy_enable;
	wire [3:0] attack_valid;
	wire [9:0] attack_v;
	wire [15:0] score;
	
	wire [7:0] enemy_waring_enable;
	wire [7:0] enemy_laser_enable;

	clock_divisor clk_wiz_0_inst(
		.clk(clk),
		.clk1(clk_25MHz),
		.clk19(clk_19),
		.clk20(clk_20),
		.clk26(clk_26),
		.clk27(clk_27)
	);

	pixel_gen pixel_gen_inst(
		.clk(clk),
		.clk19(clk_19),
		.reset(rst),
		.state(state),
		.plane_h(plane_h),
		.laser_h(laser_h),
		.enemy_0_v(enemy_0_v),
		.enemy_1_v(enemy_1_v),
		.enemy_2_v(enemy_2_v),
		.enemy_3_v(enemy_3_v),
		.enemy_4_v(enemy_4_v),
		.enemy_5_v(enemy_5_v),
		.enemy_6_v(enemy_6_v),
		.enemy_7_v(enemy_7_v),
		.power_RGB(power_RGB),
		.power_left(power_left),
		.h_cnt(h_cnt),
		.v_cnt(v_cnt),
		.valid(valid),
		.enemy_waring_enable(enemy_waring_enable),
		.enemy_laser_enable(enemy_laser_enable),
		.enemy_laser_h(enemy_laser_h),
		.vgaRed(vgaRed),
		.vgaGreen(vgaGreen),
		.vgaBlue(vgaBlue)
	);

	vga_controller   vga_inst(
		.pclk(clk_25MHz),
		.reset(rst),
		.hsync(hsync),
		.vsync(vsync),
		.valid(valid),
		.h_cnt(h_cnt),
		.v_cnt(v_cnt)
	);
	
	state_controller state_inst(
		.clk(clk_19),
		.reset(rst),
		.start(start),
		.enemy_laser_h(enemy_laser_h),
		.plane_h(plane_h),
		.enemy_0_v(enemy_0_v),
		.enemy_1_v(enemy_1_v),
		.enemy_2_v(enemy_2_v),
		.enemy_3_v(enemy_3_v),
		.enemy_4_v(enemy_4_v),
		.enemy_5_v(enemy_5_v),
		.enemy_6_v(enemy_6_v),
		.enemy_7_v(enemy_7_v),
		.state(state)
	);
	
	plane_controller plane_inst(
		.clk(clk_19),
		.state(state),
		.key_down(key_down),
		.last_change(last_change),
		.been_ready(been_ready),
		.plane_h(plane_h),
		.laser_attack(laser_attack)
	);
	
	laser_controller laser_inst(
		.clk(clk_19),
		.state(state),
		.laser_attack(laser_attack),
		.plane_h(plane_h),
		.laser_enable(laser_enable),
		.laser_h(laser_h),
		.power_left(power_left),
		.power_RGB(power_RGB)
	);

	random_gen random_inst(
		.clk(clk_27),
		.reset(rst),
		.random_3(random_3)
	);
	
	enemy_controller enemy_inst(
		.clk(clk_20),
		.random_3(random_3),
		.laser_h(laser_h),
		.laser_enable(laser_enable),
		.state(state),
		.enemy_0_v(enemy_0_v),
		.enemy_1_v(enemy_1_v),
		.enemy_2_v(enemy_2_v),
		.enemy_3_v(enemy_3_v),
		.enemy_4_v(enemy_4_v),
		.enemy_5_v(enemy_5_v),
		.enemy_6_v(enemy_6_v),
		.enemy_7_v(enemy_7_v),
		.enemy_enable(enemy_enable),
		.attack_valid(attack_valid),
		.attack_v(attack_v)
	);
	
	enemy_laser_controller enemy_laser_inst(
		.clk(clk_26),
		.random_3(random_3),
		.state(state),
		.enemy_enable(enemy_enable),
		.enemy_waring_enable(enemy_waring_enable),
		.enemy_laser_enable(enemy_laser_enable)
	);
	
	score_controller score_inst(
		.clk(clk_20),
		.state(state),
		.enemy_enable(enemy_enable),
		.laser_enable(laser_enable),
		.attack_valid(attack_valid),
		.attack_v(attack_v),
		.score(score)
	);

	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	SevenSegment SevenSegment_inst(
		.clk(clk),
		.rst(rst),
		.nums(score),
		.display(display),
		.digit(digit)
	);
endmodule
