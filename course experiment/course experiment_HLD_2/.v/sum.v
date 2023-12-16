/*****************************************************

*****************************************************/
module  sum
#(
//****************************************************//

//定义晶振频率50M
    parameter CNT_MAX = 26'd50_000_000 
//****************************************************//
)
(
    input   wire            sys_clk     ,   //输入工作时钟,频率50MHz
    input   wire            sys_rst_n   ,   //输入复位信号,低电平有效
	
	input	wire   [5:0] 	cnt1		,
	input	wire    [5:0] 	x1			,
	
	input	wire   [5:0] 	cnt2		,
	input	wire    [5:0] 	x2			,
	
	output	reg    [3:0] 	seg_sel		,
	output  reg    [6:0]    seg_ment
);

//中间信号定义
reg[3:0]        sel_data;//数码管显示 最大值9
//数码管扫描时间
reg[25:0]       t2ms;//2ms 最大值10_000




//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//

/********************************************
***************位移扫描**********************
********************************************/
//计2ms 每位数码管扫描时间
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        t2ms <= 0;
    end
    else if(add_t2ms)begin
        if(end_t2ms)
            t2ms <= 0;
        else
            t2ms <= t2ms + 1;
    end
end

assign add_t2ms =1 ;
assign end_t2ms = add_t2ms && t2ms== (CNT_MAX/200) -1 ;

//每2ms 扫描下一个
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)
       seg_sel<=4'b1110;
	else if( end_t2ms  )	begin
	seg_sel <= {seg_sel[0],seg_sel[3:1]};   end
	else	seg_sel <= seg_sel;  

/********************************************
*********************************************
********************************************/


//各个数码管对应的数字
always  @(posedge sys_clk or negedge sys_rst_n)begin
    if(sys_rst_n==1'b0)begin
         sel_data<=4'b1110;//????
    end
    else begin 
		case(seg_sel)
			4'b1110:sel_data<=(x1-cnt1>=4'd10)?x1-cnt1-10:x1-cnt1;//0
			4'b1101:sel_data<=(x1-cnt1>=4'd10)?1:0;//1
			4'b1011:sel_data<=(x2-cnt2>=4'd10)?x2-cnt2-10:x2-cnt2;//0
			4'b0111:sel_data<=(x2-cnt2>=4'd10)?1:0;//1
		endcase
	end  
end 

//数字的BCD译码
always  @(posedge sys_clk or negedge sys_rst_n)begin
    if(sys_rst_n==1'b0)begin
         seg_ment<=7'h7f;//????
    end
    else begin
         case(sel_data)
            0:seg_ment<=7'h01;//0
            1:seg_ment<=7'h4f;//1
            2:seg_ment<=7'h12;//2
            3:seg_ment<=7'h06;//3
            4:seg_ment<=7'h4c;//4
            5:seg_ment<=7'h24;//5
            6:seg_ment<=7'h20;//6
            7:seg_ment<=7'h0f;//7
            8:seg_ment<=7'h00;//8
            9:seg_ment<=7'h04;//9
            default:seg_ment<=7'h7f;//????
         endcase
    end  
end 

endmodule
