`define CLKFREQ		100
`define SIMCYCLE	256
`define BIT			8

`define GENER_TO_GRAY
`define GENER_TO_BIN

`include "gray_code_converter.v"

module gray_code_converter_tb;
	
// ==================================================================
// DUT Signals & Instantiation
// ==================================================================
	wire	[`BIT-1:0]	o_gray;
	wire	[`BIT-1:0]	o_bin;
	reg		[`BIT-1:0]	i_bin;
	reg					i_clk;
	reg					i_rstn;

	bin_to_gray
	#(
		.BIT		(`BIT)
	)
	u_bin_to_gray(
		.o_gray		(o_gray),
		.i_bin		(i_bin)
	);

	gray_to_bin
	#(
		.BIT		(`BIT)
	)
	u_gray_to_bin(
		.o_bin		(o_bin),
		.i_gray		(o_gray)
	);

// ==================================================================
// Clock
// ==================================================================
	always	#(500/`CLKFREQ)		i_clk = ~i_clk;


// ==================================================================
// Task
// ==================================================================
	task init;
		begin
			i_bin	=	0;
			i_clk	=	0;
			i_rstn	=	0; 
			@(posedge i_clk);
		end
	endtask


// ==================================================================
// Test Stimulus
// ==================================================================
	integer	i;
	initial begin
		init();
		
		for (i=0; i<`SIMCYCLE; i++) begin
			i_bin	= i_bin + 8'b1;
			@(posedge i_clk);
		end

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
			$dumpfile("gray_code_converter.vcd");
			$dumpvars;
		end
	end

endmodule
