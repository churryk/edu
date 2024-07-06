module carry_lookahead_adder
#(
	parameter	BIT		= 32
)
(
	output		[BIT-1:0]			o_data_s,
	output							o_carry,
	input		[BIT-1:0]			i_data_a,
	input		[BIT-1:0]			i_data_b,
	input							i_carry
);
	wire		[(BIT/4)-1:0]		m_data_c;

`ifdef	GENER
	genvar	g;
	generate
		for (g=0; g<BIT/4; g=g+1) begin
			if(g==0) 
				cla_block u_cla_block( m_data_c[g], o_data_s[((g+1)*4)-1:g*4], i_data_a[((g+1)*4)-1:g*4], i_data_b[((g+1)*4)-1:g*4], i_carry);	
			else
				cla_block u_cla_block( m_data_c[g], o_data_s[((g+1)*4)-1:g*4], i_data_a[((g+1)*4)-1:g*4], i_data_b[((g+1)*4)-1:g*4], m_data_c[g-1]);	
		end
	endgenerate

	assign o_carry = m_data_c[BIT-1];

`else
	cla_block u_cla_block1( m_data_c[0], o_data_s[3:0],   i_data_a[3:0],   i_data_b[3:0],   i_carry);	
	cla_block u_cla_block2( m_data_c[1], o_data_s[7:4],   i_data_a[7:4],   i_data_b[7:4],   m_data_c[0]);
	cla_block u_cla_block3( m_data_c[2], o_data_s[11:8],  i_data_a[11:8],  i_data_b[11:8],  m_data_c[1]);
	cla_block u_cla_block4( m_data_c[3], o_data_s[15:12], i_data_a[15:12], i_data_b[15:12], m_data_c[2]);
	cla_block u_cla_block5( m_data_c[4], o_data_s[19:16], i_data_a[19:16], i_data_b[19:16], m_data_c[3]);
	cla_block u_cla_block6( m_data_c[5], o_data_s[23:20], i_data_a[23:20], i_data_b[23:20], m_data_c[4]);
	cla_block u_cla_block7( m_data_c[6], o_data_s[27:24], i_data_a[27:24], i_data_b[27:24], m_data_c[5]);
	cla_block u_cla_block8( o_carry,     o_data_s[31:28], i_data_a[31:28], i_data_b[31:28], m_data_c[6]);
`endif

endmodule

module cla_block
(
	output				o_carry,
	output	[3:0]		o_data_s,
	input	[3:0]		i_data_a,
	input	[3:0]		i_data_b,
	input				i_carry
);
	wire	[2:0]		m_data_c;
	wire	[3:0]		g;
	wire	[3:0]		p;

	assign g[0]		= i_data_a[0] & i_data_b[0];
	assign g[1]		= i_data_a[1] & i_data_b[1];
	assign g[2]		= i_data_a[2] & i_data_b[2];
	assign g[3]		= i_data_a[3] & i_data_b[3];

	assign p[0]		= i_data_a[0] | i_data_b[0];
	assign p[1]		= i_data_a[1] | i_data_b[1];
	assign p[2]		= i_data_a[2] | i_data_b[2];
	assign p[3]		= i_data_a[3] | i_data_b[3];

	assign m_data_c[0]		= g[0] | (p[0] & i_carry);
	assign m_data_c[1]		= g[1] | (p[1] & m_data_c[0]);
	assign m_data_c[2]		= g[2] | (p[2] & m_data_c[1]);
	assign o_carry			= g[3] | (p[3] & m_data_c[2]);

	assign o_data_s[0]		= (i_data_a[0] ^ i_data_b[0]) ^ i_carry;
	assign o_data_s[1]		= (i_data_a[1] ^ i_data_b[1]) ^ m_data_c[0];
	assign o_data_s[2]		= (i_data_a[2] ^ i_data_b[2]) ^ m_data_c[1];
	assign o_data_s[3]		= (i_data_a[3] ^ i_data_b[3]) ^ m_data_c[2];


endmodule

module compare_adder
#(
	parameter	BIT		= 32
)
(
	output	[BIT-1:0]		o_data_s,
	output					o_carry,
	input	[BIT-1:0]		i_data_a,
	input	[BIT-1:0]		i_data_b,
	input					i_carry
);

	assign {o_carry, o_data_s} = i_data_a + i_data_b + i_carry;

endmodule
