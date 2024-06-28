module dff_neg
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


module dff_pos
(
	input		i_rstn,
	input		clk,
	input		i_data,
	output reg	o_data
);


always @(posedge clk or posedge i_rstn) begin
	if(!i_rstn) begin
		o_data <= 1'b0;
	end else begin
		o_data <= i_data;
	end
end

endmodule
