`define CLKFREQ		100
`define SIMCYCLE	50

`include "traffic_light_controller.v"

module traffic_light_controller_tb;

// ==================================================================
// DUT Signals & Instantiation
// ==================================================================
	wire				mode;
	wire [8*6-1:0]		o_la;
	wire [8*6-1:0]		o_lb;
	reg					i_ta;
	reg					i_tb;
	reg					i_stop;
	reg					i_perad;
	reg					i_clk;
	reg					i_rstn;

	mode_fsm
	u_mode_fsm
	(
		.mode		(mode	),
		.i_stop		(i_stop	),
		.i_perad	(i_perad),
		.i_clk		(i_clk	),
		.i_rstn		(i_rstn	)
	);	

	light_fsm
	u_light_fsm
	(
		.o_la		(o_la	),
		.o_lb		(o_lb	),
		.mode		(mode	),
		.i_ta		(i_ta	),
		.i_tb		(i_tb	),
		.i_clk		(i_clk	),
		.i_rstn		(i_rstn	)
	);	

// ==================================================================
// Clock
// ==================================================================
	always	#(1000/`CLKFREQ)		i_clk = ~i_clk;

// ==================================================================
// Task
// ==================================================================
	task init;
		begin
		i_ta		= 0;
		i_tb		= 0;
		i_stop		= 0;
		i_perad		= 0;
		i_clk		= 0;
		i_rstn		= 0;
		@(posedge i_clk);
		end
	endtask

// ==================================================================
// Test Stimulus
// ==================================================================
	integer i;
	initial begin
		init();
		
		for(i=0; i<`SIMCYCLE; i++) begin
		#1;
		i_ta		=  $random;
		i_tb		=  $random;
		i_stop		=  $random;
		i_perad		=  $random;
		repeat(1) @(posedge i_clk);
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
			$dumpfile("traffic_light_controller.vcd");
			$dumpvars;
		end
	end

endmodule
