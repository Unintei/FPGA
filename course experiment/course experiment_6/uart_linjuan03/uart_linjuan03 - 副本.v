module uart_linjuan03(
    clk    ,
    rst_n  ,
    rx_uart,
    led   
    );

    //参数定义
    parameter      T =5208;

    //输入信号定义
    input               clk    ;
    input               rst_n  ;
    input               rx_uart;//异步串口输入信号

    //输出信号定义           
    output   [7:0]      led;
    //输出信号reg定义
    reg     [7:0]       led;
    //中间信号定义
    reg    [12:0]       cnt0   ;//cnt0最大值是5208-1，需要13位
    wire                add_cnt0;
    wire                end_cnt0;
    reg    [3:0]        cnt1;//cnt1最大值是9-1，需要4位
    wire                add_cnt1;
    wire                end_cnt1;
    reg                 flag_add;//always设计，因此为reg型，并且其值是0或1
    reg                 rx_uart_ff0;
    reg                 rx_uart_ff1;
    reg                 rx_uart_ff2;
   
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

    assign add_cnt0 =flag_add==1 ;
    assign end_cnt0 = add_cnt0 && cnt0==T-1 ;//cnt0计数到5208个时钟周期，由于波特率是9600，1s/9600=104166ns,104166/20=5208

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
    assign end_cnt1 = add_cnt1 && cnt1==9-1 ;//起始位+8位数据

   
//rx_uart设计,rx_uart是异步信号，打三拍寄存，前两拍消除消除亚稳态，使信号同步化，第三拍做边沿检测。             
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rx_uart_ff0<=0;
            rx_uart_ff1<=0;
            rx_uart_ff2<=0;
        end
        else begin
            rx_uart_ff0<=rx_uart;
            rx_uart_ff1<=rx_uart_ff0;
            rx_uart_ff2<=rx_uart_ff1;// rx_uart_ff1是当前态，rx_uart_ff2是前一态。
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            flag_add<=0;
        end
        else if(rx_uart_ff1==0&&rx_uart_ff2==1)begin//检测下降沿
            flag_add<=1;
        end
        else if(end_cnt1)begin
             flag_add<=0;
        end
    end
 
     always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
           led<=8'hff;
        end
        else if(add_cnt0&&cnt0==T/2-1&&cnt1>=1&&cnt1<9)begin//选一个时刻将值赋给data，如果在end_cnt0取值，就有可能采错，最保险的是在中间取值，这样即使有很多的偏差，都不会影响采样的正确性。
            led[cnt1-1]<=rx_uart_ff1;//第2比特（LSB）的值赋给led[0],第9比特(MSB)赋给led[7]。
        end
      end
    



    endmodule

