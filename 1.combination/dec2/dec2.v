module dec2_behavior
(
	output reg	[3:0]	o_out,
	input		[1:0]	i_in,
	input				i_en
);
																																				
always @(*) begin
	if (i_en == 1'b1) begin
		case(i_in)
			2'b00:	o_out	= 4'b0001;
			2'b01:	o_out	= 4'b0010;
			2'b10:	o_out	= 4'b0100;
			2'b11:	o_out	= 4'b1000;
		endcase
	end else begin
		o_out	= 4'b0;
	end
end

endmodule

module dec2_dataflow
(
	output 		[3:0]	o_out,
	input		[1:0]	i_in,
	input				i_en
);
																																				
	assign o_out	= (i_en == 1'b1) ? (4'd1 << i_in) : 4'd0;

endmodule
