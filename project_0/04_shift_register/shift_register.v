module shift_register
(
	output reg	[7:0]	o_parrel,
	output reg			o_serial,
	input				i_serial,
	input		[7:0]	i_parrel,
	input				load,
	input				i_clk,
	input				i_rstn
);
	reg			[7:0]	m_data;

	always @(*) begin
		if(!i_rstn) begin
			o_parrel	<=  8'h0;
			m_data		<=	8'h0;
		end
	end

	always @(posedge i_clk) begin
		if(load == 1)	begin
			m_data		<=  i_parrel;
		end
		else begin
			o_serial	<=  m_data[7];
			m_data		<=  {m_data[6:0], 1'b0};
			o_parrel	<=  {o_parrel[6:0], i_serial};
		end
	end

		
endmodule
