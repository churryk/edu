`define CLKFREQ		100
`define SIMCYCLE	10

`include "dff_sync.v"

module dff_sync_tb;

// ========================================
// DUT Signals & Instantiation
// ========================================
	reg		clk;
	reg		i_data;
	reg		i_rstn;
	wire	o_data_1;
	wire	o_data_2;

dff_sync
u_dff_sync
(
	.clk	(clk),
	.i_rstn	(i_rstn),
	.i_data	(i_data),
	.o_data	(o_data_1)
);

dff_async
u_dff_async
(
	.clk	(clk),
	.i_rstn	(i_rstn),
	.i_data	(i_data),
	.o_data	(o_data_2)
);

// ========================================
// Clock
// ========================================
always #(500/`CLKFREQ) clk = ~clk;

// ========================================
// Task
// ========================================
task init;
	begin
		clk		= 1'b0;
		i_data	= 1'b0;
		i_rstn  = 1'b0;
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
	i_rstn = $urandom;
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
		$dumpfile("dff_sync_tb.vcd");
		$dumpvars;
	end
end

endmodule
