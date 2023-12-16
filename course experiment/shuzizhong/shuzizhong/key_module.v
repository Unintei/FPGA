module key_module(  
	input   wire   	            	clk     ,  
	input   wire	            	rst_n   ,  
	input   wire	[KEY_W-1 :0]	key_in  ,  
	output  reg 	[KEY_W-1 :0]	key_vld   
	);  
parameter                           DATA_W    = 20          ;  
parameter                           KEY_W     = 3           ;  
parameter                           TIME_20MS = 1_000_000   ;  

reg             [DATA_W-1:0]        cnt                     ;   
reg                                 flag_add                ;  
reg             [KEY_W-1 :0]        key_in_ff1              ;  
reg             [KEY_W-1 :0]        key_in_ff0              ;  
  
  
always  @(posedge clk or negedge rst_n)begin  
    if(rst_n==1'b0)begin  
        cnt <= 20'b0;  
    end  
    else if(add_cnt)begin  
        if(end_cnt)  
            cnt <= 20'b0;  
        else  
            cnt <= cnt + 1'b1;  
    end  
    else begin  
        cnt <= 0;  
    end  
end  
  
assign add_cnt = flag_add==1'b0 && (&key_in_ff1==0);  //计数时间触发条件
assign end_cnt = add_cnt && cnt == TIME_20MS - 1;  //稳定时间到
  
  
always  @(posedge clk or negedge rst_n)begin  
    if(rst_n==1'b0)begin  
        flag_add <= 1'b0;  
    end  
    else if(end_cnt)begin  
        flag_add <= 1'b1;  //连续读取按键失能
    end  
    else if(&key_in_ff1==1)begin  
        flag_add <= 1'b0;  //未触发按键时使能
    end  
end  
  
  
always  @(posedge clk or negedge rst_n)begin  
    if(rst_n==1'b0)begin  
        key_in_ff0 <= {{KEY_W}{1'b1}};  
        key_in_ff1 <= {{KEY_W}{1'b1}};  //复位寄存填充
    end  
    else begin  
        key_in_ff0 <= key_in    ;  
        key_in_ff1 <= key_in_ff0;  //对按键扫描信号打两拍
    end  
end  
  
  
always  @(posedge clk or negedge rst_n)begin  
    if(rst_n==1'b0)begin  
        key_vld <= 0;  
    end  
    else if(end_cnt)begin  
        key_vld <= ~key_in_ff1;   //取出按键键值
    end  
    else begin  
        key_vld <= 0;  //舍弃键值
    end  
end  
  
  
endmodule  

