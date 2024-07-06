module bin_to_gray
#(
	parameter 	BIT	= 8
)
(
	output 	[BIT-1:0]	o_gray,
	input	[BIT-1:0]	i_bin
);

	`ifdef GENER_TO_GRAY
		genvar	g;
		generate
			for (g=0; g<BIT-1; g=g+1) begin
					assign	o_gray[g]	= i_bin[g+1] ^ i_bin[g]; 
			end
		endgenerate
		assign	o_gray[BIT-1]	= i_bin[BIT-1]; 			// MSB

	`else
		assign	o_gray[0]		= i_bin[1] ^ i_bin[0];
		assign	o_gray[1]		= i_bin[2] ^ i_bin[1];
		assign	o_gray[2]		= i_bin[3] ^ i_bin[2];
		assign	o_gray[3]		= i_bin[4] ^ i_bin[3];
		assign	o_gray[4]		= i_bin[5] ^ i_bin[4];
		assign	o_gray[5]		= i_bin[6] ^ i_bin[5];
		assign	o_gray[6]		= i_bin[7] ^ i_bin[6];
		assign	o_gray[7]		= i_bin[7]; 					// MSB
	`endif

endmodule

module gray_to_bin
#(
	parameter 	BIT	= 8
)
(
	output	[BIT-1:0]	o_bin,
	input	[BIT-1:0]	i_gray
);

	`ifdef GENER_TO_BIN
		genvar	g;
		generate
			for (g=0; g<BIT-1; g=g+1) begin
					assign	o_bin[g]	= o_bin[g+1] ^ i_gray[g]; 
			end
		endgenerate
		assign	o_bin[BIT-1]	= i_gray[BIT-1]; 			// MSB

	`else
		assign	o_bin[0]		= o_bin[1] ^ i_gray[0];
		assign	o_bin[1]		= o_bin[2] ^ i_gray[1];
		assign	o_bin[2]		= o_bin[3] ^ i_gray[2];
		assign	o_bin[3]		= o_bin[4] ^ i_gray[3];
		assign	o_bin[4]		= o_bin[5] ^ i_gray[4];
		assign	o_bin[5]		= o_bin[6] ^ i_gray[5];
		assign	o_bin[6]		= o_bin[7] ^ i_gray[6];
		assign	o_bin[7]		= i_gray[7]; 					// MSB
	`endif

endmodule
