
module  PWM_Led
#(
//****************************************************//
//定义晶振频率50M
   parameter CNT_MAX = 26'd50_000_000 ,
//定义最小时间单位 0.1ms
	parameter CNT_MIN = CNT_MAX / 1000_0,
////定义PWM状态周期  10ms
//	parameter PWM_state = CNT_MIN * 10
//定义PWM状态周期    2s
	parameter led_state =4'd 5,
//定义PWM状态周期    2s
//	parameter T_s = 15'd20000 ,
	parameter T_s = 15'd20000 ,
//定义PWM占空比周期  10ms
	parameter T_ms = 7'd100 
//****************************************************//
)
(
    input   wire            sys_clk     ,   //输入工作时钟,频率50MHz
    input   wire            sys_rst_n   ,   //输入复位信号,低电平有效

    output  wire            led_out      ,    //输出行同步信号
	output  wire            led1

);

//reg   define
reg     [13:0]  cnt         ;    //0.1ms
reg     [14:0]  cnt_ms         ;
reg     [6:0]  cnt_flag_Tms    ;
wire            led       ;   //输出行同步信号
//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//cnt:计数器计数0.1ms
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt <= 14'b0;
    else    if(cnt == CNT_MIN)
        cnt <= 14'b0;
    else
        cnt <= cnt + 1'b1;
		
//cnt_flag_Ts:计数器计数满10ms标志信号
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_flag_Tms <= 7'b0;
    else    if(cnt == CNT_MIN - 1 && cnt_flag_Tms == T_ms - 1)
        cnt_flag_Tms <= 7'b0;
    else	if(cnt == CNT_MIN - 1 )
        cnt_flag_Tms <= cnt_flag_Tms + 1;
		
//cnt_ms:计数器计数2000ms
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_ms <= 15'b0;
    else    if(cnt == CNT_MIN - 1 && cnt_flag_Tms == T_ms - 1  && cnt_ms == 2*T_ms - 1)
        cnt_ms <= 15'b0;
    else	if(cnt == CNT_MIN - 1 && cnt_flag_Tms == T_ms - 1 )
        cnt_ms <= cnt_ms + 1'b1;

assign	led1=(cnt_ms +1)>> 1;

assign  led =(  ( (cnt_ms +1)>> 1 ) <cnt_flag_Tms) ?1'b0:1'b1;

assign  led_out =(cnt_ms > T_ms)? led : ~led  ;

endmodule







