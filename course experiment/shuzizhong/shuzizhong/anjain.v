	module  anjian(  
	input	wire 		clk    ,  
	input	wire  		rst_n  ,  
	input	wire [ 2:0] key    ,
	
	output	wire 		led    ,
	output	wire		buzzer ,
	output	wire [ 7:0] segment, 	
	output	wire [ 5:0]  seg_sel  
	);  
	  
	parameter   COUNT_TIME      =   28'd5000_0000;  
	parameter   DELAY_TIME      =   10000       ;  
	parameter   SEG_WID         =   8           ;  
	parameter   SEG_SEL         =   6           ;  
	parameter   KEY_S           =   4           ;  
	parameter   KEY_W           =   3           ;  
	  
	wire    [ 2:0]   key_vld     ;	
	wire    [23:0]   segment_data;    
	wire    [ 3:0]   cnt2        ;  
	wire    [ 3:0]   cnt3        ;  
	wire    [ 3:0]   cnt4        ;  
	wire    [ 3:0]   cnt5        ;  
	wire    [ 3:0]   cnt6        ;  
	wire    [ 3:0]   cnt7        ;  
	wire    [23:0]   cnt		 ;


	assign cnt[23:0]  ={cnt7[3:0],cnt6[3:0],cnt5[3:0],cnt4[3:0],cnt3[3:0],cnt2[3:0]};
	
	
	key_module  uut0(  
		.clk     (clk    ),  
		.rst_n   (rst_n  ),  
		.key_in  (key    ),  
		.key_vld (key_vld)  
	);  
	
	time_data  uut1(  
		.clk      (clk    ),   
		.rst_n    (rst_n  ),   
		.key_vld  (key_vld),   
		.cnt2     (cnt2   ),   
		.cnt3     (cnt3   ),   
		.cnt4     (cnt4   ),   
		.cnt5     (cnt5   ),   
		.cnt6     (cnt6   ),   
		.cnt7     (cnt7   )   
	
	);  
	
	seg_disp  uut2(  
		.clk          (clk      ),   
		.rst_n        (rst_n    ),   
		.segment      (segment  ),   
		.seg_sel      (seg_sel  ),  
		.segment_data (cnt	 	)						  
	);  
	
	naozhong  uut3(  
		.clk      (clk    ),   
		.rst_n    (rst_n  ),    
		.cnt2     (cnt2   ),   
		.cnt3     (cnt3   ),   
		.cnt4     (cnt4   ), 
		.cnt5	  (cnt5   ),
		.led      (led    ),
		.buzzer   (buzzer )   
	
	);
		
	endmodule  




