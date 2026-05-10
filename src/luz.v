/* verilator lint_off ASCRANGE */
module luz(
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
	reg signed [19:0] cx = 8;
	reg signed [19:0] cy = 8;
	reg [19:0] s2 = 6*6;

	wire signed	[19:0] col = (rx-120) / 16 - 12;
	wire signed	[19:0] row = (ry- 40) / 16 - 12;
	wire		       inv = col[0] == row[0];
	reg		[19:0] abscol;
	reg		[19:0] absrow;
	wire		[19:0] man = abscol + absrow;
	wire		[ 7:0] fr  = (7'd21 + man[6:0] - t[10:4] + {6'b0, x[1:2]});
	wire		[ 7:0] fg  = (7'd25 + man[6:0] - t[ 9:3] + {6'b0, x[1:2]});
	wire		[ 7:0] fb  = (7'd22 + man[6:0] - t[10:4] + {6'b0, x[1:2]});
	wire		[ 7:0] gr  = (7'd11 + man[6:0] - t[11:5] + {6'b0, x[1:2]});
	wire		[ 7:0] gg  = (7'd15 + man[6:0] - t[10:4] + {6'b0, x[1:2]});
	wire		[ 7:0] gb  = (7'd12 + man[6:0] - t[11:5] + {6'b0, x[1:2]});
	wire		[ 7:0] hr  = (7'd31 + man[6:0] - t[10:4] + {6'b0, x[1:2]});
	wire		[ 7:0] hg  = (7'd35 + man[6:0] - t[11:5] + {6'b0, x[1:2]});
	wire		[ 7:0] hb  = (7'd32 + man[6:0] - t[10:4] + {6'b0, x[1:2]});

	wire [19:0] mx = (rx-8) % 16;
	wire [19:0] my = (ry-8) % 16;
	wire signed [19:0] a = mx-cx;
	wire signed [19:0] b = my-cy;
	wire signed [19:0] aa = a*a;
	wire signed [19:0] bb = b*b;
	wire signed [19:0] r2 = aa+bb;
	wire inni = 3<=mx&&mx<13 && 3<=my&&my<13;

	always @(posedge clk) begin
		if (~run) begin
			t <= 0;
			x <= 'b1010110011100001;
			rx <= 0;
			ry <= 0;
			abscol <= 0;
			absrow <= 0;
		end else begin
			abscol <= col<0 ? -col : col;
			absrow <= row<0 ? -row : row;
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
			if (-12<=col && col<=+12 && -12<=row && row<=+12) begin
				if (0&&~inv) begin
					R <= 2'b00;
					G <= 2'b00;
					B <= 2'b00;
				end else if (inni) begin
					if (inv) begin
						R <= gr[4:3];
						G <= gg[4:3];
						B <= gb[4:3];
					end else begin
						R <= hr[4:3];
						G <= hg[4:3];
						B <= hb[4:3];
					end
				end else begin
					if (inv) begin
						R <= fr[4:3];
						G <= fg[4:3];
						B <= fb[4:3];
					end else begin
						R <= gr[4:3];
						G <= gg[4:3];
						B <= gb[4:3];
					end
				end
			end else if (rx < 640 && ry < 480) begin
				R <= 2'b10;
				G <= 2'b10;
				B <= 2'b10;
			end else begin
				R <= 2'b00;
				G <= 2'b00;
				B <= 2'b00;
			end
		end
	end
endmodule
