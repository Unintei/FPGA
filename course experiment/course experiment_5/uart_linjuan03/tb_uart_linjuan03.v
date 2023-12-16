`timescale 1 ns/1 ns

module tb_uart_linjuan03();

//ʱ�Ӻ͸�λ
reg clk  ;
reg rst_n;

//uut�������ź�
reg  rx_uart;

//uut�������ź�
wire [7:0] led;


//ʱ�����ڣ���λΪns�����ڴ��޸�ʱ�����ڡ�
parameter CYCLE    = 20;

//��λʱ�䣬��ʱ��ʾ��λ3��ʱ�����ڵ�ʱ�䡣
parameter RST_TIME = 3 ;

//�����Ե�ģ������
uart_linjuan03  #(.T(4)) uart_linjuan03_inst
(
    .clk                 (clk     ), 
    .rst_n               (rst_n   ),
    .rx_uart             (rx_uart ),
    .led                 (led     )
);


//���ɱ���ʱ��50M
initial begin
    clk = 0;
    forever
    #(CYCLE/2)
    clk=~clk;
end

//������λ�ź�
initial begin
    rst_n = 1;
    #2;
    rst_n = 0;
    #(CYCLE*RST_TIME);
    rst_n = 1;
end

//�����ź�rx_uart��ֵ��ʽ
initial begin
    #1;//����λ
    rx_uart=1;
    #(4*CYCLE);
    rx_uart=0;
    #(4*CYCLE);//��ʼλ
    rx_uart=1;
    #(4*CYCLE);//data1
    rx_uart=0;
    #(3*4*CYCLE);//data2,3,4
    rx_uart=1;
    #(2*4*CYCLE);//data5,6
    rx_uart=0;
    #(2*4*CYCLE);//data7,8
    rx_uart=1;
    #(4*CYCLE);//ֹͣλ
    rx_uart=1;
end
endmodule

