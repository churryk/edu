module latch
(
input		clk,
input		i_data,
output reg	o_data
);


always @(*) begin
	if(clk)
	o_data <= i_data;
end

endmodule


module dff
(
input		clk,
input		i_data,
output reg	o_data
);


always @(posedge clk) begin
	o_data <= i_data;
end

endmodule
