`timescale 1 ns/1 ns

module top_tb();

//时钟和复位
reg clk  ;
reg rst_n;
//uut的输入信号
reg  rx_uart  ;
//uut的输出信号
wire[7:0] seg_sel;
wire[6:0] seg_ment;
//时钟周期，单位为ns，可在此修改时钟周期。
parameter CYCLE    = 20;
//复位时间，此时表示复位3个时钟周期的时间。
parameter RST_TIME = 1 ;

defparam uut.smg_inst.T2MS=2;
defparam uut.uart_rx_inst.BPS=10;

//待测试的模块例化
top uut(
    .clk          (clk     ), 
    .rst_n        (rst_n   ),
    .rx_uart      (rx_uart ),
    .seg_sel	  (seg_sel ),   
	.seg_ment	  (seg_ment)  
);
//生成本地时钟50M
initial begin
    clk = 0;
    forever
    #(CYCLE/2)
    clk=~clk;
end
//产生复位信号
initial begin
    rst_n = 1;
    #2;
    rst_n = 0;
    #(CYCLE*RST_TIME);
    rst_n = 1;
end
//模拟发送8次数据，分别为0~7
initial begin
    #100;
    //开始赋值
    rx_bit(8'd0);//任务的调用，任务名+括号中要传递进任务的参数
    rx_bit(8'd1);
    rx_bit(8'd2);
    rx_bit(8'd3);
    rx_bit(8'd4);
    rx_bit(8'd5);
    rx_bit(8'd6);
    rx_bit(8'd7);
end
//定义一个名为rx_bit的任务，每次发送的数据有10位
task rx_bit(
    input [7:0] data
);
    integer i;//
    for(i=0;i<10;i=i+1)begin//for循环产生一帧数据
        case(i)
            0:rx_uart<=1'b0;//起始位给0拉低
            1:rx_uart<=data[0];//从低位到高位接收数据
            2:rx_uart<=data[1];
            3:rx_uart<=data[2];
            4:rx_uart<=data[3];
            5:rx_uart<=data[4];
            6:rx_uart<=data[5];
            7:rx_uart<=data[6];
            8:rx_uart<=data[7];
            9:rx_uart<=1'b1;//停止位给1拉高
     
        endcase
    #(5208*CYCLE);//每5208个时钟周期发送一位数据
    end
endtask//任务结束
endmodule

