`timescale 1 ns/1 ns

module tb_uart_linjuan03();

//时钟和复位
reg clk  ;
reg rst_n;

//uut的输入信号
reg  rx_uart;

//uut的输出信号
wire [7:0] led;


//时钟周期，单位为ns，可在此修改时钟周期。
parameter CYCLE    = 20;

//复位时间，此时表示复位3个时钟周期的时间。
parameter RST_TIME = 3 ;

//待测试的模块例化
uart_linjuan03 #(.T(2)) uut
(
    .clk          (clk     ), 
    .rst_n        (rst_n   ),
    .rx_uart      (rx_uart ),
    .led          (led     )
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

//输入信号rx_uart赋值方式
initial begin
    #1;//空闲位
    rx_uart=1;
    #(100*CYCLE);
    rx_uart=0;
    #104166;//起始位
    rx_uart=1;
    #104166;//data1
    rx_uart=0;
    #(3*104166);//data2,3,4
    rx_uart=1;
    #(2*104166);//data5,6
    rx_uart=0;
    #(2*104166);//data7,8
    rx_uart=1;
    #104166;//停止位
    rx_uart=1;
end
endmodule

