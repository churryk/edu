`define CLKFREQ		100
`define SIMCYCLE	10
`define BIT			32
`define VEC			10

`include "carry_lookahead_adder.v"

`define GENER
module carry_lookahead_adder_tb;

// ==================================================================
// DUT Signals & Instantiation
// ==================================================================
	wire	[`BIT-1:0]	o_data_s;
	wire				o_carry;
	reg		[`BIT-1:0]	i_data_a;
	reg		[`BIT-1:0]	i_data_b;
	reg					i_carry;
	reg					i_clk;

	carry_lookahead_adder
	#(
		.BIT		(`BIT)
	)
	u_carry_lookahead_adder
	(
		.o_data_s	(o_data_s	),
		.o_carry	(o_carry	),
		.i_data_a	(i_data_a	),
		.i_data_b	(i_data_b	),
		.i_carry	(i_carry	)
	);

	wire	[31:0]	o_data_s_comp;
	wire			o_carry_comp;

	compare_adder
	#(
		.BIT		(`BIT)
	)
	u_compare_adder
	(
		.o_data_s	(o_data_s_comp	),
		.o_carry	(o_carry_comp	),
		.i_data_a	(i_data_a     	),
		.i_data_b	(i_data_b     	),
		.i_carry	(i_carry     	)
	);

// ==================================================================
// TestVector
// ==================================================================
	reg		[`BIT:0]	vo_data_s	[0:`VEC-1];
	reg		  	 		vo_carry	[0:`VEC-1];
	reg		[`BIT:0]	vi_data_a	[0:`VEC-1];
	reg		[`BIT:0]	vi_data_b	[0:`VEC-1];
	reg					vi_carry	[0:`VEC-1];

	initial begin
		$readmemb("./vec_test/o_data.vec",		vo_data_s);
		$readmemb("./vec_test/o_carry.vec",		vo_carry);
		$readmemb("./vec_test/i_data_a.vec",	vi_data_a);
		$readmemb("./vec_test/i_data_b.vec",	vi_data_b);
		$readmemb("./vec_test/i_carry.vec",		vi_carry);
	end

// ==================================================================
// Clock
// ==================================================================
	always	#(500/`CLKFREQ)		i_clk = ~i_clk;

// ==================================================================
// Task
// ==================================================================
	reg [8*32-1:0] 	taskState;
	reg 			err;

	task init;
		begin			
			taskState	= "Init";
			i_data_a	=	0;
			i_data_b	=	0;
			i_carry		=	0;
			err			=	0;
			i_clk		=	0;
			@(posedge i_clk);
		end
	endtask

	task vecInsert;
		input	[$clog2(`VEC)-1:0]	i;
		begin
			$sformat(taskState,	"VEC[%3d]", i);
			i_data_a		= vi_data_a[i];
			i_data_b		= vi_data_b[i];
			i_carry			= vi_carry[i];
		end
	endtask

	task vecVerify;
		input	[$clog2(`VEC)-1:0]	i;
		begin
			#(0.1*1000/`CLKFREQ);
			if (o_data_s	!= vo_data_s[i]) begin $display("[Idx: %3d] Mismatched o_data_s", i); end
			if (o_carry		!= vo_carry[i]) begin $display("[Idx: %3d] Mismatched o_carry", i); end
			if ((o_data_s != vo_data_s[i]) || (o_carry != vo_carry[i])) begin err++; end
			#(0.9*1000/`CLKFREQ);
		end
	endtask

// ==================================================================
// Test Stimulus
// ==================================================================
	integer	i;
	initial begin
		init();
		
		for (i=0; i<`SIMCYCLE; i++) begin
			vecInsert(i);
			vecVerify(i);	
		end

		repeat(2) @(posedge i_clk);
		$finish;
	end

// ==================================================================
// Dump VCD
// ==================================================================
	reg [8*32-1:0] vcd_file;
	initial begin
		if($value$plusargs("vcd_file=%s", vcd_file)) begin
			$dumpfile(vcd_file);
			$dumpvars;
		end else begin
			$dumpfile("carry_lookahead_adder.vcd");
			$dumpvars;
		end
	end


endmodule
