`define CLKFREQ		100
`define SIMCYCLE	50

`include "latch_vs_dff.v"

module latch_vs_dff_tb;

// ========================================
// DUT Signals & Instantiation
// ========================================
	wire	o_q_lat;
	wire	o_q_dff;
	reg		i_data;
	reg		i_clk;

latch
u_latch
(
	.clk	(i_clk),
	.i_data	(i_data),
	.o_data	(o_q_lat)
);

dff
u_dff
(
	.clk	(i_clk),
	.i_data	(i_data),
	.o_data	(o_q_dff)
);

// ========================================
// Clock
// ========================================
always #(500/`CLKFREQ) i_clk = ~i_clk;


// ========================================
// Task
// ========================================
task init;
	begin
		i_clk	= 1'b0;
		i_data	= 1'b0;
	end
endtask

// ========================================
// Test Stimulus
// ========================================
integer i, j;
initial begin
	init();

	for(i=0; i<`SIMCYCLE; i++) begin
	j	= $urandom_range(0,10);
	#(( (j*0.1)) * 1000 /`CLKFREQ);
	i_data = $urandom;
	#((1-(j*0.1)) * 1000 /`CLKFREQ);
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
		$dumpfile("latch_vs_dff_tb.vcd");
		$dumpvars;
	end
end

endmodule
