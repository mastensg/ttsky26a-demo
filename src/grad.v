/* verilator lint_off ASCRANGE */
module grad(
	output	reg	A,
	output	reg	H,
	output	reg	V,
	output	reg [1:0] R,
	output	reg [1:0] G,
	output	reg [1:0] B,
	input	wire	clk,
	input	wire	run,
	input	wire [7:0] in
);
	reg [1:16] x;
	reg [19:0] t;

	reg [19:0] rx;
	reg [19:0] ry;
	wire [7:0] whiteness = rx[7:0] - 16 + {4'b0, x[1:4]};

	always @(posedge clk) begin
		if (~run) begin
			x <= 'b1010110011100001;
			rx <= 0;
			ry <= 0;
		end else begin
			if (in[0])
				x <= {x[11] ^ x[13] ^ x[14] ^ x[16], x[1:15]};
			if ((640+16 <= rx) && (rx < 640+16+96))	H <= 0;
			else					H <= 1;
			if ((480+11 <= ry) && (ry < 480+11+2))	V <= 0;
			else					V <= 1;
			if (rx < 640+16+96+48-1) begin
				rx <= rx+1;
			end else begin
				A <= x[1];
				rx <= 0;
				if (ry < 480+11+2+31-1) begin
					ry <= ry+1;
				end else begin
					ry <= 0;
					t <= t+1;
				end
			end
			if (rx < 640 && ry < 240) begin
				R <= rx[7:6];
				G <= rx[7:6];
				B <= rx[7:6];
			end else if (rx < 640 && ry < 480) begin
				R <= whiteness[7:6];
				G <= whiteness[7:6];
				B <= whiteness[7:6];
			end else begin
				R <= 2'b00;
				G <= 2'b00;
				B <= 2'b00;
			end
		end
	end
endmodule
