module time_data(  
	input   wire                clk          ,  
	input   wire                rst_n        ,  
	input   wire [ 2:0]         key_vld      ,  
	output  reg	 [ 3:0]         cnt2         ,  
	output  reg	 [ 3:0]         cnt3         ,  
	output  reg	 [ 3:0]         cnt4         ,  
	output  reg	 [ 3:0]         cnt5         ,  
	output  reg	 [ 3:0]         cnt6         ,  
	output  reg	 [ 3:0]         cnt7       
	);  
              
	reg                     key1_func   ;  
	reg                     key3_func   ;  
	reg     [ 2:0]          cnt0        ;  
	reg     [ 28:0]         cnt1       ;  
	reg     [ 3:0]          x           ;  
	reg     [ 1:0]          y           ;  
 
	//调试数码管 调试模式 按键1有关
	always  @(posedge clk or negedge rst_n)begin  
	    if(rst_n==1'b0)begin  
	        key1_func<=1'b0;  
	    end  
	    else if(key_vld[0]==1'b1)begin   //调试状态标志
	        key1_func<=~key1_func;  
	    end  
	    else begin  
	        key1_func<=key1_func;  
	    end  
	end  
	  
	  
	  //调试数码管 数码管位计数按键2有关
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt0 <= 0;   
	    end  
	    else if(add_cnt0) begin  
	        if(end_cnt0)  
	            cnt0 <= 0;   
	        else  
	            cnt0 <= cnt0+1 ;  
	   end  
	end  
	assign add_cnt0 = key_vld[1];  		
	assign end_cnt0 = add_cnt0  && cnt0 == 6-1 ;  
	  
	  //调试数码管 数码管值加一信号按键3有关
	always  @(posedge clk or negedge rst_n)begin  
	    if(rst_n==1'b0)begin  
	        key3_func<=1'b0;  
	    end  
	    else if(key1_func==1'b1 && key_vld[2]==1'b1)begin       
	        key3_func<=1'b1;  
	    end  
	    else begin  
	        key3_func<=1'b0;  
	    end  
	end  
	  
	//计秒计数器
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt1 <= 0;   
	    end  
	    else if(add_cnt1) begin  
	        if(end_cnt1)  
	            cnt1 <= 0;   
	        else  
	            cnt1 <= cnt1+1 ;  
	   end  
	   else begin  
	       cnt1 <= 0;  
	   end  
	end  
	assign add_cnt1 = key1_func==0;  
	assign end_cnt1 = add_cnt1  && cnt1 == 5000_0000-1 ;   //非调试状态计数正常计数
	  
	  
	  
	//时钟计数器
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt2 <= 0;   
	    end  
	    else if(add_cnt2) begin  
	        if(end_cnt2)  
	            cnt2 <= 0;   
	        else  
	            cnt2 <= cnt2+1 ;  
	   end  
	end  
	assign add_cnt2 = (key1_func && cnt0==0 && key3_func) || (key1_func==0 && end_cnt1);  
	assign end_cnt2 = add_cnt2  && cnt2 == 10-1 ;  
	  
	  
	  
	//时钟计数器
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt3 <= 0;   
	    end  
	    else if(add_cnt3) begin  
	        if(end_cnt3)  
	            cnt3 <= 0;   
	        else  
	            cnt3 <= cnt3+1 ;  
	   end  
	end  
	assign add_cnt3 = (key1_func && cnt0==1 && key3_func) || (key1_func==0 && end_cnt2);  
	assign end_cnt3 = add_cnt3  && cnt3 == 6-1 ;  
	  
	  
	//时钟计数器
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt4 <= 0;   
	    end  
	    else if(add_cnt4) begin  
	        if(end_cnt4)  
	            cnt4 <= 0;   
	        else  
	            cnt4 <= cnt4+1 ;  
	   end  
	end  
	assign add_cnt4 = (key1_func && cnt0==2 && key3_func) || (key1_func==0 && end_cnt3);  
	assign end_cnt4 = add_cnt4  && cnt4 == 10-1 ;  
	  
	//时钟计数器
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt5 <= 0;   
	    end  
	    else if(add_cnt5) begin  
	        if(end_cnt5)  
	            cnt5 <= 0;   
	        else  
	            cnt5 <= cnt5+1 ;  
	   end  
	end  
	assign add_cnt5 = (key1_func && cnt0==3 && key3_func) || (key1_func==0 && end_cnt4);  
	assign end_cnt5 = add_cnt5  && cnt5 == 6-1 ;  
	  
	//时钟计数器
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt6 <= 0;   
	    end  
	    else if(add_cnt6) begin  
	        if(end_cnt6)  
	            cnt6 <= 0;   
	        else  
	            cnt6 <= cnt6+1 ;  
	   end  
	end  
	assign add_cnt6 = (key1_func && cnt0==4 && key3_func) || (key1_func==0 && end_cnt5);  
	assign end_cnt6 = add_cnt6  && cnt6 == x-1 ;  
	  
	  
	//时钟计数器
	always @(posedge clk or negedge rst_n) begin   
	    if (rst_n==0) begin  
	        cnt7 <= 0;   
	    end  
	    else if(add_cnt7) begin  
	        if(end_cnt7)  
	            cnt7 <= 0;   
	        else  
	            cnt7 <= cnt7+1 ;  
	   end  
	end  
	assign add_cnt7 = (key1_func && cnt0==5 && key3_func) || (key1_func==0 && end_cnt6);  
	assign end_cnt7 = add_cnt7  && cnt7 == y-1 ;  
	  
	  
	always  @(*)begin  
	    if(cnt7==2)begin  
	        x = 4;  
	    end  
	    else begin  
	        x =10;  
	    end  
	end  
	  
	always  @(*)begin  
	    if(cnt6>=4)begin  
	        y = 2;  
	    end  
	    else begin  
	        y = 3;  
	    end  
	end  
	  
	  
	endmodule  


