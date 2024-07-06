////////////////////////////////////////////////////////////////////////////////////////////////////////
task START();
	input	[31:0]	data;
	reg		first;
	reg	[31:0]  ran_end;
	begin
		S_VAL = 3'b100;
		S_SOB_R =  1;
		S_DAT =  data;
		data_cnt = 32'h4;
		@(posedge CLK);	#1;

		S_VAL = 3'b100;
		S_DAT =  32'h1111_1111;
		data_cnt = data_cnt + 32'h4;
		@(posedge CLK);	#1;
		CPU_P_SEL  = {29'h0, A_CPU_IDX};
		S_VAL = 3'b100;
		S_DAT =  32'h2222_2222;
		data_cnt = data_cnt + 32'h4;
		@(posedge CLK);	#1;
	end
endtask
task MIDDLE();
    input	[31:0]	data;
    begin
	S_VAL = 3'b100;
    	S_DAT =  data;
	data_cnt = data_cnt + 32'h4;
    	@(posedge CLK);	#1;	
	end
endtask
task END();
    	input	[1:0]	val;
	input	[31:0]	data;
	begin
        S_SOB_R =  0;
	S_VAL = {1'b1, val};
	S_DAT = data;
	data_cnt = data_cnt + val;
	@(posedge CLK);	#1;
	end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task TEST();

   input [2:0]  queue;
   input [13:0] len;
   input [1:0]  val;
   reg   [7:0]  infi;
   reg 		none;

  begin
	@(posedge CLK); #1;
	TEST_NUM = TEST_NUM + 1'b1;
        for(infi=0; infi<5;) begin
      		if(S_RDY == 1 && (|X_ON_QUE)) begin
      	        START({13'h0, queue, 2'h0, (len+val)});	infi=8'h5;
      		   for(none=0; data_cnt<len;) begin                      
      		      MIDDLE(data);					
      		   end
      		   END(val, 32'h9999_9999);				
		   @(posedge CLK); #1;
      		end else begin
      		   @(posedge CLK); #1; infi = infi + 8'h1;
      		end
      	 end
  end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task CPU_REG();

    input  [31:0]	sel;
    input  [31:0]	addr;
    input  [33:0]	data;
	reg             i;

   begin
	CPU_P_SEL = sel; CPU_P_ADDR = addr; CPU_P_WDATA = data; CPU_P_WR = 1'b1; 
	repeat(1) @(posedge CLK);#1;
	for(i=0; i<1;) begin
	   if (CPU_P_RDY == 1) begin 
	        CPU_P_WR = 1'b0; i = 1'b1;  
	   end
	   else begin
		@(posedge CLK); #1;
	   end
	end
   	@(posedge CLK); #1;
   	@(posedge CLK); #1;
        CPU_P_SEL = 32'h0; CPU_P_ADDR = 32'h0; CPU_P_WDATA = 32'h0;   
   	@(posedge CLK); #1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task CMD_TEST();

   input [8:0] cmd_sel;
   input [2:0] queue;
   input [9:0] len;
   input [1:0] val;

  begin
	repeat(1) @(posedge CLK);#1;
	cmd_queue = queue;
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h000}, BASE_ADDR);                 //pkt_baddr  
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h004}, BASE_ADDR);                 //sram_baddr 
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h008}, SRAM_WPTR);                 //wsram_addr 
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h00c}, {queue,16'h0});             //pkt_queue
	if(cmd_sel[8] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h028}, 1'b1);                      //transfer
	end
	if(cmd_sel[0] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h010}, {2'h1,22'h0,8'h21});        //const_1
	end
	if(cmd_sel[1] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h010}, {2'h2,14'h0,16'h6543});     //const_2
	end
	if(cmd_sel[2] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h010}, {2'h3,6'h0,24'h654321});    //const_3
	end
	if(cmd_sel[3] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h014}, 32'h98765432);              //const_4
	end
	if(cmd_sel[4] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h018}, {(len+val), R_ADDR});       //wsram
	end
	if(cmd_sel[5] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h01c}, {(len+val), SRAM_WPTR});    //rsram
	end
	if(cmd_sel[6] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h020}, {(len+val), R_ADDR});       //ififo
	end
	if(cmd_sel[7] == 1'b1) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h024}, 28'h1234567);               //intr
	end
	if(cmd_sel[8] == 1'b0) begin
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h028}, 1'b1);                      //transfer
	end
	CPU_REG({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 12'h02c}, 1'b1);                      //end
	repeat(200) @(posedge CLK); #1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task CPU_REG_RD();

    input  [31:0]	sel;
    input  [31:0]	addr;
    input  [33:0]	data;
	reg             i;

   begin
		CPU_P_SEL = sel; CPU_P_ADDR = addr;  CPU_P_RD = 1'b1;  
		repeat(1) @(posedge CLK);#1;
		for(i=0; i<1;) begin
		   if (CPU_P_RDY == 1) begin 
              CPU_P_RD = 1'b0; i = 1'b1; 
		   end
		   else begin
			  @(posedge CLK); #1;
		   end
		end
   	    @(posedge CLK); #1;
		
		CPU_P_SEL = sel; CPU_P_ADDR = CPU_P_ADDR + 3'b100;  CPU_P_RD = 1'b1; 
		repeat(1) @(posedge CLK);#1;
		for(i=0; i<1;) begin
		   if (CPU_P_RDY == 1) begin 
              CPU_P_RD = 1'b0; i = 1'b1; 
		   end
		   else begin
			  @(posedge CLK); #1;
		   end
		end
   	    @(posedge CLK); #1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task CMD_RD();

   input [7:0] cmd_sel;
   input [2:0] queue;
   input [9:0] len;
   input [1:0] val;

   begin

	repeat(1) @(posedge CLK);#1;
	cmd_queue = queue;
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h000}, BASE_ADDR);                 //pkt_baddr  
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h008}, BASE_ADDR);                 //sram_baddr 
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h010}, SRAM_WPTR);                 //wsram_addr 
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h018}, {queue,16'h0});             //pkt_queue
	if(cmd_sel[0] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h020}, {2'h1,22'h0,8'h21});        //const_1
    end
	if(cmd_sel[1] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h028}, {2'h2,14'h0,16'h6543});     //const_2
    end
	if(cmd_sel[2] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h030}, {2'h3,6'h0,24'h654321});    //const_3
    end
	if(cmd_sel[3] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h038}, 1'b1);                      //transfer
    end
	if(cmd_sel[4] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h040}, 32'h98765432);              //const_4
    end
	if(cmd_sel[5] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h038}, {(len+val), R_ADDR});       //wsram
    end
	if(cmd_sel[6] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h040}, {(len+val), SRAM_WPTR});    //rsram
    end
	if(cmd_sel[7] == 1'b1) begin
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h048}, {4'h0, (len+val), R_ADDR}); //ififo
    end
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h050}, 28'h1234567);               //intr
    CPU_REG_RD({29'b0, A_CPU_IDX}, {18'h0, 3'b011, 1'b1, 11'h058},	1'b1);                     //end
	repeat(200) @(posedge CLK); #1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task H_RD();

    input  [7:0]    i;
    input  [2:0]    sel;
    input  [6:0]    start_addr;
    reg    [7:0]    t;
    reg             k;

   begin
	for(t=0; t<i;) begin
	  CPU_P_SEL = sel; CPU_P_ADDR = {17'h0 ,3'h4, 3'h0, start_addr, 2'b0}; CPU_P_WR = 1'b0; CPU_P_RD = 1'b1;
	  repeat(1) @(posedge CLK);#1;
	  for(k=0; k<1;) begin
     	  if(CPU_P_RDY) begin
	 	 CPU_P_RD = 1'b0; #1; k=1'b1;
	         start_addr = start_addr + 1'b1; t = t+1;
		 repeat(1) @(posedge CLK);#1;
	      end else begin
		 repeat(1) @(posedge CLK);#1;
	      end
	  end
    end
    CPU_P_SEL = 32'h0; CPU_P_ADDR = 32'h0;  
    start_addr = 6'h0;
    repeat(1) @(posedge CLK);#1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task H_R_TEST();

    reg             START;
    reg             infi;
    input  [2:0]    start_timing;
    input  [7:0]    len;
    input  [6:0]    start_addr;

    assign START = (start_timing == 0) ? (|H_DAT_END)         :
                   (start_timing == 1) ? (data_cnt == 13'h40) : H_DAT_END;

   begin
	for(infi=0; infi<1;) begin
          if(START) begin
   	         H_RD(len, A_CPU_IDX, start_addr);   //LOCAL_PKT_IN : len, sel, start_addr
   	         H_INFO_RD(A_CPU_IDX);  
		 infi = infi + 1'b1;
          end
          else begin
             @(posedge CLK); #1;
          end
    end
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task H_INFO_RD();

    input [31:0] sel;
	reg   [9:0]  addr;
	reg   [1:0]  i;
	reg          j;

   begin 
    addr = 10'h100;
    for(i=0; i<2; i++) begin
        CPU_P_SEL = sel; CPU_P_ADDR = {17'h0 ,3'h4, 2'h0, addr}; CPU_P_WR = 1'b0; CPU_P_RD = 1'b1; 
	repeat(1) @(posedge CLK);#1;
 	for(j=0; j<1;)begin	
 	      if(CPU_P_RDY) begin
 	         CPU_P_RD = 1'b0; #1; j = 1'b1; addr = 10'h104;
 	         repeat(1) @(posedge CLK);#1;
 	      end else begin
 	         repeat(1) @(posedge CLK);#1;
 	      end
 	   end
 	end
    CPU_P_SEL = 32'h0; CPU_P_ADDR = 32'h0; 
    repeat(1) @(posedge CLK);#1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task CPU0_TEST();

   input [15:0] infi_1;
   reg   [15:0] i_1;

   begin
	C0_WR 	 = 1'b1;
	C0_ADDR  = 17'h0;			
	C0_WEN	 = 4'b1111;
	C0_mem_D = 32'h1111_1111;
	repeat(1) @(posedge CLK); #1;

	for (i_1=0; i_1<infi_1; ) begin
		if(C0_RDY_P == 1) begin
			C0_WR 	 = 1'b1;
			C0_ADDR  = C0_ADDR + 4'b1000;
			C0_WEN	 = 4'b1111;
			C0_mem_D = C0_mem_D + 32'h1111_1111;
			repeat(1) @(posedge CLK); #1;
			i_1 = i_1 + 1'b1;
		end else begin
			repeat(1) @(posedge CLK); #1;
		end
	end
	C0_WR	= 1'b0;
	C0_RD	= 1'b1;
	C0_WEN	= 4'b1111;
	C0_ADDR = {13'h0, 4'h0};			//BASE_ADDR = 13'h0000
	repeat(1) @(posedge CLK); #1;

	for (i_1=0; i_1<infi_1; ) begin
		if(C0_RDY_P == 1) begin
			C0_RD 	 = 1'b1;
			C0_ADDR  = C0_ADDR + 4'b1000;
			C0_WEN	 = 4'b1111;
			repeat(1) @(posedge CLK); #1;
			i_1 = i_1 + 1'b1;
		end else begin
			repeat(1) @(posedge CLK); #1;
		end
	end
	C0_RD	= 1'b0;
	C0_WEN	= 4'b0;
	repeat(1) @(posedge CLK); #1;
	end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task DMA_TEST();

   input [15:0] infi_2;
   reg   [15:0] i_2;

   begin
	DMA_WR = 1'b1; DMA_ADDR = {13'h0, 4'h0}; DMA_WEN = 16'hffff;
	DMA_mem_D = 128'h2222_2222_2222_2222_1111_1111_1111_1111;
	repeat(1) @(posedge CLK); #1;

	for (i_2=0; i_2<infi_2; ) begin
		if(DMA_128_RDY_P == 1) begin
			DMA_WR 	 = 1'b1;
			DMA_ADDR  = DMA_ADDR + 5'b10000;
			DMA_WEN	 = 16'hffff;
			DMA_mem_D = DMA_mem_D + 128'h2222_2222_2222_2222_2222_2222_2222_2222;
			repeat(1) @(posedge CLK); #1;
			i_2 = i_2 + 1'b1;
		end else begin
			repeat(1) @(posedge CLK); #1;
		end
	end
	DMA_WR	= 1'b0;
	repeat(1) @(posedge CLK); #1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task DMA_TEST_64();

   input [15:0] infi_2;
   reg   [15:0] i_2;

   begin
	  
	DMA_64_mem_Q = 64'h1111_1111_1111_1111;
	repeat(1) @(posedge CLK); #1;

	for (i_2=0; i_2<infi_2; ) begin
	 if(DMA_64_RD & DMA_64_RDY_P & dma_w_valid_2 /*& mem_Q_64_valid*/ ) begin
		DMA_64_mem_Q = DMA_64_mem_Q + 64'h1111_1111_1111_1111;
		repeat(1) @(posedge CLK); #1;
		i_2 = i_2 + 1'b1;
	 end else begin
		repeat(1) @(posedge CLK); #1;
	 end

	end
	repeat(1) @(posedge CLK); #1;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task DMA_CTRL();
   input [31:0] data1;
   input [31:0] data2;
   input [31:0] data0;

   begin
	 DMA_P_SEL = 1'b1; DMA_P_ADDR = 8'h1; DMA_P_WR = 1'b1; DMA_P_WDATA = data1;
         @(posedge CLK); #1;
	 DMA_P_SEL = 1'b1; DMA_P_ADDR = 8'h2; DMA_P_WR = 1'b1; DMA_P_WDATA = data2;
         @(posedge CLK); #1;
	 DMA_P_SEL = 1'b1; DMA_P_ADDR = 8'h0; DMA_P_WR = 1'b1; DMA_P_WDATA = data0;
         @(posedge CLK); #1;
	 DMA_P_WR = 1'b0;
   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task RESET();
	 begin
		data_cnt    = 0;
		cmd_queue   = 0;
		CLK         = 0;
   		TEST_NUM    = 16'h0;

		P_SEL	    = 0;
		P_WR	    = 0;
		P_RD	    = 0;
		P_ADDR	    = 0;
		P_WDATA	    = 0;

		CPU_P_SEL	= 0;
		CPU_P_WR	= 0;
		CPU_P_RD	= 0;
		CPU_P_ADDR	= 0;
		CPU_P_WDATA	= 0;

  	     	S_SOB_R	    = 0;
  	      	S_EOB_PRE   = 0;
  	      	S_DAT	    = 0;
  	      	S_VAL	    = 0;

		C0_ADDR     = 0;
 		C0_WR       = 0;
 		C0_RD       = 0;
 		C0_WEN      = 0;

       	 	DMA_P_SEL   = 0;     
       	 	DMA_P_ADDR  = 0;   
       	 	DMA_P_WR    = 0;   
       	 	DMA_P_RD    = 0;   
       	 	DMA_P_WDATA = 0;   

		DMA_64_mem_Q = 64'b0;

		DMA_ADDR	= 17'h0;
		DMA_WR		= 1'b0;
		DMA_RD		= 1'b0;
		DMA_WEN		= 16'b0;
		DMA_mem_D	= 128'b0;

		C0_ADDR		= 17'h0;
		C0_WR		= 1'b0;
		C0_RD		= 1'b0;
		C0_WEN		= 4'b0;
		C0_mem_D	= 32'b0;

		C1_ADDR		= 17'h0;
		C1_WR		= 1'b0;
		C1_RD		= 1'b0;
		C1_WEN		= 4'b0;
		C1_mem_D	= 32'b0;

		C2_ADDR		= 17'h0;
		C2_WR		= 1'b0;
		C2_RD		= 1'b0;
		C2_WEN		= 4'b0;
		C2_mem_D	= 32'b0;

		C3_ADDR		= 17'h0;
		C3_WR		= 1'b0;
		C3_RD		= 1'b0;
		C3_WEN		= 4'b0;
		C3_mem_D	= 32'b0;

		C4_ADDR		= 17'h0;
		C4_WR		= 1'b0;
		C4_RD		= 1'b0;
		C4_WEN		= 4'b0;
		C4_mem_D	= 32'b0;

		C5_ADDR		= 17'h0;
		C5_WR		= 1'b0;
		C5_RD		= 1'b0;
		C5_WEN		= 4'b0;
		C5_mem_D	= 32'b0;

		C6_ADDR		= 17'h0;
		C6_WR		= 1'b0;
		C6_RD		= 1'b0;
		C6_WEN		= 4'b0;
		C6_mem_D	= 32'b0;

		C7_ADDR		= 17'h0;
		C7_WR		= 1'b0;
		C7_RD		= 1'b0;
		C7_WEN		= 4'b0;
		C7_mem_D	= 32'b0;

		MC_ADDR		= 17'h0;
		MC_WR		= 1'b0;
		MC_RD		= 1'b0;
		MC_WEN		= 4'b0;
		MC_mem_D	= 32'b0;

	 	#1; 
	 	@(negedge SRESET);
		repeat(100) @(posedge CLK);
	 end
  endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task BUF_REG();
    input  [31:0]	sel;
    input  [31:0]	addr;
    input  [31:0]	data;
    reg			i;
    reg			for_end;
   begin
	for_end = 1'b0;
	P_SEL = sel; P_ADDR = addr; P_WDATA = data; P_WR = 1'b1; 
	repeat(1) @(posedge CLK);#1;
	for(i=1; for_end<i;) begin
	   if (P_RDY == 1) begin 
		for_end = 1'b1; 
       		P_SEL = 32'h0; P_ADDR = 32'h0; P_WDATA = 32'h0; P_WR = 1'b0;
	   end
	   else begin
		@(posedge CLK); #1;
	   end
	end
   	repeat(4) @(posedge CLK); #1;

   end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
task BUF_REG_SET();
	begin
	BUF_REG(8'b10, {24'h0, 8'h00}, {16'h0, 8'b0000_0011, 8'b1100_0000});  // grp_0  
	BUF_REG(8'b10, {24'h0, 8'h04}, {16'h0, 8'b0000_1100, 8'b0011_0000});  // grp_1  
	BUF_REG(8'b10, {24'h0, 8'h08}, {16'h0, 8'b1001_0000, 8'b0000_1010});  // grp_2  
	BUF_REG(8'b10, {24'h0, 8'h0c}, {16'h0, 8'b0110_0000, 8'b0000_0101});  // grp_3  
	BUF_REG(8'b10, {24'h0, 8'h10}, {16'h0, 8'b0000_0000, 8'b0000_0000});  // grp_4  
	BUF_REG(8'b10, {24'h0, 8'h14}, {16'h0, 8'b0000_0000, 8'b0000_0000});  // grp_5  
	BUF_REG(8'b10, {24'h0, 8'h18}, {16'h0, 8'b0000_0000, 8'b0000_0000});  // grp_6  
	BUF_REG(8'b10, {24'h0, 8'h1c}, {16'h0, 8'b0000_0000, 8'b0000_0000});  // grp_7  

	repeat(100) @(posedge CLK); #1; 

  	BUF_REG(8'b1, 32'h0, 32'hff);					        // BUF_VAL
	BUF_REG(8'b1, {25'h0, 7'h10}, {9'b0, 7'h0a, 1'b0, 7'hf,  1'b0, 7'h0}); 	// buf0  
	BUF_REG(8'b1, {25'h0, 7'h14}, {9'b0, 7'h1a, 1'b0, 7'h1f, 1'b0, 7'h10});	// buf1  
	BUF_REG(8'b1, {25'h0, 7'h18}, {9'b0, 7'h2a, 1'b0, 7'h2f, 1'b0, 7'h20});	// buf2  
	BUF_REG(8'b1, {25'h0, 7'h1c}, {9'b0, 7'h3a, 1'b0, 7'h3f, 1'b0, 7'h30});	// buf3  
	BUF_REG(8'b1, {25'h0, 7'h20}, {9'b0, 7'h4a, 1'b0, 7'h4f, 1'b0, 7'h40});	// buf4  
	BUF_REG(8'b1, {25'h0, 7'h24}, {9'b0, 7'h5a, 1'b0, 7'h5f, 1'b0, 7'h50});	// buf5  
	BUF_REG(8'b1, {25'h0, 7'h28}, {9'b0, 7'h6a, 1'b0, 7'h6f, 1'b0, 7'h60});	// buf6  
	BUF_REG(8'b1, {25'h0, 7'h2c}, {9'b0, 7'h7a, 1'b0, 7'h7f, 1'b0, 7'h70});	// buf7  

	repeat(100) @(posedge CLK); #1; 
	 end
  endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////
