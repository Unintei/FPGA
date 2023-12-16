`timescale 1 ns/1 ns

module anjianfangzhen();

//时钟和复位
reg clk  ;
reg rst_n;

//uut的输入信号
reg[2:0]  key  ;
reg       din1  ;


//uut的输出信号
wire [2:0]    dout0;


//时钟周期，单位为ns，可在此修改时钟周期。
parameter CYCLE    = 20;

//复位时间，此时表示复位3个时钟周期的时间。
parameter RST_TIME = 3 ;

//待测试的模块例化
key_module  uut0(
    .clk         (clk      ), 
    .rst_n       (rst_n    ),
    .key         (key      ),
    .key_vld     (key_vld  )
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

//输入信号din0赋值方式
initial begin
    #1;
    //赋初值
    din0 = 0;
    #(10*CYCLE);
    //开始赋值

end




endmodule

