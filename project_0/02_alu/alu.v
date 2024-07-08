module alu
#(
	parameter	BIT		= 32
)
(
	output reg	[31:0]	o_data_y,
	output 				o_data_c,
	input		[31:0]	i_data_a,
	input		[31:0]	i_data_b,
	input		[2:0]	i_func
);
	wire 	 	[31:0]	data_b_n;
	wire 	 	[31:0]	data_sum;
	

	assign	data_b_n	= (i_func[2] == 1) ? ~i_data_b : i_data_b;

	assign	{o_data_c, data_sum}	= i_data_a + data_b_n;

	always @(*) begin
		case (i_func[1:0])
			2'b00	: o_data_y	= i_data_a & data_b_n;
			2'b01	: o_data_y	= i_data_a | data_b_n;
			2'b10	: o_data_y	= data_sum;
			default	: o_data_y	= i_func[2] ? i_data_a < i_data_b : 'd0;
		endcase
	end

endmodule
	

