
module  PWM_Led
#(
//****************************************************//
//定义晶振频率50M
    parameter cnt_ms_MAX = 26'd50_000_000 ,
//定义PWM状态周期最小时间单位 10ms
	parameter cnt_ms_MIN =  cnt_ms_MAX / 100,
//定义   2s
	parameter T_s = 15'd200 
// ****************************************************//
)
(
    input   wire            sys_clk     ,   //输入工作时钟,频率50MHz
    input   wire            sys_rst_n   ,   //输入复位信号,低电平有效

    output  wire            led_out          //输出行同步信号
);

reg		[18:0]		cnt_ms	;
reg		[7:0]		cnt_ts	;
reg		[3:0]		flag_led;
reg		[18:0]		x	;
//reg   define



//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//cnt_ms:计数器计数10ms
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_ms <= 19'b0;
    else    if(cnt_ms == cnt_ms_MIN - 1)
        cnt_ms <= 19'b0;
    else
        cnt_ms <= cnt_ms + 1'b1;

//cnt_ts:计数器计数2s产生
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_ts <= 14'b0;
    else    if(cnt_ms == cnt_ms_MIN - 1 && cnt_ts == T_s - 1)
        cnt_ts <= 14'b0;
    else	if(cnt_ms == cnt_ms_MIN - 1)
        cnt_ts <= cnt_ts + 1'b1;

//cnt_ts:计数器计数2s产生
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        flag_led <= 4'b0;
    else    if(cnt_ms == cnt_ms_MIN - 1 && cnt_ts == T_s - 1 && flag_led == 10 - 1)
        flag_led <= 4'b0;
    else	if(cnt_ms == cnt_ms_MIN - 1 && cnt_ts == T_s - 1 )
        flag_led <= flag_led + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
       x<=cnt_ms_MIN;
	else if( cnt_ms == cnt_ms_MIN - 1 && cnt_ts == T_s - 1  )	begin
	case(flag_led)
		4'd0:x<= cnt_ms_MIN * 0.95 ;
		4'd1:x<= cnt_ms_MIN * 0.85 ;
		4'd2:x<= cnt_ms_MIN * 0.70 ;
		4'd3:x<= cnt_ms_MIN * 0.50 ;
		4'd4:x<= cnt_ms_MIN * 0.20 ;
		4'd5:x<= cnt_ms_MIN * 0.20 ;
		4'd6:x<= cnt_ms_MIN * 0.50 ;
		4'd7:x<= cnt_ms_MIN * 0.70 ;
		4'd8:x<= cnt_ms_MIN * 0.85 ;
		4'd9:x<= cnt_ms_MIN * 0.95 ;
	endcase
//	ledcnt<=7'b000_1111;
	end


assign	led_out=(cnt_ms== cnt_ms_MIN - 1)|(cnt_ms<x?0:1);


endmodule







