module fa
(
	output		o_s,
	output		o_c,
	input		i_a,
	input		i_b,
	input		i_c
);

	assign {o_c, o_s}	= i_a + i_b + i_c;

endmodule
