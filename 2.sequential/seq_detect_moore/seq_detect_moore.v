module seq_detect_moore
(
	output reg		o_out,
	input			i_seq,
	input			i_clk,
	input			i_rstn
);

	reg		[2:0]	cstate;
	reg		[2:0]	nstate;
	reg				seq;

	parameter	S_IDLE	=	3'b000;
	parameter	S_H  	=	3'b001;
	parameter	S_HL	=	3'b010;
	parameter	S_HLH	=	3'b011;
	parameter	S_HLHH	=	3'b100;

	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cstate	<= S_IDLE;
			seq		<= 1'b0;
		end else begin
			cstate	<= nstate;
			seq		<= i_seq;
		end
	end

	always @(*) begin
		if(seq == 1'b0) begin
			case(cstate)
				S_IDLE	:	nstate = S_IDLE; 
				S_H     :	nstate = S_HL;   
				S_HL    :	nstate = S_IDLE;  
				S_HLH   :	nstate = S_HL; 
				S_HLHH  :	nstate = S_IDLE;
			endcase
		end else begin
			case(cstate)
				S_IDLE	:	nstate = S_H; 
				S_H     :	nstate = S_H;   
				S_HL    :	nstate = S_HLH;  
				S_HLH   :	nstate = S_HLHH; 
				S_HLHH  :	nstate = S_H;
			endcase
		end
	end

	always @(*) begin
		case(cstate)
			S_HLHH	: 	o_out	= 1'b1;
			default	:	o_out	= 1'b0;
		endcase
	end

endmodule

