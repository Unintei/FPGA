module ds18b20_driver(
    input                       clk         ,//时钟信号
    input                       rst_n       ,//复位信号
    input                       dq_in       ,  
    output  reg                 dq_out      ,//dq总线FPGA输出    
    output  reg                 dq_out_en   ,//输出数据有效信号
    output  reg                 temp_sign   ,//温度值符号位 0：正 1：负
    output  reg     [23:0]      temp_out    ,//温度输出
    output  reg                 temp_out_vld //温度输出有效信号       
);

//状态机参数
    localparam  
                //主机状态参数
                M_IDLE = 9'b0_0000_0001 ,//空闲状态
                M_REST = 9'b0_0000_0010 ,//复位
                M_RELE = 9'b0_0000_0100 ,//释放总线 -- ds18b20等待
                M_RACK = 9'b0_0000_1000 ,//接收应答 -- 主机接收存在脉冲
                M_ROMS = 9'b0_0001_0000 ,//ROM命令  -- 跳过ROM命令
                M_CONT = 9'b0_0010_0000 ,//转化
                M_WAIT = 9'b0_0100_0000 ,//等待     -- 12bit分辨率下的温度转化时间
                M_RCMD = 9'b0_1000_0000 ,//读命令   -- 读暂存器命令
                M_RTMP = 9'b1_0000_0000 ,//读温度   -- 产生读时隙 -- 接收2字节带符号位的补码温度

                //从机状态参数
                S_IDLE = 6'b00_0001     ,//空闲状态
                S_LOW  = 6'b00_0010     ,//拉低总线 -- 时隙的开始
                S_SEND = 6'b00_0100     ,//发送     -- 15us内
                S_SAMP = 6'b00_1000     ,//采样     -- 在15us内
                S_RELE = 6'b01_0000     ,//释放     -- 时隙的恢复时间
                S_DONE = 6'b10_0000     ;//

    parameter       
                TIME_1US = 50           ,//1us
                TIME_RST = 500          ,//复位脉冲 500us
                TIME_REL = 20           ,//主机释放总线 20us
                TIME_PRE = 200          ,//主机接收存在脉冲 200us
                TIME_WAIT= 750000       ,//主机发完温度转换命令 等待750ms
                TIME_LOW = 2            ,//主机拉低总线 2us
                TIME_RW  = 60           ,//主机读、写1bit 60us
                TIME_REC = 3            ;//主机读、写完1bit释放总线 3us

    localparam
                CMD_ROMS = 8'hCC        ,//跳过ROM指令
                CMD_CONT = 8'h44        ,//温度转化指令
                CDM_RTMP = 8'hBE        ;//读暂存器指令

//信号定义
    reg     [8:0]       m_state_c   ;//主机现态
    reg     [8:0]       m_state_n   ;//主机次态

    reg     [5:0]       s_state_c   ;//从机现态
    reg     [5:0]       s_state_n   ;//从机次态    

    reg     [5:0]       cnt_1us     ;//1us计数器
    wire                add_cnt_1us ;
    wire                end_cnt_1us ;

    reg     [19:0]      cnt0        ;//复位脉冲、释放、存在脉冲、等待750ms
    wire                add_cnt0    ;
    wire                end_cnt0    ;
    reg     [19:0]      X           ;

    reg     [5:0]       cnt1        ;//计数从机状态机每个状态持续时间
    wire                add_cnt1    ;
    wire                end_cnt1    ;
    reg     [5:0]       Y           ;

    reg     [4:0]       cnt_bit     ;
    wire                add_cnt_bit ;
    wire                end_cnt_bit ;

    reg                 slave_ack   ;//接收存在脉冲
    reg                 flag        ;//0:发送温度转换命令 1:发送温度读取命令
    reg     [7:0]       wr_data     ;
    reg     [15:0]      orign_data  ;//采样温度值寄存器

    reg     [10:0]      temp_data   ;
    wire    [23:0]      temp_data_w ;//组合逻辑计算实际温度值 十进制

    wire                m_idle2m_rest   ;
    wire                m_rest2m_rele   ;
    wire                m_rele2m_rack   ;
    wire                m_rack2m_roms   ;
    wire                m_roms2m_cont   ;
    wire                m_roms2m_rcmd   ;
    wire                m_cont2m_wait   ;
    wire                m_wait2m_rest   ;
    wire                m_rcmd2m_rtmp   ;
    wire                m_rtmp2m_idle   ;

    wire                s_idle2s_low    ;
    wire                s_low2s_send    ;
    wire                s_low2s_samp    ;
    wire                s_send2s_rele   ;
    wire                s_samp2s_rele   ;
    wire                s_rele2s_low    ;
    wire                s_rele2s_done   ;

//主机状态机设计 描述状态转移
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            m_state_c <= M_IDLE;
        end
        else begin
            m_state_c <= m_state_n;
        end
    end

//主机状态转移条件
    always @(*) begin
        case(m_state_c)
            M_IDLE:begin
                if(m_idle2m_rest)
                    m_state_n = M_REST;
                else
                    m_state_n = m_state_c;
            end
            M_REST:begin
                if(m_rest2m_rele)
                    m_state_n = M_RELE;
                else
                    m_state_n = m_state_c;
            end
            M_RELE:begin
                if(m_rele2m_rack)
                    m_state_n = M_RACK;
                else
                    m_state_n = m_state_c;
            end
            M_RACK:begin
                if(m_rack2m_roms)
                    m_state_n = M_ROMS;
                else
                    m_state_n = m_state_c;
            end
            M_ROMS:begin
                if(m_roms2m_cont)
                    m_state_n = M_CONT;
                else if(m_roms2m_rcmd)
                    m_state_n = M_RCMD;
                else
                    m_state_n = m_state_c;
            end
            M_CONT:begin
                if(m_cont2m_wait)
                    m_state_n = M_WAIT;
                else
                    m_state_n = m_state_c;
            end
            M_WAIT:begin
                if(m_wait2m_rest)
                    m_state_n = M_REST;
                else
                    m_state_n = m_state_c;
            end
            M_RCMD:begin
                if(m_rcmd2m_rtmp)
                    m_state_n = M_RTMP;
                else
                    m_state_n = m_state_c;
            end
            M_RTMP:begin
                if(m_rtmp2m_idle)
                    m_state_n = M_IDLE;
                else
                    m_state_n = m_state_c;
            end
            default:m_state_n = M_IDLE;
        endcase
    end

    assign m_idle2m_rest = m_state_c == M_IDLE && (1'b1)    ;//主机IDLE状态直接转换成复位状态 一次采集的开始  重复采集
    assign m_rest2m_rele = m_state_c == M_REST && (end_cnt0);//500us复位脉冲
    assign m_rele2m_rack = m_state_c == M_RELE && (end_cnt0);//20us释放总线
    assign m_rack2m_roms = m_state_c == M_RACK && (end_cnt0 && slave_ack == 1'b0);//200us，主机接收存在脉冲
    assign m_roms2m_cont = m_state_c == M_ROMS && (s_state_c == S_DONE && flag == 1'b0);//主机发送完8bit跳过ROM命令 0：温度转化命令
    assign m_roms2m_rcmd = m_state_c == M_ROMS && (s_state_c == S_DONE && flag == 1'b1);//主机发送完8bit跳过ROM命令 1：读温度命令
    assign m_cont2m_wait = m_state_c == M_CONT && (s_state_c == S_DONE);//主机发送8bit温度转化命令
    assign m_wait2m_rest = m_state_c == M_WAIT && (end_cnt0);//等待750ms转换完成
    assign m_rcmd2m_rtmp = m_state_c == M_RCMD && (s_state_c == S_DONE);//主机发送8bit读命令 --等待从机接收数据完成
    assign m_rtmp2m_idle = m_state_c == M_RTMP && (s_state_c == S_DONE);//主机读温度 --等待从机发送数据完成

//从机状态机设计 描述状态转移
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            s_state_c <= S_IDLE;
        end
        else begin
            s_state_c <= s_state_n;
        end
    end   

//从机状态转移条件
  always @(*) begin
      case(s_state_c)
            S_IDLE:begin
                if(s_idle2s_low)
                    s_state_n = S_LOW;
                else
                    s_state_n = s_state_c;
            end
            S_LOW :begin
                if(s_low2s_send)
                    s_state_n = S_SEND;
                else if(s_low2s_samp)
                    s_state_n = S_SAMP;
                else
                    s_state_n = s_state_c;
            end
            S_SEND:begin
                if(s_send2s_rele)
                    s_state_n = S_RELE;
                else
                    s_state_n = s_state_c;
            end
            S_SAMP:begin
                if(s_samp2s_rele)
                    s_state_n = S_RELE;
                else
                    s_state_n = s_state_c;
            end
            S_RELE:begin
                if(s_rele2s_done)
                    s_state_n = S_DONE;
                else if(s_rele2s_low)
                    s_state_n = S_LOW;
                else
                    s_state_n = s_state_c;
            end
            S_DONE:begin
                s_state_n = S_IDLE;
            end
          default:s_state_n = S_IDLE;
      endcase
  end

    assign s_idle2s_low  = s_state_c == S_IDLE && (m_state_c == M_ROMS ||
                            m_state_c == M_CONT || m_state_c == M_RCMD || m_state_c == M_RTMP);//主状态机要发送ROM命令 温度转化命令 读温度命令 读温度过程 每1bit数据 按照协议要求主机拉低

    assign s_low2s_send  = s_state_c == S_LOW  && (m_state_c == M_ROMS ||
                            m_state_c == M_CONT || m_state_c == M_RCMD) && end_cnt1;//主机拉低2us后 从状态机开始发送数据（命令） 

    assign s_low2s_samp  = s_state_c == S_LOW  && (m_state_c == M_RTMP && end_cnt1);//主机拉低2us后 从状态机采样接收温度数据 
    assign s_send2s_rele = s_state_c == S_SEND && (end_cnt1);//主机读1bit数据 （60us内完成）
    assign s_samp2s_rele = s_state_c == S_SAMP && (end_cnt1);//主机写1bit数据 （60us内完成）
    assign s_rele2s_low  = s_state_c == S_RELE && (end_cnt1 && end_cnt_bit == 1'b0);//主机读写完1bit （3us） 继续下一bit
    assign s_rele2s_done = s_state_c == S_RELE && (end_cnt1 && end_cnt_bit == 1'b1);//主机读写完1bit （3us） bit数读写完

//1us计数器
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_1us <= 0;
        end
        else if(add_cnt_1us) begin
            if(end_cnt_1us)begin
                cnt_1us <= 0;
            end
            else begin
                cnt_1us <= cnt_1us + 1;
            end
        end
    
    end
    assign add_cnt_1us = m_state_c != M_IDLE;//非IDLE状态持续计数
    assign end_cnt_1us = add_cnt_1us && cnt_1us == TIME_1US - 1;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt0 <= 0;
        end
        else if(add_cnt0) begin
            if(end_cnt0)begin
                cnt0 <= 0;
            end
            else begin
                cnt0 <= cnt0 + 1;
            end
        end
    
    end
    assign add_cnt0 = (m_state_c == M_REST || m_state_c == M_RELE || m_state_c == M_RACK || m_state_c == M_WAIT) && end_cnt_1us;
    assign end_cnt0 = add_cnt0 && cnt0 == X - 1;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            X <= 0;
        end
        else if(m_state_c == M_REST)begin//复位：500us (480us)
            X <= TIME_RST;
        end
        else if(m_state_c == M_RELE)begin//释放总线：20us (15-60us内)
            X <= TIME_REL;
        end
        else if(m_state_c == M_RACK)begin//接收应答：200us (60-240us)
            X <= TIME_PRE;
        end
        else if(m_state_c == M_WAIT) begin//等待：750ms (等待转换完成)
            X <= TIME_WAIT;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt1 <= 0;
        end
        else if(add_cnt1) begin
            if(end_cnt1)begin
                cnt1 <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1;
            end
        end
    
    end
    assign add_cnt1 = (s_state_c == S_LOW || s_state_c == S_SEND ||
                        s_state_c == S_SAMP || s_state_c == S_RELE) && end_cnt_1us;
    assign end_cnt1 = add_cnt1 && cnt1 == Y - 1;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            Y <= 0;
        end
        else if(s_state_c == S_LOW)begin
            Y <= TIME_LOW;//主机拉低总线 2us （大于1us）
        end
        else if(s_state_c == S_SEND || s_state_c == S_SAMP) begin
            Y <= TIME_RW;//主机读写1bit 60us （至少60us）
        end
        else begin
            Y <= TIME_REC;//主机读写完1bit释放总线 3us （至少1us）
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_bit <= 0;
        end
        else if(add_cnt_bit) begin
            if(end_cnt_bit)begin
                cnt_bit <= 0;
            end
            else begin
                cnt_bit <= cnt_bit + 1;
            end
        end
    
    end
    assign add_cnt_bit = s_state_c == S_RELE && end_cnt1;
    assign end_cnt_bit = add_cnt_bit && cnt_bit == ((m_state_c == M_RTMP)?16-1:8-1);//读温度状态有16bit数据，其余状态8bit数据

//slave_ack 采样传感器的存在脉冲
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            slave_ack <= 1'b1;
        end//接收应答状态  计数器计到60us 进行采样
        else if(m_state_c == M_RACK && cnt0 == 60 && end_cnt_1us)begin
            slave_ack <= dq_in;
        end
    end

    always@(posedge clk or negedge rst_n)begin//命令发送标志 （区分温度转换和温度读取命令）
        if(!rst_n)begin
            flag <= 0;
        end
        else if(m_wait2m_rest)begin//从等待状态转移到复位状态 flag置一读温度
            flag <= 1'b1;
        end
        else if(m_rtmp2m_idle) begin//从读温度状态转移到复位状态 flag置零读温度命令
            flag <= 1'b0;
        end
    end

//输出信号
    //dq_out
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            dq_out <= 0;
        end
        else if(m_idle2m_rest | s_idle2s_low | s_rele2s_low | m_wait2m_rest)begin
            dq_out <= 1'b0;
        end
        else if(s_low2s_send) begin//向从机发送命令码
            dq_out <= wr_data[cnt_bit];
        end
    end

    //dq_out_en
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            dq_out_en <= 0;
        end
        else if(m_idle2m_rest | s_idle2s_low | s_rele2s_low | m_wait2m_rest)begin
            dq_out_en <= 1'b1;//输出 dq_out
        end
        else if(m_rest2m_rele | s_send2s_rele | s_low2s_samp) begin
            dq_out_en <= 1'b0;//不输出dq_out
        end
    end

//wr_data 命令
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            wr_data <= 0;
        end
        else if(m_rack2m_roms)begin///ROM跳过命令
            wr_data <= CMD_ROMS;
        end
        else if(m_roms2m_cont) begin//温度转换命令
            wr_data <= CMD_CONT;
        end
        else if(m_roms2m_rcmd)begin//读暂存器温度命令
            wr_data <= CDM_RTMP;
        end
    end
//orign_data 温度采集
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            orign_data <= 0;
        end
        else if(s_state_c == S_SAMP && cnt1 == 12 && end_cnt_1us)begin
            orign_data[cnt_bit] <= dq_in;
        end
    end

//temp_data 温度判断
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            temp_data <=0;
        end
        else if(s_state_c == S_SAMP && cnt_bit == 15 && s_samp2s_rele)begin
            if(orign_data[15])
                temp_data <= ~orign_data[10:0] + 1'b1;//负数，取反加一
            else
                temp_data <= orign_data[10:0];//正数
        end
    end

/*实际的温度值为 temp_data * 0.0625;
  为了保留4位小数精度，将实际温度值放大了10000倍，
  即temp_data * 625;*/
    assign temp_data_w = temp_data * 625;

//temp_out
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            temp_out <= 0;
        end
        else if(m_state_c == M_RTMP && s_rele2s_done)begin
            temp_out <= temp_data_w;
        end
    end

//temp_out_vld
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            temp_out_vld <= 0;
        end
        else begin
            temp_out_vld <= m_state_c == M_RTMP && s_rele2s_done;
        end
    end

//temp_sign
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            temp_sign <= 0;
        end
        else if(s_state_c == S_SAMP && cnt_bit == 15 && s_samp2s_rele)begin
            temp_sign <= orign_data[15];
        end
    end

endmodule