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
	wire _unused = &{ena, ui_in, uio_in, 1'b0};

	assign uio_out[6:0] = 7'b0;
	assign uio_oe  = 8'b10000000;

	circ demo(
		uio_out[7],
		uo_out[7],
		uo_out[3],
		{uo_out[0], uo_out[4]},
		{uo_out[1], uo_out[5]},
		{uo_out[2], uo_out[6]},
		clk,
		rst_n);

endmodule
