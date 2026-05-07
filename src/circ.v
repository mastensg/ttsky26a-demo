module circ(
	output	reg	A,
	output	reg	H,
	output	reg	V,
	output	reg [1:0] R,
	output	reg [1:0] G,
	output	reg [1:0] B,
	input	wire	clk,
	input	wire	run
);
	reg [19:0] rx;
	reg [19:0] ry;
	reg [1:16] x;
	reg signed [19:0] cx = 8;
	reg signed [19:0] cy = 8;
	reg [19:0] s2 = 6*6;

	wire [19:0] col = (rx-120) / 16;
	wire [19:0] row = (ry-40) / 16;
	wire inv = col[0] == row[0];

	wire [19:0] mx = (rx+8) % 16;
	wire [19:0] my = (ry+8) % 16;
	wire signed [19:0] a = mx-cx;
	wire signed [19:0] b = my-cy;
	wire signed [19:0] aa = a*a;
	wire signed [19:0] bb = b*b;
	wire signed [19:0] r2 = aa+bb;

	always @(posedge clk) begin
		if (~run) begin
			x <= 'b1010110011100001;
			rx <= 0;
			ry <= 0;
		end else begin
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
				end
			end
			if (120 <= rx && rx < 520 && 40 <= ry && ry < 440) begin
				if ((r2 < s2) ^ inv) begin
					R <= {1, x[2]};
					G <= {1, x[1]};
					B <= 2'b01;
				end else begin
					R <= 2'b01;
					G <= 2'b01;
					B <= {1, x[3]};
				end
			end else if (rx < 640 && ry < 480) begin
				R <= 2'b11;
				G <= 2'b11;
				B <= 2'b11;
			end else begin
				R <= 2'b00;
				G <= 2'b00;
				B <= 2'b00;
			end
		end
	end
endmodule
