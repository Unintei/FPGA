module smg(
    input clk,
    input rst_n,
    input wire [4:0] ew_data,
    input wire [4:0] sn_data,
	input wire [4:0] x1,
    input wire [4:0] x2,

    output reg [3:0] seg_sel,
    output reg [6:0] seg_ment
);
//晶振50M 定义2s
parameter T2MS=100_000;//2ms
//中间变量定义
reg     [17:0]    cnt;
reg     [4:0]     sel_data;//数码管选择信号

//数码管扫描计数器2ms定时
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else if(add_cnt)begin
        if(end_cnt)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
end

assign add_cnt =1 ;
assign end_cnt = add_cnt && cnt==1*T2MS-1 ;

//数码管位选
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        seg_sel<=4'b1110;//初始位选
    end
    else if(end_cnt)begin//2ms定时到位移
        seg_sel<={seg_sel[2:0],seg_sel[3]};//位选位移
    end     
end

//数码管数据分配
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        sel_data<=0;
    end
    else begin
        case(seg_sel)
            4'b1110:sel_data<=(x1-ew_data>=4'd10)?x1-ew_data-10:x1-ew_data;//数码管个位
            4'b1101:sel_data<=(x1-ew_data>=4'd10)?1:0;//数码管十位
            4'b1011:sel_data<=(x2-sn_data>=4'd10)?x2-sn_data-10:x2-sn_data;//数码管个位
            4'b0111:sel_data<=(x2-sn_data>=4'd10)?1:0;//数码管十位
            default:sel_data<=0;
        endcase
    end
end

//译码器
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
         seg_ment<=7'h7f;//初始全灭
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
            default:seg_ment<=7'h7f;//全灭
         endcase
    end  
end 

endmodule
