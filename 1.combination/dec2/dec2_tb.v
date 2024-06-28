`define CLKFREQ		100
`define SIMCYCLE	20

`include "dec2.v"

module dec2_tb;

// ========================================
// DUT Signals & Instantiation
// ========================================
	wire	[3:0]	o_out_f;
	wire	[3:0]	o_out_b;
	reg		[1:0]	i_in;
	reg				i_en;

	dec2_dataflow
	u_dec2_dataflow
	(
		.o_out	(o_out_f),
		.i_in	(i_in),
		.i_en	(i_en)
	);

	dec2_behavior
	u_dec2_behavior
	(
		.o_out	(o_out_b),
		.i_in	(i_in),
		.i_en	(i_en)
	);

// ========================================
// Task
// ========================================
	task init;
		begin
			i_in	= 0;
			i_en	= 0;
		end
	endtask


// ========================================
// Test Stimulus
// ========================================
integer i;
initial begin
	init();

	for(i=0; i<`SIMCYCLE; i++) begin
	{i_in, i_en}	= $urandom_range(0, 2**3-1);
	#(1000 /`CLKFREQ);
    end	
   $finish;
end

// ========================================
// Dump VCD
// ========================================
reg [8*32-1:0] vcd_file;
initial begin
	if($value$plusargs("vcd_file=%s", vcd_file)) begin
		$dumpfile(vcd_file);
		$dumpvars;
	end else begin
		$dumpfile("dec2_tb.vcd");
		$dumpvars;
	end
end
endmodule
