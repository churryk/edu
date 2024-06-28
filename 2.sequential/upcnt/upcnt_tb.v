`define CLKFREQ		100
`define SIMCYCLE	50
`define UPBND		15

`include "upcnt.v"

module upcnt_tb;

// ========================================
// DUT Signals & Instantiation
// ========================================
	reg							i_rstn;
	reg							i_clk;
	wire [$clog2(`UPBND+1)-1:0]	o_cnt;

upcnt
#(
	.UPBND	(`UPBND)
)
u_upcnt
(
	.i_clk	(i_clk),
	.i_rstn	(i_rstn),
	.o_cnt	(o_cnt)
);

// ========================================
// Clock
// ========================================
always #(500/`CLKFREQ) i_clk = ~i_clk;
	
	reg 	[4*32-1:0] 	taskstate;
	integer				err = 0;

// ========================================
// Task
// ========================================
task init;
	begin
		taskstate		= "init";
		i_clk			= 0;
		i_rstn			= 0;
	end
endtask

task resetNCycle;
	input		[9:0]	i;
	begin
		taskstate	=	"Reset";
		i_rstn	=	1'b0;
		#(i*1000/`CLKFREQ);
		i_rstn	= 	1'b1;
		taskstate	=	"";
	end
endtask

// ========================================
// Test Stimulus
// ========================================
integer	i, j;
initial begin
	init();
	resetNCycle(4);
	
	for (i=0; i<`SIMCYCLE; i++) begin
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
		$dumpfile("upcnt_tb.vcd");
		$dumpvars;
	end
end
endmodule

