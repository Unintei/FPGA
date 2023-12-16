/*****************************************************

*****************************************************/
module  led
#(
//****************************************************//

//定义晶振频率50M
    parameter CNT_MAX = 26'd50_000_000 ,
//定义晶振频率50M
    parameter CNT_R = 26'd15  ,
//定义晶振频率50M
    parameter CNT_Y = 26'd5,
//定义晶振频率50M
    parameter CNT_G = 26'd10 
//****************************************************//
)
(
    input   wire            sys_clk     ,   //输入工作时钟,频率50MHz
    input   wire            sys_rst_n   ,   //输入复位信号,低电平有效
    input   wire   [2:0]    sel		    ,

	output	reg    [5:0] 	cnt2		,
	output	reg    [5:0] 	x			,
	output  reg    [2:0]    led_sel
);


reg     [25:0]  cnt1         ;    //0.1ms



//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//计2ms 每位数码管扫描时间

always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign add_cnt1 =1 ;
assign end_cnt1 = add_cnt1 && cnt1==CNT_MAX-1 ;

always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cnt2 <= 0;
    end
    else if(add_cnt2)begin
        if(end_cnt2)
            cnt2 <= 0;
        else
            cnt2 <= cnt2 + 1;
    end
end

assign add_cnt2 =end_cnt1 ;
assign end_cnt2 = add_cnt2 && cnt2== x - 1 ;

//每x 扫描下一个
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)
		led_sel<=sel;
	else if( end_cnt2  )	begin
		led_sel <= {led_sel[0],led_sel[2:1]};   end
	else	
		led_sel <= led_sel;  

//每x 扫描下一个
always  @(posedge sys_clk or negedge sys_rst_n)begin
    if(sys_rst_n==1'b0)begin
			x<=CNT_R;end
    else 
		begin case(led_sel)
            3'b110:x<=CNT_G;
            3'b101:x<=CNT_Y;
            3'b011:x<=CNT_R;
         endcase	end

end 

endmodule
