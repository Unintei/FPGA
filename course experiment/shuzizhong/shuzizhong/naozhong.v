module naozhong(
input 	wire            clk    ,  
input 	wire            rst_n  ,
input 	wire  [23:0]	 temp   ,
input 	wire  [ 3:0]     cnt2     ,  
input 	wire  [ 3:0]     cnt3     ,  
input 	wire  [ 3:0]     cnt4     ,  
input 	wire  [ 3:0]     cnt5     ,
output    reg            led      ,
output    reg            buzzer
);
reg     [30:0]          cnts       ;  

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
    led <= 1 ;
    buzzer<=1;
    end
    else if((cnt2==0&&cnt3==0&&cnt4==0&&cnt5==0)||(temp>=300000)) begin //分钟计数和秒计时都为零时蜂鸣
    led <=0;
    buzzer<=0; 
	 end
	else if(cnts==0)begin 
	led <= 1 ;
    buzzer<=1;
    end
end

always @(posedge clk or negedge rst_n) begin   
    if (rst_n==0) begin  
        cnts <= 0;   
    end  
    else if(add_cnts) begin  
        if(end_cnts)  
            cnts <= 0;   
        else  
            cnts <= cnts+1 ;  
   end  
   else begin  
       cnts <= 0;  
   end  
end  
assign add_cnts = led==0;  
assign end_cnts = add_cnts  && cnts == 15000_0000-1 ;  //蜂鸣三秒

endmodule
