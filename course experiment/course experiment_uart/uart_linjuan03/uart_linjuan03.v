module uart_linjuan03(
    clk    ,
    rst_n  ,
    rx_uart,
    led   
    );

    //��������
    parameter    T =5208;
   

    //�����źŶ���
    input               clk    ;
    input               rst_n  ;
    input               rx_uart;//�첽���������ź�

    //�����źŶ���           
    output   [7:0]      led;
    //�����ź�reg����
    reg     [7:0]       led;
    //�м��źŶ���
    reg    [12:0]       cnt0   ;//cnt0����ֵ��5208-1����Ҫ13λ
    wire                add_cnt0;
    wire                end_cnt0;
    reg    [3:0]        cnt1;//cnt1����ֵ��9-1����Ҫ4λ
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
    assign end_cnt0 = add_cnt0 && cnt0==T-1 ;//cnt0������5208��ʱ�����ڣ����ڲ�������9600��1s/9600=104166ns,104166/20=5208

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
    assign end_cnt1 = add_cnt1 && cnt1==9-1 ;//��ʼλ+8λ����

   
//rx_uart����,rx_uart���첽�źţ������ļĴ棬ǰ���������������̬��ʹ�ź�ͬ�����������������ؼ��⡣             
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
        else if(add_cnt0&&cnt0==T/2-1&&cnt1>=1&&cnt1<9)begin//ѡһ��ʱ�̽�ֵ����data��������end_cnt0ȡֵ�����п��ܲɴ���յ������м�ȡֵ��������ʹ�кܶ���ƫ�������Ӱ����������ȷ�ԡ�
            led[cnt1-1]<=rx_uart_ff1;//��2���أ�LSB����ֵ����led[0],��9����(MSB)����led[7]��
        end
      end
    



    endmodule

