module mux2_assign
(
	output	o_out,
	input	i_sel,
	input	i_in0,
	input	i_in1
);

assign o_out = i_sel ? i_in1 : i_in0;

endmodule
/////////////////////////////////////////////////////////////////////
module mux2_if
(
	output reg o_out,
	input      i_sel,
	input      i_in0,
	input      i_in1
);

 always @(*)begin
	 if(i_sel == 0) begin
		o_out = i_in0;
	end else begin
		o_out = i_in1;
	end
end

endmodule
/////////////////////////////////////////////////////////////////////
module mux2_case
(
	output reg	o_out,
	input       i_sel,
	input       i_in0,
	input       i_in1
);

always @(*) begin
	case(i_sel)
		0: 		o_out = i_in0;
		1: 		o_out = i_in1;
		//default : 1'b0;
	endcase
end
endmodule
/////////////////////////////////////////////////////////////////////
