`timescale 1 ns/1 ns

module anjianfangzhen();

//ʱ�Ӻ͸�λ
reg clk  ;
reg rst_n;

//uut�������ź�
reg[2:0]  key  ;
reg       din1  ;


//uut������ź�
wire [2:0]    dout0;


//ʱ�����ڣ���λΪns�����ڴ��޸�ʱ�����ڡ�
parameter CYCLE    = 20;

//��λʱ�䣬��ʱ��ʾ��λ3��ʱ�����ڵ�ʱ�䡣
parameter RST_TIME = 3 ;

//�����Ե�ģ������
key_module  uut0(
    .clk         (clk      ), 
    .rst_n       (rst_n    ),
    .key         (key      ),
    .key_vld     (key_vld  )
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

//�����ź�din0��ֵ��ʽ
initial begin
    #1;
    //����ֵ
    din0 = 0;
    #(10*CYCLE);
    //��ʼ��ֵ

end




endmodule

