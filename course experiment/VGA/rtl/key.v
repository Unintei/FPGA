module key_filter 
#(
    parameter   KEY_W = 2,
                DELAY_TIME = 1_000_000
)
(
    input                      clk     ,
    input                      rst_n   ,
    input       [KEY_W-1:0]    key_in  ,
    output  reg [KEY_W-1:0]    key_down
);

    //计数器
    reg [19:0] cnt;

    // 标志信号
    reg filter_flag;
    reg [KEY_W-1:0] key_r0;
    reg [KEY_W-1:0] key_r1;
    reg [KEY_W-1:0] key_r2;

    // 对输入按键进行打拍，异步信号同步并检测边沿
    // 打几拍就是延时几个周期
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            key_r0 <= -1; //负数以补码的方式存放，对原码取反加1
            key_r1 <= -1;
            key_r2 <= -1;
        end
        else begin
            key_r0 <= key_in;
            key_r1 <= key_r0;
            key_r2 <= key_r1;
        end
    end

    // 第一种检测边沿
    // assign n_edge = {!key_r1[1] && key_r2[1],!key_r1[0] && key_r2[0]};

    // 第二种检测边沿
    assign n_edge = ~key_r1 & key_r2 ? 1'b1 : 1'b0;

    assign p_edge = key_r1 & ~key_r2 ? 1'b1 : 1'b0;

    // 当检测到下降沿，filter_flag为1
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            filter_flag <= 1'b0;
        end
        else if(n_edge) begin
            filter_flag <= 1'b1;
        end
        else if(end_cnt) begin
            filter_flag <= 1'b0;
        end
        else begin
            filter_flag <= filter_flag;
        end
    end

    // 当检测到filter_flga为1的时候开始计数
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 0;
        end
        else if(add_cnt) begin
            if(end_cnt || p_edge) begin
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
        else begin
            cnt <= cnt;
        end
    end

    assign add_cnt = filter_flag;
    assign end_cnt = add_cnt && cnt == DELAY_TIME-1;

    // key_down取的值是最后当前周期的key_r2值，是个稳定的值
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            key_down <= 0;
        end
        else if(end_cnt) begin
            key_down <= ~key_r2;
        end
        else begin
            key_down <= 0;
        end
    end

endmodule
