module clock_divisor(
	input clk,
	output clk1,
	output clk19,
	output clk20,
	output clk26,
	output clk27
);
	reg [26:0] num;
	wire [26:0] next_num;

	always @(posedge clk) begin
		num <= next_num;
	end

	assign next_num = num + 1'b1;
	assign clk1 = num[1];
	assign clk19 = num[18];
	assign clk20 = num[19];
	assign clk26 = num[25];
	assign clk27 = num[26];
endmodule

