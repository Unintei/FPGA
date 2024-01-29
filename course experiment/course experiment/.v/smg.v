module smg(
    input clk,
    input rst_n,
	input wire [7:0] uart_data,//输入 8bit串口数据
    output reg [7:0] seg_sel,//8位数码管
    output reg [6:0] seg_ment//7段段码
);
//参数定义
parameter T2MS=100_000;//2ms 每位数码管扫描时间
//中间信号定义
reg[20:0]       t2ms;//2ms 最大值10_000
wire            add_t2ms;
wire            end_t2ms;
reg[4:0]        sel_data;//位选数据 最大值16
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
assign end_t2ms = add_t2ms && t2ms==1*T2MS-1 ;
//切换位选 每2ms切换一位数码管
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        seg_sel<=8'b11_1111_10;//smg[0]
    end
    else if(end_t2ms) begin
        seg_sel<={seg_sel[6:0],seg_sel[7]};//左移
    end
    else begin
        seg_sel<=seg_sel;
    end
end
//切换数码管显示
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        sel_data<=0;
    end
    else begin
        case(seg_sel)
            8'b11_1111_10:sel_data<=uart_data[3:0];//低四位
            8'b11_1111_01:sel_data<=uart_data[7:4];//高四位
            default:sel_data<=16;//其他没有用到的数码管不点亮
        endcase
    end
end
//译码器
always  @(posedge clk or negedge rst_n)begin//对外输出信号用时序逻辑，避免组合逻辑竞争冒险产生的毛刺现象
    if(rst_n==1'b0)begin
         seg_ment<=7'h7f;//不亮
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
				10:seg_ment<=7'h08;//A
				11:seg_ment<=7'h60;//B
				12:seg_ment<=7'h31;//C
				13:seg_ment<=7'h42;//D
				14:seg_ment<=7'h30;//E
				15:seg_ment<=7'h38;//F
            16:seg_ment<=7'h7f;//不亮
            default:seg_ment<=7'h7f;//不亮
         endcase
    end  
end 
endmodule
