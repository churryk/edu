module regfile
#(
	parameter	MIF_FILE	= "regfile.mif",
	parameter	BW_DATA		= 32,
	parameter	BW_ADDR		= 5
)
(
	output		[BW_DATA-1:0]	o_rf_rd_data0,
	output		[BW_DATA-1:0]	o_rf_rd_data1,
	input		[BW_ADDR-1:0]	i_rf_rd_addr0,
	input		[BW_ADDR-1:0]	i_rf_rd_addr1,
	input		[BW_DATA-1:0]	i_rf_wr_data,
	input		[BW_ADDR-1:0]	i_rf_wr_addr,
	input		            	i_rf_wr_en,
	input		            	i_clk
);

	reg			[BW_DATA-1:0]	rf_arr[0:2**BW_ADDR-1];
	`ifdef	MEM_INIT
		initial begin
			$readmemb(MIF_FILE, rf_arr);
		end
	`endif
	
// Async. Read
	assign		o_rf_rd_data0	= rf_arr[i_rf_rd_addr0];
	assign		o_rf_rd_data1	= rf_arr[i_rf_rd_addr1];

	always @(posedge i_clk) begin
		if(i_rf_wr_en) begin
			rf_arr[i_rf_wr_addr] <= i_rf_wr_data;
		end else begin
			rf_arr[i_rf_wr_addr] <= rf_arr[i_rf_wr_addr];
		end
	end
endmodule

