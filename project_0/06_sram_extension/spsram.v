module spsram
#(
	parameter	MIF_FILE	= "mif_file.mif",
	parameter	BW_DATA		= 32,
	parameter	BW_ADDR		= 4
)
(
	output		[BW_DATA-1:0]	o_data,
	input		[BW_DATA-1:0]	i_data,
	input		[BW_ADDR-1:0]	i_addr,
	input		            	i_wen,
	input		            	i_cen,
	input		            	i_oen,
	input		            	i_clk
);

// mem wr
	reg			[BW_DATA-1:0]	mem[0:2**BW_ADDR-1];
	`ifdef	MEM_INIT
		initial begin
			$readmemb(MIF_FILE, mem);
		end
	`endif

	always @(posedge i_clk) begin
		if(i_cen && i_wen) begin
			mem[i_addr] <= i_data;
		end else begin
			mem[i_addr] <= mem[i_addr];
		end
	end

// mem rd
	`ifdef	SPSRAM_ASYNC
		assign o_data 	=	!i_oen			  ?	'bz			:
							(i_cen && !i_wen) ?	mem[i_addr]	: 'bx;

	`else
		reg		[BW_DATA-1:0]	o_data;
		always @(posedge i_clk) begin
			if(i_oen) begin
				if(i_cen && !i_wen) begin
					o_data	<=	mem[i_addr];
				end else begin
					o_data	<=	'bx;
				end
			end else begin
				o_data	<=	'bz;
			end
		end
	`endif

endmodule


module spsram_final
#(
	parameter	BW_DATA		= 64,
	parameter	BW_ADDR		= 6
)
(
	output		[BW_DATA-1:0]	o_data,
	input		[BW_DATA-1:0]	i_data,
	input		[BW_ADDR-1:0]	i_addr,
	input		            	i_wen,
	input		            	i_clk
);

spsram u_spsram0_0( o_data[31:0],  i_data[31:0],   i_addr[3:0], i_wen, !i_addr[5] & !i_addr[4], !i_addr[5] & !i_addr[4], i_clk);
spsram u_spsram0_1( o_data[63:32], i_data[63:32],  i_addr[3:0], i_wen, !i_addr[5] & !i_addr[4], !i_addr[5] & !i_addr[4], i_clk);
spsram u_spsram1_0( o_data[31:0],  i_data[31:0],   i_addr[3:0], i_wen, !i_addr[5] &  i_addr[4], !i_addr[5] &  i_addr[4], i_clk);
spsram u_spsram1_1( o_data[63:32], i_data[63:32],  i_addr[3:0], i_wen, !i_addr[5] &  i_addr[4], !i_addr[5] &  i_addr[4], i_clk);
spsram u_spsram2_0( o_data[31:0],  i_data[31:0],   i_addr[3:0], i_wen,  i_addr[5] & !i_addr[4],  i_addr[5] & !i_addr[4], i_clk);
spsram u_spsram2_1( o_data[63:32], i_data[63:32],  i_addr[3:0], i_wen,  i_addr[5] & !i_addr[4],  i_addr[5] & !i_addr[4], i_clk);
spsram u_spsram3_0( o_data[31:0],  i_data[31:0],   i_addr[3:0], i_wen,  i_addr[5] &  i_addr[4],  i_addr[5] &  i_addr[4], i_clk);
spsram u_spsram3_1( o_data[63:32], i_data[63:32],  i_addr[3:0], i_wen,  i_addr[5] &  i_addr[4],  i_addr[5] &  i_addr[4], i_clk);


endmodule
