`timescale 1 ns/1 ns

module key_module_tb();

//parameter define
//为了缩短仿真时间，我们将参数化的时间值改小
//但位宽依然定义和参数名的值保持一致
//也可以将这些参数值改成和参数名的值一致
parameter   CNT_1MS  = 20'd19   ,
            CNT_11MS = 21'd69   ,
            CNT_41MS = 22'd149  ,
            CNT_51MS = 22'd199  ,
            CNT_60MS = 22'd249  ;

//wire  define
wire    [2:0]        key_vld    ;   //消抖后按键信号

//reg   define
reg             clk             ;   //仿真时钟信号
reg             rst_n           ;   //仿真复位信号
reg     [2:0]    key_in         ;   //模拟按键输入
reg     [21:0]  tb_cnt          ;   //模拟按键抖动计数器

//时钟周期，单位为ns，可在此修改时钟周期。
parameter CYCLE    = 20;

//复位时间，此时表示复位3个时钟周期的时间。
parameter RST_TIME = 3 ;

//待测试的模块例化
key_module  uut0(
    .clk         (clk      ), 
    .rst_n       (rst_n    ),
    .key_in      (key_in   ),
    .key_vld     (key_vld  )
);

initial begin
    clk    =1'b1;
    rst_n <=1'b0;
    key_in<=1'b0;
    #20
    rst_n <=1'b1;
end

//clk模拟时钟，50MHz
always #10 clk =~clk;

//tb_cnt:按键过程计数器，通过该计数器的计数时间来模拟按键的抖动过程
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
        tb_cnt <= 22'b0;
    else    if(tb_cnt == CNT_60MS)
   //计数器计数到CNT_60MS完成一次按键从按下到释放的整个过程
        tb_cnt <= 22'b0;
    else    
        tb_cnt <= tb_cnt + 1'b1;

//key_in:产生输入随机数，模拟按键的输入情况
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
        key_in <= 1'b1;     //按键未按下时的状态为为高电平
    else    if((tb_cnt >= CNT_1MS && tb_cnt <= CNT_11MS)
                || (tb_cnt >= CNT_41MS && tb_cnt <= CNT_51MS))
    //在该计数区间内产生非负随机数0、1来模拟10ms的前抖动和10ms的后抖动
        key_in <= {$random} % 2;    
    else    if(tb_cnt >= CNT_11MS && tb_cnt <= CNT_41MS)
        key_in <= 1'b0;
    //按键经过10ms的前抖动后稳定在低电平，持续时间需大于CNT_MAX
    else
        key_in <= 1'b1;

endmodule

