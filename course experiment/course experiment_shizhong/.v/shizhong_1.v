module shizhong1
#(
parameter      T2_ms=100_000//2ms
)
(
input    clk    ,
input    rst_n  ,

input wire [3:0] m_g ,   //小时个位数字
input wire [2:0] m_s ,   //小时十位数字
input wire [3:0] f_g ,   //分钟个位数字
input wire [2:0] f_s ,   //分钟十位数字
input wire [3:0] s_g ,   //秒个位数字
input wire [1:0] s_s ,   //秒十位数字
	   

output reg [5:0]    seg_sel,//位选
output reg [6:0]   seg_ment//段选
);
//中间信号定义
reg[3:0]        sel_data;//数码管显示 最大值9

//数码管扫描时间
reg[16:0]       t2ms;//2ms 最大值10_000


/********************************************
***************位移扫描**********************
********************************************/
//计2ms 每位数码管扫描时间
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
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
assign end_t2ms = add_t2ms && t2ms==T2_ms-1 ;

//每2ms 扫描下一个
always@(posedge clk or negedge rst_n)
	if(!rst_n)
       seg_sel<=8'b111_1110;
	else if( end_t2ms  )	begin
	seg_sel <= {seg_sel[4:0],seg_sel[5]};   end
	else	seg_sel <= seg_sel;  

/********************************************
*********************************************
********************************************/

//各个数码管对应的数字
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
         sel_data<=m_g;//????
    end
    else begin
         case(seg_sel)
            6'b11_1110:sel_data<=m_g;//0
            6'b11_1101:sel_data<=m_s;//1
            6'b11_1011:sel_data<=f_g;//2
            6'b11_0111:sel_data<=f_s;//3
            6'b10_1111:sel_data<=s_g;//4
            6'b01_1111:sel_data<=s_s;//5
         endcase
    end  
end 

//数字的BCD译码
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
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

