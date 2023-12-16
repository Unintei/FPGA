module uart(
    clk    ,
    rst_n  ,
    rx_uart,
    led   
    );

    //波特率对应时钟周期数
    parameter    T =5208;
   

    //输入端口
    input               clk    ;
    input               rst_n  ;
    input               rx_uart;//串口接收端口

    //输出端口          
    output   [7:0]      led;
    
    reg     [7:0]       led;
    
    reg    [12:0]       cnt0   ;//计数波特率对应时钟
    wire                add_cnt0;
    wire                end_cnt0;
    reg    [3:0]        cnt1;//计数bit位
    wire                add_cnt1;
    wire                end_cnt1;
    reg                 flag_add;//always���ƣ�����Ϊreg�ͣ�������ֵ��0��1
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
    assign end_cnt0 = add_cnt0 && cnt0==T-1 ;//计数波特率对应时钟

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
    assign end_cnt1 = add_cnt1 && cnt1==9-1 ;//bit计数一帧数据

   
//rx_uart，边缘检测检测下降沿到来       
//多打两拍使用寄存器传输延时来消除亚稳态     
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rx_uart_ff0<=0;
            rx_uart_ff1<=0;
            rx_uart_ff2<=0;
        end
        else begin
            rx_uart_ff0<=rx_uart;
            rx_uart_ff1<=rx_uart_ff0;
            rx_uart_ff2<=rx_uart_ff1;// rx_uart_ff1�ǵ�ǰ̬��rx_uart_ff2��ǰһ̬��
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            flag_add<=0;
        end
        else if(rx_uart_ff1==0&&rx_uart_ff2==1)begin//�����½���
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
        else if(add_cnt0&&cnt0==T/2-1&&cnt1>=1&&cnt1<9)begin
            led[cnt1-1]<=rx_uart_ff1;
        end
      end

    endmodule

