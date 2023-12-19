module ztj(
    input clk,
    input rst_n,
    input  wire [2:0]  sel,     //初始状态选择
	
    output reg [2:0] state_c,   //3个led 
    output reg [4:0] cnt1,      //当前计数值
	output reg [4:0] x          //最大值
);

//参数定义
parameter		CNT_MAX = 26'd5,
        		CNT_R = 26'd15,
        		CNT_Y = 26'd5 ,
        		CNT_G = 26'd10,
        		EWG_SNR=3'b110,
        		EWY_SNR=3'b101,
        		EWR_SNG=3'b011;
	
//中间信号定义
reg [25:0] cnt0;//1s计数器
reg[3:0] state_n;      //状态机次态 下一个状态

//计数器设计
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1;
    end
end

assign add_cnt0 =1 ;
assign end_cnt0 = add_cnt0 && cnt0==1*CNT_MAX-1 ;

//可变计数上限值计数器
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign add_cnt1 = end_cnt0;
assign end_cnt1 = add_cnt1 && cnt1==x-1 ;

////四段式状态机
//第一段：同步时序always模块，格式化描述次态寄存器迁移到现态寄存器(不需更改）
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state_c <= sel;
    end
    else begin
        state_c <= state_n;
    end
end

//第二段：组合逻辑always模块，描述状态转移条件判断
always@(*)begin
    case(state_c)
        EWG_SNR:begin//1
            if(ewg_snr2ewy_snr_start)begin
                state_n = EWY_SNR;//东西黄 南北红
            end
            else begin
                state_n = state_c;
            end
        end
        EWY_SNR:begin//2
            if(ewy_snr2ewr_sng_start)begin
                state_n = EWR_SNG;//东西红 南北绿
            end
            else begin
                state_n = state_c;
            end
        end
        EWR_SNG:begin//3
            if(ewr_sng2ewr_sny_start)begin
                state_n = EWG_SNR;//东西红 南北黄
            end
            else begin
                state_n = state_c;
            end
        end
        default:begin
            state_n = state_c;
        end
    endcase
end

//第三段：转移条件
assign idle2ewg_snr_start    = (state_c==sel &&1) ;
assign ewg_snr2ewy_snr_start = (state_c==EWG_SNR&&cnt1==x-1&&end_cnt0);
assign ewy_snr2ewr_sng_start = (state_c==EWY_SNR&&cnt1==x-1&&end_cnt0);
assign ewr_sng2ewr_sny_start = (state_c==EWR_SNG&&cnt1==x-1&&end_cnt0);

//第四段：同步时序always模块，格式化描述寄存器输出（可有多个输出）
always  @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        x<=CNT_R;      //东西红绿黄灯 南北红绿黄灯
    end
    else begin
        case(state_c)
            EWG_SNR:x<=CNT_G;//东西绿  
            EWY_SNR:x<=CNT_Y;//东西黄 
            EWR_SNG:x<=CNT_R;//东西红 
        endcase
    end
end

endmodule
