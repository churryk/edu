`timescale 1ns / 1ps
module tb_output ;

parameter cyc_h = 5.0;
parameter cyc   = cyc_h * 2.0;

reg		 [7:0]		P_SEL;
reg					P_WR;
reg					P_RD;
reg		 [31:0]		P_ADDR;
reg		 [31:0]		P_WDATA;
wire	 [31:0]		P_RDATA;
wire				P_RDY;

reg 	       		S_ERR;
reg 	 [2:0] 		S_VAL;
reg 	       		S_SOB;
reg 	       		S_EOB;
reg 	 [31:0]		S_DAT;
wire	       		S_RDY;

wire		        S_ERR_O;
wire	 [2:0]     	S_VAL_O;
wire		        S_SOB_O;
wire		        S_EOB_O;
wire	 [31:0]    	S_DAT_O;
reg 		        S_RDY_O;

wire	 [63:0]		H_DAT;
wire	 [7:0]		H_RDY;
wire	 [2:0]		H_CPU;
wire	 [7:0]		H_INFO;
wire	 [7:0]		H_DAT_END;
wire	 [7:0]		H_PKT_END;
wire	 [7:0]		H_VALID;

wire	 [33:0]		LC_DAT_C0;
wire	 [33:0]		LC_DAT_C1;
wire	 [33:0]		LC_DAT_C2;
wire	 [33:0]		LC_DAT_C3;
wire	 [33:0]		LC_DAT_C4;
wire	 [33:0]		LC_DAT_C5;
wire	 [33:0]		LC_DAT_C6;
wire	 [33:0]		LC_DAT_C7;

wire	 [7:0]  	LC_VAL;
wire	 [7:0]  	LC_RDY;

wire	 [16:0]		OF_ADDR;
wire	 			OF_WR;
wire	 			OF_RD;
wire	 [15:0]		OF_WEN;
wire	 [127:0]	OF_mem_D;
wire	 [127:0]	OF_mem_Q;
wire	 			OF_RDY_P;

wire	 [7:0] 		X_ON_QUE;
wire	 [7:0]     	LC_PKT_cmd_end;

reg		 [7:0]		CPU_P_SEL;
wire				CPU_P_RDY;
reg					CPU_P_WR;
reg					CPU_P_RD;
reg		 [31:0]		CPU_P_ADDR;
reg	 	 [31:0]		CPU_P_WDATA;
wire	 [31:0]		CPU_P_RDATA;

reg		 [16:0]		DMA_ADDR;
reg		 [15:0]		DMA_WEN;
reg					DMA_WR;
reg					DMA_RD;
reg 	 [127:0]	DMA_mem_D;
wire	 [127:0]	DMA_mem_Q;
wire  				DMA_RDY_P;

reg		 [16:0]		C0_ADDR;
reg		 [3:0]		C0_WEN;
reg					C0_WR;
reg					C0_RD;
reg		 [31:0]		C0_mem_D;
wire  				C0_RDY_P;

reg		 [16:0]		C1_ADDR;
reg		 [3:0]		C1_WEN;
reg					C1_WR;
reg					C1_RD;
reg		 [31:0]		C1_mem_D;
wire	  			C1_RDY_P;

reg	 	[16:0]		C2_ADDR;
reg		 [3:0]		C2_WEN;
reg					C2_WR;
reg					C2_RD;
reg	 	[31:0]		C2_mem_D;
wire  				C2_RDY_P;

reg		[16:0]		C3_ADDR;
reg	 	[3:0]		C3_WEN;
reg					C3_WR;
reg					C3_RD;
reg		[31:0]		C3_mem_D;
wire  				C3_RDY_P;

reg		[16:0]		C4_ADDR;
reg	 	[3:0]		C4_WEN;
reg					C4_WR;
reg					C4_RD;
reg	 	 [31:0]		C4_mem_D;
wire  				C4_RDY_P;

reg		 [16:0]		C5_ADDR;
reg		 [3:0]		C5_WEN;
reg					C5_WR;
reg					C5_RD;
reg	 	[31:0]		C5_mem_D;
wire  				C5_RDY_P;

reg		 [16:0]		C6_ADDR;
reg		 [3:0]		C6_WEN;
reg					C6_WR;
reg					C6_RD;
reg		 [31:0]		C6_mem_D;
wire  				C6_RDY_P;

reg	 	[16:0]		C7_ADDR;
reg	 	[3:0]		C7_WEN;
reg	 			   	C7_WR;
reg	 	   			C7_RD;
reg	 	[31:0]		C7_mem_D;
wire 	 			C7_RDY_P;

reg	 	[16:0]		MC_ADDR;
reg		 [3:0]		MC_WEN;
reg					MC_WR;
reg					MC_RD;
reg		 [31:0]		MC_mem_D;
wire  				MC_RDY_P;

reg	    			DMA_P_SEL;       
reg	 	 [7:0]   	DMA_P_ADDR;      
reg					DMA_P_WR;        
reg					DMA_P_RD;        
reg		 [31:0]		DMA_P_WDATA;     
reg	 	[31:0]		DMA_P_RDATA;     
wire     			DMA_P_RDY;       

wire	 [16:0]		DMA_128_ADDR;   
wire	    		DMA_128_WR;	    
wire				DMA_128_RD;     
wire	 [15:0]		DMA_128_WEN;    
wire	 [127:0]	DMA_128_mem_D;  
wire	 [127:0]	DMA_128_mem_Q;  
wire	       		DMA_128_RDY_P;                               

wire	 [16:0]		DMA_64_ADDR;   
wire	    		DMA_64_WR;	    
wire				DMA_64_RD;     
wire	 [7:0]  	DMA_64_WEN;    
wire	 [127:0]	DMA_64_mem_D;  
reg 	 [63:0]		DMA_64_mem_Q;  
//reg             DMA_64_RDY_P;  

//----------------------------------------------------------------------
reg  [13:0]     BUF0_RPTR_T;
reg  [13:0]     BUF1_RPTR_T;
reg  [13:0]     BUF2_RPTR_T;
reg  [13:0]     BUF3_RPTR_T;
reg  [13:0]     BUF4_RPTR_T;
reg  [13:0]     BUF5_RPTR_T;
reg  [13:0]     BUF6_RPTR_T;
reg  [13:0]     BUF7_RPTR_T;
reg  [13:0]		R_ADDR;     

reg  [15:0]     BUF0_BASE_ADDR;
reg  [15:0]     BUF1_BASE_ADDR;
reg  [15:0]     BUF2_BASE_ADDR;
reg  [15:0]     BUF3_BASE_ADDR;
reg  [15:0]     BUF4_BASE_ADDR;
reg  [15:0]     BUF5_BASE_ADDR;
reg  [15:0]     BUF6_BASE_ADDR;
reg  [15:0]     BUF7_BASE_ADDR;
reg  [15:0]		BASE_ADDR;

reg  [13:0]     SRAM_WPTR; 
reg  [13:0]     SRAM0_WPTR; 
reg  [13:0]     SRAM1_WPTR; 
reg  [13:0]     SRAM2_WPTR; 
reg  [13:0]     SRAM3_WPTR; 
reg  [13:0]     SRAM4_WPTR; 
reg  [13:0]     SRAM5_WPTR; 
reg  [13:0]     SRAM6_WPTR; 
reg  [13:0]     SRAM7_WPTR; 

reg  [15:0]     TEST_NUM;

reg  [127:0]    CLK_cnt;
reg  [13:0]     data_32_cnt;
reg  [13:0]		data_cnt;
reg  [31:0]		data;       

reg  [2:0]      cmd_queue;
reg  [1:0]		val;

assign data_32_cnt = data_cnt/4;
//----------------------------------------------------------------------
wire [2:0] cpu_idx     = tb_output.I__OE_TOP.I__OE_PKT_CTRL.r_BUF_QC_CPU_IDX[2:0];
wire [2:0] A_QUEUE_IDX = tb_output.I__OE_TOP.I__OE_PKT_CTRL.A_QUEUE_IDX[2:0];
wire [2:0] A_CPU_IDX   = tb_output.I__OE_TOP.I__OE_PKT_CTRL.A_CPU_IDX[2:0];
//----------------------------------------------------------------------
reg CLK, SRESET;

initial begin		
        CLK_cnt = 0;
	CLK = 0;
	#(cyc);
	while (1) begin
	       CLK = 1;
	       #(cyc_h);
	       CLK = 0;
	       #(cyc_h);
	end
end
initial begin
	SRESET = 1;                  
	#(cyc*10);
	#(cyc*0.1);
	SRESET = 1;
	#(cyc*10);
	SRESET = 0;
end

always @(posedge CLK) data = $urandom;
always @(posedge CLK) CLK_cnt = #1 CLK_cnt+1;
//----------------------------------------------------------------------
// MAKE SOB, EOB
wire [13:0] S_LEN = tb_output.I__OE_TOP.I__OE_PKT_CTRL.S_LEN[13:0];

reg S_SOB_PRE;
reg S_SOB_1D;
reg S_SOB_R;

assign S_SOB = (data_cnt == 32'h4) & S_RDY & S_SOB_R & !S_SOB_PRE;
always @(posedge CLK) S_SOB_1D = #1 S_SOB;

always @(posedge CLK) begin
 	if (S_SOB)              S_SOB_PRE <= #1 1'b1;
 	if (!S_SOB_1D & !S_SOB) S_SOB_PRE <= #1 1'b0;
end

 	reg S_EOB_PRE;
 	reg S_EOB_1D;
 	reg S_EOB_R;

assign S_EOB = (data_cnt == S_LEN) & S_RDY & !S_EOB_PRE;
always @(posedge CLK) S_EOB_1D = #1 S_EOB;

always @(posedge CLK) begin
 	if (S_EOB)                      S_EOB_PRE <= #1 1'b1;
 	if (!S_EOB_1D & !S_EOB & S_SOB) S_EOB_PRE <= #1 1'b0;
end
//---------------------------------------------------------------------------
//MAKE WPTR
wire X_ADDR_toggle 	= tb_output.I__OE_TOP.I__OE_X_CONV.X_ADDR_toggle;
wire X_WR_128      	= tb_output.I__OE_TOP.I__OE_X_CONV.X_WR_128;
wire mem_rd	   	= tb_output.I__OE_TOP.I__OE_INPUT_FIFO.mem_rd;
wire X_RD_128      	= tb_output.I__OE_TOP.I__OE_X_CONV.X_RD_128;
wire dma_w_valid_2 	= tb_output.I__DMA_CTRL.dma_w_valid_2;
wire mem_Q_64_valid	= tb_output.I__DMA_CTRL.mem_Q_64_valid;

always @(posedge CLK) begin
    if (SRESET) begin
         BUF0_BASE_ADDR <= #1 (16'h000<<3);
         BUF1_BASE_ADDR <= #1 (16'h400<<3); 
         BUF2_BASE_ADDR <= #1 (16'h800<<3);
         BUF3_BASE_ADDR <= #1 (16'hc00<<3);
         BUF4_BASE_ADDR <= #1 (16'h1000<<3);
         BUF5_BASE_ADDR <= #1 (16'h1400<<3);
         BUF6_BASE_ADDR <= #1 (16'h1800<<3);
         BUF7_BASE_ADDR <= #1 (16'h1c00<<3); 
    end
end

always @(posedge CLK) begin
	  BASE_ADDR = (A_QUEUE_IDX == 3'h0) ? BUF0_BASE_ADDR[15:0] :
	  	          (A_QUEUE_IDX == 3'h1) ? BUF1_BASE_ADDR[15:0] :
	  	          (A_QUEUE_IDX == 3'h2) ? BUF2_BASE_ADDR[15:0] :
	  	          (A_QUEUE_IDX == 3'h3) ? BUF3_BASE_ADDR[15:0] :
	  	          (A_QUEUE_IDX == 3'h4) ? BUF4_BASE_ADDR[15:0] :
	  	          (A_QUEUE_IDX == 3'h5) ? BUF5_BASE_ADDR[15:0] :
	  	          (A_QUEUE_IDX == 3'h6) ? BUF6_BASE_ADDR[15:0] :
	  	          (A_QUEUE_IDX == 3'h7) ? BUF7_BASE_ADDR[15:0] : 16'h0;
end

always @(posedge CLK) begin
    if (SRESET) begin
         SRAM0_WPTR <= #1 {14'h0};
         SRAM1_WPTR <= #1 {14'h0};
         SRAM2_WPTR <= #1 {14'h0};
         SRAM3_WPTR <= #1 {14'h0};
         SRAM4_WPTR <= #1 {14'h0};
         SRAM5_WPTR <= #1 {14'h0};
         SRAM6_WPTR <= #1 {14'h0};
         SRAM7_WPTR <= #1 {14'h0};
    end else if (mem_rd) begin
        if (cmd_queue == 0)    SRAM0_WPTR <= #1 (SRAM0_WPTR == 14'h3ff ) ? 14'h0 : SRAM0_WPTR + 14'h10;      
        if (cmd_queue == 1)    SRAM1_WPTR <= #1 (SRAM1_WPTR == 14'h3ff ) ? 14'h0 : SRAM1_WPTR + 14'h10;      
        if (cmd_queue == 2)    SRAM2_WPTR <= #1 (SRAM2_WPTR == 14'h3ff ) ? 14'h0 : SRAM2_WPTR + 14'h10; 
        if (cmd_queue == 3)    SRAM3_WPTR <= #1 (SRAM3_WPTR == 14'h3ff ) ? 14'h0 : SRAM3_WPTR + 14'h10; 
        if (cmd_queue == 4)    SRAM4_WPTR <= #1 (SRAM4_WPTR == 14'h3ff ) ? 14'h0 : SRAM4_WPTR + 14'h10; 
        if (cmd_queue == 5)    SRAM5_WPTR <= #1 (SRAM5_WPTR == 14'h3ff ) ? 14'h0 : SRAM5_WPTR + 14'h10; 
        if (cmd_queue == 6)    SRAM6_WPTR <= #1 (SRAM6_WPTR == 14'h3ff ) ? 14'h0 : SRAM6_WPTR + 14'h10; 
        if (cmd_queue == 7)    SRAM7_WPTR <= #1 (SRAM7_WPTR == 14'h3ff ) ? 14'h0 : SRAM7_WPTR + 14'h10; 
    end
end

always @(posedge CLK) begin
	  SRAM_WPTR = (cmd_queue == 3'h0) ? SRAM0_WPTR :
	  	      (cmd_queue == 3'h1) ? SRAM1_WPTR :
	  	      (cmd_queue == 3'h2) ? SRAM2_WPTR :
	  	      (cmd_queue == 3'h3) ? SRAM3_WPTR :
	  	      (cmd_queue == 3'h4) ? SRAM4_WPTR :
	  	      (cmd_queue == 3'h5) ? SRAM5_WPTR :
	  	      (cmd_queue == 3'h6) ? SRAM6_WPTR :
	  	      (cmd_queue == 3'h7) ? SRAM7_WPTR : 14'h0;
end
//---------------------------------------------------------------------------
//RDY_CTRL
reg [7:0] rdy_r;
reg 	  rdy_ctrl;
reg 	  DMA_64_RDY_P;
reg 	  rdy_ctrl_pre;

	always @(posedge CLK) rdy_r = $urandom;

	assign rdy_ctrl_pre =  rdy_r[0] & rdy_r[1];// & rdy_r[2];// & rdy_r[3] & rdy_r[4] & rdy_r[5] ;  
	always @(posedge CLK) DMA_64_RDY_P =  #1 !rdy_ctrl_pre; 
	//assign DMA_64_RDY_P = 1'b1;
//---------------------------------------------------------------------------
OE_TOP           I__OE_TOP (
    .P_SEL               (P_SEL          ),
    .P_ADDR              (P_ADDR[7:2]    ),
    .P_WR                (P_WR           ),
    .P_RD                (P_RD           ),
    .P_WDATA             (P_WDATA        ),
    .P_RDATA             (P_RDATA        ),			//output
    .P_RDY               (P_RDY          ),			//output

    .S_ERR_I             (1'b0           ),
    .S_VAL_I             (S_VAL          ),
    .S_SOB_I             (S_SOB          ),
    .S_EOB_I             (S_EOB          ),
    .S_DAT_I             (S_DAT          ),
    .S_RDY_I             (S_RDY          ),

    .S_VAL_O             (S_VAL_O        ),			//output
    .S_SOB_O             (S_SOB_O        ),			//output
    .S_EOB_O             (S_EOB_O        ),			//output
    .S_DAT_O             (S_DAT_O        ),			//output
    .S_RDY_O             (1'b1           ),


    .H_VALID             (H_VALID        ),			//output
    .H_INFO              (H_INFO         ),			//output
    .H_CPU               (H_CPU          ),			//output
    .H_DAT               (H_DAT          ),			//output
    .H_DAT_END           (H_DAT_END      ),			//output
    .H_PKT_END           (H_PKT_END      ),			//output
    .H_RDY               (H_RDY          ),

    .LC_DAT_C0           (LC_DAT_C0      ), 
    .LC_DAT_C1           (LC_DAT_C1      ),
    .LC_DAT_C2           (LC_DAT_C2      ),
    .LC_DAT_C3           (LC_DAT_C3      ),
    .LC_DAT_C4           (LC_DAT_C4      ),
    .LC_DAT_C5           (LC_DAT_C5      ),
    .LC_DAT_C6           (LC_DAT_C6      ),
    .LC_DAT_C7           (LC_DAT_C7      ),
                                  
    .LC_VAL              (LC_VAL         ),
    .LC_RDY              (LC_RDY         ),

    .X_ON_QUE            (X_ON_QUE       ),
    .LC_PKT_cmd_end      (LC_PKT_cmd_end ),

    .OF_ADDR             (OF_ADDR        ),			//output
    .OF_WR               (OF_WR          ),			//output
    .OF_RD               (OF_RD          ),			//output
    .OF_WEN              (OF_WEN         ),			//output
    .OF_mem_D  	         (OF_mem_D       ),			//output
    .OF_mem_Q  	         (OF_mem_Q       ),
    .OF_RDY_P            (OF_RDY_P       ),

    .LC_PKT_cmd_end      (LC_PKT_cmd_end ),

    .SRESET              (SRESET         ),
    .CLK                 (CLK            )
 );



LOCAL_CPU_TOP_8X      I__LOCAL_CPU_TOP_8X    (
    .P_SEL               (CPU_P_SEL      ),
    .P_ADDR              (CPU_P_ADDR     ),
    .P_WR                (CPU_P_WR       ),
    .P_RD                (CPU_P_RD       ),
    .P_WDATA             (CPU_P_WDATA    ),
    .P_RDATA             (CPU_P_RDATA    ),			//output
    .P_RDY               (CPU_P_RDY      ),			//output

    .H_VALID             (H_VALID        ),
    .H_INFO              (H_INFO	     ),
    .H_CPU               (H_CPU          ),
    .H_DAT               (H_DAT          ),
    .H_DAT_END           (H_DAT_END      ),
    .H_PKT_END           (H_PKT_END      ),
    .H_RDY               (H_RDY          ),			//output

    .LC_VAL              (LC_VAL         ),			//output
    .LC_RDY              (8'hff           ),

    .LC_DAT_C0           (LC_DAT_C0      ),			//output
    .LC_DAT_C1           (LC_DAT_C1      ),			//output
    .LC_DAT_C2           (LC_DAT_C2      ),			//output
    .LC_DAT_C3           (LC_DAT_C3      ),			//output
    .LC_DAT_C4           (LC_DAT_C4      ),			//output
    .LC_DAT_C5           (LC_DAT_C5      ),			//output
    .LC_DAT_C6           (LC_DAT_C6      ),			//output
    .LC_DAT_C7           (LC_DAT_C7      ),			//output

    .LC_PKT_cmd_end      (LC_PKT_cmd_end ),			//output

    .SRESET              (SRESET         ),
    .CLK                 (CLK            )
);

SHRD_SRAM_IF      I__SHRD_SRAM_IF    (

    .DMA_128_ADDR        (DMA_128_ADDR   ),
    .DMA_128_WR          (DMA_128_WR     ),
    .DMA_128_RD          (DMA_128_RD     ),
    .DMA_128_WEN         (DMA_128_WEN    ),
    .DMA_128_mem_D       (DMA_128_mem_D  ),
    .DMA_128_mem_Q       (DMA_128_mem_Q  ),
    .DMA_128_RDY_P       (DMA_128_RDY_P  ),

// X_interface (OUTPUT_FIFO)
    .OF_ADDR             (OF_ADDR        ),
    .OF_WR               (OF_WR          ),
    .OF_RD               (OF_RD          ),
    .OF_WEN              (OF_WEN         ),
    .OF_mem_D            (OF_mem_D       ),
    .OF_mem_Q            (OF_mem_Q       ),
    .OF_RDY_P            (OF_RDY_P       ),


    .C0_ADDR             (C0_ADDR        ),
    .C0_WR               (C0_WR          ),		
    .C0_RD               (C0_RD          ),
    .C0_WEN              (C0_WEN	     ),
    .C0_mem_D            (C0_mem_D       ),
    .C0_mem_Q            (C0_mem_Q       ),
    .C0_RDY_P            (C0_RDY_P       ),

    .C1_ADDR             (C1_ADDR        ),
    .C1_WR               (C1_WR          ),
    .C1_RD               (C1_RD          ),
    .C1_WEN              (C1_WEN	     ),
    .C1_mem_D            (C1_mem_D       ),
    .C1_mem_Q            (C1_mem_Q       ),
    .C1_RDY_P            (C1_RDY_P       ),

    .C2_ADDR             (C2_ADDR        ),
    .C2_WR               (C2_WR          ),
    .C2_RD               (C2_RD          ),
    .C2_WEN              (C2_WEN	     ),
    .C2_mem_D            (C2_mem_D       ),
    .C2_mem_Q            (C2_mem_Q       ),
    .C2_RDY_P            (C2_RDY_P       ),

    .C3_ADDR             (C3_ADDR        ),
    .C3_WR               (C3_WR          ),
    .C3_RD               (C3_RD          ),
    .C3_WEN              (C3_WEN	     ),
    .C3_mem_D            (C3_mem_D       ),
    .C3_mem_Q            (C3_mem_Q       ),
    .C3_RDY_P            (C3_RDY_P       ),

    .C4_ADDR             (C4_ADDR        ),
    .C4_WR               (C4_WR          ),
    .C4_RD               (C4_RD          ),
    .C4_WEN              (C4_WEN	     ),
    .C4_mem_D            (C4_mem_D       ),
    .C4_mem_Q            (C4_mem_Q       ),
    .C4_RDY_P            (C4_RDY_P       ),

    .C5_ADDR             (C5_ADDR        ),
    .C5_WR               (C5_WR          ),
    .C5_RD               (C5_RD          ),
    .C5_WEN              (C5_WEN	     ),
    .C5_mem_D            (C5_mem_D       ),
    .C5_mem_Q            (C5_mem_Q       ),
    .C5_RDY_P            (C5_RDY_P       ),

    .C6_ADDR             (C6_ADDR        ),
    .C6_WR               (C6_WR          ),
    .C6_RD               (C6_RD          ),
    .C6_WEN              (C6_WEN	     ),
    .C6_mem_D            (C6_mem_D       ),
    .C6_mem_Q            (C6_mem_Q       ),
    .C6_RDY_P            (C6_RDY_P       ),

    .C7_ADDR             (C7_ADDR        ),
    .C7_WR               (C7_WR          ),
    .C7_RD               (C7_RD          ),
    .C7_WEN              (C7_WEN	     ),
    .C7_mem_D            (C7_mem_D       ),
    .C7_mem_Q            (C7_mem_Q       ),
    .C7_RDY_P            (C7_RDY_P       ),

    .MC_ADDR             (MC_ADDR        ),
    .MC_WR               (MC_WR          ),
    .MC_RD               (MC_RD          ),
    .MC_WEN              (MC_WEN	     ),
    .MC_mem_D            (MC_mem_D       ),
    .MC_mem_Q            (MC_mem_Q       ),
    .MC_RDY_P            (MC_RDY_P       ),

    .SRESET              (SRESET         ),
    .CLK                 (CLK            )
);

DMA_CTRL          I__DMA_CTRL        (

    .P_SEL               (DMA_P_SEL      ),
    .P_ADDR              (DMA_P_ADDR     ),
    .P_WR                (DMA_P_WR       ),
    .P_RD                (DMA_P_RD       ),
    .P_WDATA             (DMA_P_WDATA    ),
    .P_RDATA             (DMA_P_RDATA    ),			//output
    .P_RDY               (DMA_P_RDY      ),			//output

    .DMA_128_ADDR        (DMA_128_ADDR   ),			//output
    .DMA_128_WR          (DMA_128_WR	 ),			//output
    .DMA_128_RD          (DMA_128_RD     ),			//output
    .DMA_128_WEN         (DMA_128_WEN    ),			//output
    .DMA_128_mem_D       (DMA_128_mem_D  ),			//output
    .DMA_128_mem_Q       (DMA_128_mem_Q  ),
    .DMA_128_RDY_P       (DMA_128_RDY_P  ),

    .DMA_64_ADDR         (DMA_64_ADDR    ),			//output
    .DMA_64_WR           (DMA_64_WR	     ),			//output
    .DMA_64_RD           (DMA_64_RD      ),			//output
    .DMA_64_WEN          (DMA_64_WEN     ),			//output
    .DMA_64_mem_D        (DMA_64_mem_D   ),			//output
    .DMA_64_mem_Q        (DMA_64_mem_Q   ),
    .DMA_64_RDY_P        (DMA_64_RDY_P   ),

    .SRESET              (SRESET         ),
    .CLK                 (CLK            )
);

reg [15:0] test_for;
reg [2:0]  test_queue;
reg [9:0]  test_len;
reg [1:0]  test_val;
`include "pkt_task.v" 

//---------------------------------------------------------------------------
initial begin

	RESET();
	BUF_REG_SET();
	repeat(100) @(posedge CLK); #1;

	//TEST1  //ififo //H_DAT<1F
   	TEST(3'h4, 14'h40, 2'b11);                    //NPU IN : queue, len, val  
	repeat(100) @(posedge CLK); #1;
	CMD_TEST(9'b0_1100_1111, 3'h4, 10'h40, 2'b11);  //CMD IN : cmd_sel, queue, len, val
   	 //[7]intr, [6]ififo, [5]rsram, [4]wsram, [3]const4, [2]const3,[1]const2,[0]const1	
    
	//TEST2 //ififo //H_DAT>1F
    	CMD_RD(9'b1100_1111, 3'h4, 10'h80, 2'b10);    //CMD IN : queue, len, val 
	repeat(100) @(posedge CLK); #1;
   	TEST(3'h4, 14'h120, 2'b10);                   
	repeat(300) @(posedge CLK); #1;
	CMD_TEST(9'b0_1100_1111, 3'h4, 10'h120, 2'b11); 
 
    
	//TEST2 //random
	for(test_for=0; test_for<30; test_for++) begin
		test_queue = $urandom;
		test_len   = $urandom; while(test_len < 10'h40) test_len = $urandom;
		test_val   = $urandom;
	 	TEST(test_queue, test_len, test_val);                      
	end

	repeat(1000) @(posedge CLK);
	$finish;
end

//---------------------------------------------------------------------------
// H_TEST
//---------------------------------------------------------------------------
initial begin
	repeat(100) @(posedge CLK); #1;
	H_R_TEST(3'h0, 8'h12, 7'h0); //TEST1 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h44, 7'h0); //TEST2 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TEST3 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h1, 8'h16, 7'h0); //TEST4 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TEST5 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TEST6 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TEST7 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TEST8 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TEST9 : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TESTa : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TESTb : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TESTc : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr 
	H_R_TEST(3'h0, 8'h16, 7'h0); //TESTd : 0=H_DAT_END, 1=H_dat_cnt==40 \len \start_addr  

end

//---------------------------------------------------------------------------
// CPU0_TEST
//---------------------------------------------------------------------------
reg cpu_infi;
initial begin
   for(cpu_infi=0; cpu_infi<1;) begin
	  if(CLK_cnt == 128'h888) begin

	     CPU0_TEST(20);

	  end else begin
         @(posedge CLK); #1;
	  end
   end
end
//---------------------------------------------------------------------------
// DMA_to_SHRD
//---------------------------------------------------------------------------
reg dma_infi;
initial begin
   for(dma_infi=0; dma_infi<1;) begin
	  if(CLK_cnt == 128'hd40) begin

		 DMA_CTRL(32'h0, 32'h0,{2'b10, 30'ha0});  //DATA0, DATA1, DATA2
         @(posedge CLK); #1;
		 DMA_TEST_64(20);

	  end else begin
         @(posedge CLK); #1;
	  end
   end
end
//---------------------------------------------------------------------------
// DMA_to_SHRD
//---------------------------------------------------------------------------
initial begin
   for(dma_infi=0; dma_infi<1;) begin
	  if(CLK_cnt == 128'hd80) begin

		 DMA_CTRL(32'h0, 32'h0,{2'b01, 30'h80});  //DATA0, DATA1, DATA2

	  end else begin
         @(posedge CLK); #1;
	  end
   end
end

//---------------------------------------------------------------------------
initial begin
   $vcdplusfile("tb_output.vpd");
   $vcdpluson(0, tb_output);
   $vcdplusmemon(0, tb_output);
end

endmodule


