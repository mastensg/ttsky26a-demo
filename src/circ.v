module circ(
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
	reg [19:0] rx;
	reg [19:0] ry;
	reg [15:0] x;
	reg signed [19:0] cx = 320;
	reg signed [19:0] cy = 240;
	reg [19:0] s2 = 128*128;

	wire signed [19:0] a = rx-cx;
	wire signed [19:0] b = ry-cy;
	wire signed [19:0] aa = a*a;
	wire signed [19:0] bb = b*b;
	wire signed [19:0] r2 = aa+bb;

	always @(posedge clk) begin
		if (~run) begin
			x <= 'b1010110011100001;
			rx <= 0;
			ry <= 0;
		end else begin
			if (rx[1:0] == 0)
				x <= {x[5] ^ x[3] ^ x[2] ^ x[0], x[15:1]};
			if ((640+16 <= rx) && (rx < 640+16+96))	H <= 0;
			else					H <= 1;
			if ((480+11 <= ry) && (ry < 480+11+2))	V <= 0;
			else					V <= 1;
			if (rx < 640+16+96+48-1) begin
				rx <= rx+1;
			end else begin
				A <= x[0];
				rx <= 0;
				if (ry < 480+11+2+31-1) begin
					ry <= ry+1;
				end else begin
					ry <= 0;
				end
			end
			if (r2 < s2) begin
				R <= x[3:2];
				G <= x[3:2];
				B <= x[3:2];
			end else begin
				R <= 0;
				G <= 0;
				B <= 0;
			end
		end
	end
endmodule
