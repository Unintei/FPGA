module uart_rx(
    input clk    ,
    input rst_n  ,
    input  wire rx_uart,//PC向串口发送的输入信号
    output reg [7:0] uart_data //数据输出信号显示
    );

    //参数定义
    parameter      BPS =5208;//1bit 数据传送所需时间
  
    //中间信号定义
    reg   [12:0]     cnt0;//计数1bit数据传送所需时间
    reg   [3:0]      cnt1;//计数发送数据的位数
    reg       rx_uart_ff0;//异步信号同步化、边沿检测打拍信号
    reg       rx_uart_ff1;
    reg       rx_uart_ff2;//用于检测下降沿
    reg       rx_flag    ;//串口接收工作状态指示信号
    wire      add_cnt0;
    wire      end_cnt0;
    wire      add_cnt1;
    wire      end_cnt1;
    reg [7:0] uart_data_buff; //串口接收寄存器
//rx_uart异步信号同步化（打两拍） 边沿检测（一拍）同步信号一拍就好
always  @(posedge clk or negedge rst_n)begin
   if(rst_n==1'b0)begin
       rx_uart_ff0<=0;
       rx_uart_ff1<=0;
       rx_uart_ff2<=0;
   end
   else begin
       rx_uart_ff0<=rx_uart;//打两拍先将异步信号同步化
       rx_uart_ff1<=rx_uart_ff0;
       rx_uart_ff2<=rx_uart_ff1;//再打一拍边沿检测 //rx_uart_ff1是当前变化态（现态），rx_uart_ff2是次态 D触发器
   end
end
//    assign neg_edge==rx_uart_ff1==0&&rx_uart_ff2==1;//下降沿
//    assign pos_edge==rx_uart_ff1==1&&rx_uart_ff2==0;//上升沿
//tx_flag 串口接收数据工作状态指示信号设计 时序
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rx_flag<=0;
    end
    else if(rx_uart_ff1==0&&rx_uart_ff2==1)begin//检测到下降沿时拉高 串口处于工作状态
        rx_flag<=1;
    end
    else if(end_cnt1)begin//数据接收完成 置0  串口回到空闲状态
        rx_flag<=0;
    end
end

 //1bit所需要的时间
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
assign add_cnt0 =rx_flag== 1;
assign end_cnt0 = add_cnt0 && cnt0==BPS-1 ;
//计数bit个数 一帧数据有几位
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
assign add_cnt1 = end_cnt0;//串口接收到1位bit数据就+1
assign end_cnt1 = add_cnt1 && cnt1==9-1 ;//1个起始位+8个数据位
//数据data输出设计
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        uart_data_buff<=0;
    end
    else if(add_cnt0&&cnt0==BPS/2-1&&cnt1>=1&&cnt1<9)begin//取中间时刻传送data减小误差 
        uart_data_buff[cnt1-1]<=rx_uart_ff1;//rx_uart_ff1已是经过打两拍后同步化后的信号
    end    
end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        uart_data<=0;
    end
    else begin if(end_cnt1)//取中间时刻传送data减小误差 
        uart_data<=uart_data_buff;//rx_uart_ff1已是经过打两拍后同步化后的信号
    else  
        uart_data<=uart_data;
    end 
end
endmodule


