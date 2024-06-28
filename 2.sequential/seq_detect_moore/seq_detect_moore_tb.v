`define CLKFREQ		100
`define SIMCYCLE	50

`include "seq_detect_moore.v"

module seq_detect_moore_tb;

// ========================================
// DUT Signals & Instantiation
// ========================================
	wire	o_out;
	reg		i_seq;
	reg		i_clk;
	reg		i_rstn;

	seq_detect_moore
	u_seq_detect_moore
	(
		.o_out	(o_out),
		.i_seq	(i_seq),
		.i_clk	(i_clk),
		.i_rstn	(i_rstn)
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
		i_seq  = 1'b0;
		i_clk  = 1'b0;
		i_rstn = 1'b0;
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
	i_seq = $urandom;
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
		$dumpfile("seq_detect_moore_tb.vcd");
		$dumpvars;
	end
end

endmodule

