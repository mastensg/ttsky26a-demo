module snow(
	output	reg	A,
	output	reg	H,
	output	reg	V,
	output	reg [1:0] R,
	output	reg [1:0] G,
	output	reg [1:0] B,
	input	wire	clk,
	input	wire	run
);
	reg [9:0] rx;
	reg [9:0] ry;
	reg [1:16] x;

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
			if (rx<640 && ry<480) begin
				R <= x[1:3];
				G <= x[3:5];
				B <= x[5:7];
			end else begin
				R <= 0;
				G <= 0;
				B <= 0;
			end
		end
	end
endmodule
