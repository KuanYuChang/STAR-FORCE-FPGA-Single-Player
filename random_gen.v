module random_gen(
	input clk,
	input reset,
	output [2:0] random_3
);
	
	reg [3:0] DFF;
	wire feedback;
	
	always @(posedge clk or posedge reset) begin
		if(reset) DFF <= 4'b0001;
		else DFF <= {feedback, DFF[3:1]};
	end
	
	xor (feedback, DFF[1], DFF[0]);
	
	assign random_3 = DFF[3:1];
endmodule
