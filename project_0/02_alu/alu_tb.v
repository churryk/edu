`define CLKFREQ		100

`include "alu.v"

module alu_tb;

	wire	[31:0]		o_data_y;
	wire				o_data_c;
	reg		[31:0]		i_data_a;
	reg		[31:0]		i_data_b;
	reg		[2:0]		i_func;
	reg					i_clk;

	alu
	u_alu
	(
		.o_data_y	(o_data_y	),
		.o_data_c	(o_data_c	),
		.i_data_a	(i_data_a	),
		.i_data_b	(i_data_b	),
		.i_func		(i_func		)
	);	


	always	#(1000/`CLKFREQ)		i_clk = ~i_clk;

	task init;
		begin
		i_data_a	= 0;
		i_data_b	= 0;
		i_func		= 0;
		i_clk		= 0;
		end
	endtask

	integer i;
	task test;
		input	[31:0] data_a;
		input	[31:0] data_b;
		begin
			for(i=0; i<8; i++) begin
			#1;
			i_data_a	=  data_a;
			i_data_b	=  data_b;
			i_func		=  i_func + 1'b1;
			repeat(1) @(posedge i_clk);
			end
		end
	endtask

	initial begin
		init();
		repeat(2) @(posedge i_clk);
		
		test(32'h5555_5555, 32'h1111_1111);
		test(32'hffff_ffff, 32'hffff_ffff);
		test(32'h1111_1111, 32'haaaa_aaaa);
		test($random, $random);


		repeat(2) @(posedge i_clk);
		$finish;
		
	end

	reg [8*32-1:0] vcd_file;
	initial begin
		if($value$plusargs("vcd_file=%s", vcd_file)) begin
			$dumpfile(vcd_file);
			$dumpvars;
		end else begin
			$dumpfile("alu.vcd");
			$dumpvars;
		end
	end

endmodule
