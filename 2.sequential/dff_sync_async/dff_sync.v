module dff_sync
(
	input		i_rstn,
	input		clk,
	input		i_data,
	output reg	o_data
);


always @(posedge clk) begin
	if(!i_rstn) begin
		o_data <= 1'b0;
	end else begin
		o_data <= i_data;
	end
end

endmodule


module dff_async
(
	input		i_rstn,
	input		clk,
	input		i_data,
	output reg	o_data
);


always @(posedge clk or negedge i_rstn) begin
	if(!i_rstn) begin
		o_data <= 1'b0;
	end else begin
		o_data <= i_data;
	end
end

endmodule
