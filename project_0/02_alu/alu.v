module alu
(
	output reg	[31:0]	o_data_y,
	output 				o_data_c,
	input		[31:0]	i_data_a,
	input		[31:0]	i_data_b,
	input		[2:0]	i_func
);
	wire 	 	[31:0]	data_b_n;
	wire 	 	[31:0]	data_sum;
	

	assign	data_b_n	= (i_func[2] == 1)	 ? ~i_data_b : i_data_b;

	assign	{o_data_c, data_sum}	= i_data_a + data_b_n;

	always @(*) begin
		case (i_func)
			3'b000	: o_data_y	= i_data_a & data_b_n;
			3'b001	: o_data_y	= i_data_a | data_b_n;
			3'b010	: o_data_y	= data_sum;
			3'b100	: o_data_y	= i_data_a & data_b_n;
			3'b101	: o_data_y	= i_data_a | data_b_n;
			3'b110	: o_data_y	= data_sum;
			3'b111	: o_data_y	= i_data_a < i_data_b;
			default	: o_data_y	= 'd0;
		endcase
	end

endmodule
	

