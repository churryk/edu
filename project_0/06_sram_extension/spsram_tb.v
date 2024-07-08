`define CLKFREQ		100
`define BW_ADDR		4

`define SPSRAM_ASYNC
`define MEM_INIT

`include "spsram.v"

module spsram_tb;

// ==================================================================
// DUT Signals & Instantiation
// ==================================================================
	wire	[63:0]		o_data;
	reg		[63:0]		i_data;
	reg		[5:0]		i_addr;
	reg					i_wen;
	reg					i_clk;
	
spsram_final u_spsram_final( o_data,  i_data, i_addr, i_wen, i_clk);

// ==================================================================
// Clock
// ==================================================================

	always	#(500/`CLKFREQ)		i_clk = ~i_clk;

// ==================================================================
// Task
// ==================================================================
	reg		[4*32-1:0]	taskState;

	task init;
		begin
			i_data		= 0;
			i_addr		= 0;
			i_wen		= 0; 
			i_clk		= 0;
			taskState	= 0;
		end
	endtask
	
	task memWR;
		input	[5:0]	ti_addr;
		begin
			@(posedge i_clk) begin
				taskState	= "WR";
				i_data		= i_data + 64'h1111_1111_1111_1111;
				i_addr		= ti_addr;
				i_wen		= 1;
			end
		end
	endtask

	task memRD;
		input	[5:0]	ti_addr;
		begin
			@(posedge i_clk) begin
				taskState		= "RD";
				i_addr			= ti_addr;
				i_wen			= 0;
			end
		end
	endtask

// ==================================================================
// Test Stimulus
// ==================================================================
	integer	i;
	initial begin
		init();
		#(4*1000/`CLKFREQ);
		
		for (i=0; i<64; i++) begin
			memWR(i);
		end

		repeat(5) @(posedge i_clk);
		for (i=0; i<64; i++) begin
			memRD(i);
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
			for (i=0; i<2**`BW_ADDR; i++) begin
				$dumpvars(0, u_spsram_final.u_spsram0_0.mem[i]);
				$dumpvars(0, u_spsram_final.u_spsram0_1.mem[i]);
				$dumpvars(0, u_spsram_final.u_spsram1_0.mem[i]);
				$dumpvars(0, u_spsram_final.u_spsram1_1.mem[i]);
				$dumpvars(0, u_spsram_final.u_spsram2_0.mem[i]);
				$dumpvars(0, u_spsram_final.u_spsram2_1.mem[i]);
				$dumpvars(0, u_spsram_final.u_spsram3_0.mem[i]);
				$dumpvars(0, u_spsram_final.u_spsram3_1.mem[i]);
			end
		end else begin
			$dumpfile("spsram.vcd");
			$dumpvars;
		end
	end
endmodule

