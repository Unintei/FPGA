module shizhong2
#(
parameter      T1S =50_000//0.001s
)
(
input    clk    ,
input    rst_n  ,

output reg [3:0] m_g ,	//小时个位数字
output reg [2:0] m_s ,  //小时十位数字
output reg [3:0] f_g ,  //分钟个位数字
output reg [2:0] f_s ,  //分钟十位数字
output reg [3:0] s_g ,  //秒个位数字
output reg [1:0] s_s    //秒十位数字
	   
);

//中间信号定义
reg[3:0]        x; //可变载入值

//数码管扫描时间
reg[25:0]       t1_s; //扫描时间

// 计1s   0.001s
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        t1_s <= 0;
    end
    else if(add_t1_s)begin
        if(end_t1_s)
            t1_s <= 0;
        else
            t1_s <= t1_s + 1;
    end
end

assign add_t1_s =1 ;       
assign end_t1_s = add_t1_s && t1_s==T1S-1 ;   
//����λ 0-9
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        m_g <= 0;
    end
    else if(add_m_g)begin
        if(end_m_g)
            m_g <= 0;
        else
            m_g <= m_g + 1;
    end
end

assign add_m_g =end_t1_s ;       
assign end_m_g = add_m_g && m_g==10-1 ;   
//��ʮλ 0-5
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        m_s <= 0;
    end
    else if(add_m_s)begin
        if(end_m_s)
            m_s <= 0;
        else
            m_s <= m_s + 1;
    end
end

assign add_m_s = end_m_g ;       
assign end_m_s = add_m_s && m_s==6-1 ;   
//�ָ�λ 0-9
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        f_g <= 0;
    end
    else if(add_f_g)begin
        if(end_f_g)
            f_g <= 0;
        else
            f_g <= f_g + 1;
    end
end

assign add_f_g = end_m_s ;       
assign end_f_g = add_f_g && f_g==10-1 ;   
//��ʮλ 0-5
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        f_s <= 0;
    end
    else if(add_f_s)begin
        if(end_f_s)
            f_s <= 0;
        else
            f_s <= f_s + 1;
    end
end

assign add_f_s =end_f_g ;       
assign end_f_s = add_f_s && f_s==6-1 ;   
//ʱ��λ 0-9 0-3
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        s_g <= 0;
    end
    else if(add_s_g)begin
        if(end_s_g)
            s_g <= 0;
        else
            s_g <= s_g + 1;
    end
end

assign add_s_g =end_f_s ;       
assign end_s_g = add_s_g && s_g==x-1 ;   
//ʱʮλ 0-2
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        s_s <= 0;
    end
    else if(add_s_s)begin
        if(end_s_s)
            s_s <= 0;
        else
            s_s <= s_s + 1;
    end
end

assign add_s_s =end_s_g ;       
assign end_s_s = add_s_s && s_s==3-1 ;
//Сʱ��λ
always  @(*)begin
    if(s_s==2)begin
        x=4;
    end
    else begin
        x=10;
    end
end
endmodule

