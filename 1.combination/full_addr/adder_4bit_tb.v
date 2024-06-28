`define CLKFREQ		100
`define SIMCYCLE	100

`include "adder_4bit.v"

module adder_4bit_tb;

// ========================================
// DUT Signals & Instantiation
// ========================================
	wire	[3:0]	o_s;
	wire			o_c;
	reg		[3:0]	i_a;
	reg		[3:0]	i_b;
	reg				i_c;

	adder_4bit
	u_adder_4bit
	(
		.o_s    (o_s),
		.o_c    (o_c),
		.i_a    (i_a),
		.i_b    (i_b),
		.i_c    (i_c)
	);

																																																			
	adder_4bit_dataflow
	u_adder_4bit_dataflow
	(
		.o_s    (o_s),
		.o_c    (o_c),
		.i_a    (i_a),
		.i_b    (i_b),
		.i_c    (i_c)
	);


// ========================================
// Test Stimulus
// ========================================
integer i;
initial begin

	for(i=0; i<`SIMCYCLE; i++) begin
		i_a	= $random;
		i_b	= $random;
		i_c	= $random;
		#(1000/`CLKFREQ);
    end	
	#(1000/`CLKFREQ);
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
		$dumpfile("adder_4bit_tb.vcd");
		$dumpvars;
	end
end
endmodule

