/*
 * Copyright (c) 2026 Martin Stensgård
 * SPDX-License-Identifier: ISC
 */

`default_nettype none

module tt_um_mastensg_ttsky26a_demo (
	input  wire [7:0] ui_in,    // Dedicated inputs
	output wire [7:0] uo_out,   // Dedicated outputs
	input  wire [7:0] uio_in,   // IOs: Input path
	output wire [7:0] uio_out,  // IOs: Output path
	output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
	input  wire       ena,      // always 1 when the design is powered, so you can ignore it
	input  wire       clk,      // clock
	input  wire       rst_n     // reset_n - low to reset
);
	reg A, H, V;
	reg [1:0] R;
	reg [1:0] G;
	reg [1:0] B;
	reg [9:0] rx;
	reg [9:0] ry;

	wire _unused = &{ena, clk, rst_n, ui_in, uio_in, 1'b0};

	assign uo_out  = {H, B[0], G[0], R[0], V, B[1], G[1], R[1]};
	assign uio_out = {A, 7'b0};
	assign uio_oe  = {1, 7'b0};

	reg [1:16] x;

	always @(posedge clk) begin
		if (~rst_n) begin
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
