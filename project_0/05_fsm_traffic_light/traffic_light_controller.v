module mode_fsm
(
	output reg 		mode,
	input			i_perad,
	input			i_stop,
	input			i_clk,
	input			i_rstn
);


	always @(*) begin
		if (!i_rstn)     	  mode <= #1 1'b0;		// s0	
	end

	always @(posedge i_clk) begin
		if (mode == 0) begin
			if (i_perad == 1) mode <= #1 1'b1;		// s1
			else			  mode <= #1 1'b0;	
		end
		else if (mode == 1) begin
			if (i_stop  == 1) mode <= #1 1'b0;		// s0
			else 	  	      mode <= #1 1'b1;
		end
	end

endmodule
		

module light_fsm
(
	output reg	[8*6-1:0]	o_la,
	output reg	[8*6-1:0]	o_lb,
	input					mode,
	input					i_ta,
	input					i_tb,
	input					i_clk,
	input					i_rstn
);
	reg	   		[1:0]		state;

	always @(*) begin
		if (!i_rstn) begin
						state <= #1 2'b0;		// s0
						o_la  <= #1 "green";
						o_lb  <= #1 "red";
		end
	end

	always @(posedge i_clk) begin
		if (state == 0) begin
			if(i_ta == 1 & mode == 0) begin
						state <= #1 2'b1;		// s1
						o_la  <= #1 "yellow";
						o_lb  <= #1 "red";
			end else begin
						state <= state;
		    end
		end
		else if (state == 1) begin
						state <= #1 2'h2;		// s2
						o_la  <= #1 "red";
						o_lb  <= #1 "green";
		end
		else if (state == 2) begin
			if(i_tb == 1 & mode == 0) begin
						state <= #1 2'h3; 		// s3
						o_la  <= #1 "red";
						o_lb  <= #1 "yellow";
			end else begin
						state <= state;
		    end
	    end
		else if (state == 3) begin
						state <= #1 2'h0;		// s0
						o_la  <= #1 "green";
						o_lb  <= #1 "red";
		end
	end

endmodule
