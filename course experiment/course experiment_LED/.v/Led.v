//实验一闪烁灯
module Led(
    clk     ,
    rst_n   ,
    led       
);

input      clk  ;
input      rst_n;
output     led  ;

reg  [28:0]   cnt0     ; //最大为50*T的位宽
wire          add_cnt0 ;//计数器1计数条件
wire          end_cnt0 ;//计数器1溢出条件
reg  [ 3:0]   cnt1     ;//计数器2计数0~8的位宽
wire          add_cnt1 ;//计数器2计数条件
wire          end_cnt1 ;//计数器2溢出条件
reg           led      ;//输出LED灯
reg  [31:0]   x        ;//受计数器2控制的计数器1溢出值
parameter T=10_000_000;  //参数化值方便仿真以及代码的移植\修改
//计数器1对时钟计数
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

assign add_cnt0 = 1;     //对时钟计数，计数条件始终有效
assign end_cnt0 = add_cnt0 && cnt0==x-1 ;//计数到一个闪烁时间周期 
//计数器2对计数器1溢出计数
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

assign add_cnt1 = end_cnt0; //对计数器1溢出计数，计数条件为计数器1溢出清零时
assign end_cnt1 = add_cnt1 && cnt1==9-1 ;//计数9个闪烁时间周期 为一个循环


always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        led <= 1;  
    end
    else if(add_cnt0 && cnt0==5*T-1)begin	//对计数器1计数值判断，够一秒时亮灯
        led <= 0;
    end
    else if(end_cnt0)begin	//一个闪烁时间周期结束时灭灯
        led <= 1;
    end
end
//判断闪烁次数来设置计数器1计数值
always  @(*)begin   
    if(cnt1==0)
        x = 10*T;
    else if(cnt1==1)
        x = 15*T;
    else if(cnt1==2)
        x = 20*T;
    else if(cnt1==3)
        x = 25*T;
    else if(cnt1==5)
        x = 30*T;
    else if(cnt1==6)
        x = 35*T;
    else if(cnt1==7)
        x = 40*T;
    else if(cnt1==8)
        x = 45*T;
    else 
        x = 50*T;
end

endmodule
