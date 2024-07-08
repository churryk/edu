`define CLKFREQ		100
`define SIMCYCLE	7
`define BIT			8

`include "barrel_shift.v"

module barrel_shift_tb;

// ==================================================================
// DUT Signals & Instantiation
// ==================================================================
	wire	[`BIT-1:0]			o_data;
	wire	[`BIT-1:0]			o_data_compare;
	wire	[`BIT-1:0]			o_data_mux_right;
	reg		[`BIT-1:0]			i_data;
	reg							sel_left;
	reg		[$clog2(`BIT)-1:0]	i_shifter;
	reg							i_clk;

	barrel_shift
	#(
		.BIT		(`BIT)
	)
	u_barrel_shift
	(
		.o_data		(o_data		),
		.i_data		(i_data		),
		.sel_left	(sel_left	),
		.i_shifter	(i_shifter	)
	);

	barrel_shift_compare
	#(
		.BIT		(`BIT)
	)
	u_barrel_shift_compare
	(
		.o_data		(o_data_compare	),
		.i_data		(i_data			),
		.sel_left	(sel_left		),
		.i_shifter	(i_shifter		)
	);

	barrel_shift_mux
	#(
		.BIT		(`BIT)
	)
	u_barrel_shift_mux
	(
		.o_data		(o_data_mux 	),
		.i_data		(i_data			),
		.i_shifter	(i_shifter		)
	);
	assign o_data_mux = sel_left ? 'h0 : o_data_mux;
// ==================================================================
// Clock
// ==================================================================
	always	#(500/`CLKFREQ)		i_clk = ~i_clk;
										
// ==================================================================
// Task
// ==================================================================
	task init;
		begin
			i_data		= 0;
			sel_left	= 0;
			i_shifter	= 0; 
			i_clk		= 0;
			@(posedge i_clk);
		end
	endtask

	integer	i;
	task test;
		input	[$clog2(`BIT)-1:0]	i_sel_left;
		input	[`BIT-1:0]			i_task_data;
		begin
			i_data		= i_task_data;
			i_shifter	= 3'h0;
			@(posedge i_clk);
			for (i=0; i<`SIMCYCLE; i++) begin
				sel_left	= i_sel_left;
				i_shifter	= i_shifter + 1'b1;
				@(posedge i_clk);
			end
		end
	endtask

// ==================================================================
// Test Stimulus
// ==================================================================
	initial begin
		init();

		test(1'b0, 8'b0110_0110);	// ([1bit] : sel_left, [8bit] : i_data)
		test(1'b1, 8'b0110_0110);	// ([1bit] : sel_left, [8bit] : i_data)
		test(1'b0, 8'b0111_0110);	// ([1bit] : sel_left, [8bit] : i_data)
		test(1'b1, 8'b0110_1110);	// ([1bit] : sel_left, [8bit] : i_data)

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
			$dumpfile("barrel_shift.vcd");
			$dumpvars;
		end
	end
	endmodule
