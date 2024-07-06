`define CLKFREQ		100
`define SIMCYCLE	10

`include "shift_register.v"

module shift_register_tb;

	wire	[7:0]	o_parrel;
	wire			o_serial;
	reg				i_serial;
	reg		[7:0]	i_parrel;
	reg				load;
	reg				i_clk;
	reg				i_rstn;

	shift_register
	u_shift_register
	(
		.o_parrel		(o_parrel),
		.o_serial		(o_serial),
		.i_serial		(i_serial),
		.i_parrel		(i_parrel),
		.load			(load),
		.i_clk			(i_clk),
		.i_rstn			(i_rstn)
	);

	always	#(500/`CLKFREQ)		i_clk = ~i_clk;

	task init;
		begin
			i_serial	=	0;
			i_parrel	=	0;
			load		=	0;
			i_clk		=	0;
			i_rstn		=	0;
			@(posedge i_clk);
		end
	endtask

	integer i;
	task test_load;
		input	[7:0]	data;
		begin
			#1;
			load		= 1'b1;
			i_serial	= data[0];
			i_parrel	= data;
			@(posedge i_clk); #1;
			for (i=0; i<7; i++) begin
			load		= 1'b0;
			i_serial	= data[i+1];
			@(posedge i_clk); #1;
			end
			repeat(2) @(posedge i_clk); #1;
		end
	endtask

	integer j;
	task test_reset;
		begin
			for (j=0; j<8; j++) begin
			i_serial	<= 1'h0;
			@(posedge i_clk);
			end
		end
	endtask

	initial begin
		init();
		
		test_load(8'b0101_0101);	
		test_reset();
		test_load(8'b1100_0011);	
		test_reset();
		test_load(8'b0000_1111);	
		
		$finish;
	end

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
