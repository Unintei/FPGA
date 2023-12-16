`timescale  1ns/1ns

module  hld
#(
//****************************************************//
//定义晶振频率50M
    parameter CNT_MAX = 26'd50_000_000 ,
//定义最小时间单位 0.1ms
	parameter CNT_MIN = CNT_MAX / 1000_0,
//定义1s
	parameter T_s = 14'd10_000 ,
	
	parameter T_ms = 12'd1_000 ,
//定义PWM占空比周期  10ms
	parameter led_R = 4'd10 ,
	parameter led_G = 4'd7 ,
	parameter led_Y = 4'd3 
//****************************************************//
)
(
    input   wire            sys_clk     ,   //输入工作时钟,频率50MHz
    input   wire            sys_rst_n   ,   //输入复位信号,低电平有效

    output  wire    		   	sag			,
    output  reg    [6:0]   	led    		,    
	output  reg    [2:0]    led_out          //输出led

);



//reg   define
reg     [13:0]  cnt         ;    //0.1ms
reg     [13:0]  cnt_s         ;
reg     [13:0]  cnt_ms         ;
reg		[2:0] 	flota_out	 ;
reg    [3:0]   	stear_s     ;
//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//cnt:计数器计数0.1ms
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt <= #1 14'b0;
    else    if(cnt == CNT_MIN - 1)
        cnt <= #1 14'b0;
    else
        cnt <= #1 cnt + 1'b1;
		
//cnt_s:计数器计1s
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_s <= #1 15'b0;
    else    if(cnt == CNT_MIN - 1 && cnt_s == T_s - 1 )
        cnt_s <= #1 15'b0;
    else	if(cnt == CNT_MIN - 1 )
        cnt_s <= #1 cnt_s + 1;
		
		
////cnt_s:计数器计10ms 做数码管扫描用
//always@(posedge sys_clk or negedge sys_rst_n)
//    if(sys_rst_n == 1'b0)
//        cnt_ms <= #1 15'b0;
//    else    if(cnt == CNT_MIN - 1 && cnt_ms == T_ms - 1 )
//        cnt_ms <= #1 15'b0;
//    else	if(cnt == CNT_MIN - 1 )
//        cnt_ms <= #1 cnt_ms + 1;
		
//循环亮灯
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        flota_out <= #1  3'b110;
    else    if(cnt == CNT_MIN - 1 -1 && cnt_s == T_s - 1  && stear_s == 0)
        flota_out <= #1 {flota_out[1:0],flota_out[2]} ;

		
//亮灯对应时间的
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
		stear_s <= #1 led_R;
    else    if(cnt == CNT_MIN - 1 && cnt_s == T_s - 1 && stear_s== 0)	begin
	case(flota_out)
		3'b110:stear_s<=led_R;
		3'b101:stear_s<=led_G;
		3'b011:stear_s<=led_Y;
	endcase
	end
	else	if(cnt == CNT_MIN - 1 && cnt_s == T_s - 1	&& stear_s != 0 )
        stear_s <= #1 stear_s - 1'b1;

//输出信号打一拍
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        led_out <= #1 3'b111;
    else    
		led_out <= flota_out;


//亮灯对应编码
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
       led<=7'b111_1111;
	else if( cnt == CNT_MIN - 1 && cnt_s == T_s - 1  )	begin
	case(stear_s)
		8'd9:led<=7'b000_0001;
		8'd8:led<=7'b100_1111;
		8'd7:led<=7'b001_0010;
		8'd6:led<=7'b000_0110;
		8'd5:led<=7'b100_1100;
		8'd4:led<=7'b010_0100;
		8'd3:led<=7'b010_0000;
		8'd2:led<=7'b000_1111;
		8'd1:led<=7'b010_0000;
		8'd0:led<=7'b000_0100;
	endcase
	end

assign 	sag=0;



endmodule







