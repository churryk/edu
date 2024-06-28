`include "fa.v"

module adder_4bit
(
	output	[3:0]	o_s,
	output			o_c,
	input	[3:0]	i_a,
	input	[3:0]	i_b,
	input			i_c
);

	wire	[2:0]	carry;


	fa
	u_fa0(
		.o_s	(o_s[0]		),
		.o_c	(carry[0]	),
		.i_a	(i_a[0]		),
		.i_b	(i_b[0]		),
		.i_c	(i_c		)
	);

	fa
	u_fa1(
		.o_s	(o_s[1]		),
		.o_c	(carry[1]	),
		.i_a	(i_a[1]		),
		.i_b	(i_b[1]		),
		.i_c	(carry[0]	)
	);
																																																					
	fa
	u_fa2(
		.o_s	(o_s[2]		),
		.o_c	(carry[2]	),
		.i_a	(i_a[2]		),
		.i_b	(i_b[2]		),
		.i_c	(carry[1]	)
	);

	fa
	u_fa3(
		.o_s	(o_s[3]		),
		.o_c	(o_c		),
		.i_a	(i_a[3]		),
		.i_b	(i_b[3]		),
		.i_c	(carry[2]	)
	);

endmodule		


module adder_4bit_dataflow
(
	output	[3:0]	o_s,
	output			o_c,
	input	[3:0]	i_a,
	input	[3:0]	i_b,
	input			i_c
);

	assign	{o_c, o_s}	= i_a + i_b + i_c;
	
endmodule
