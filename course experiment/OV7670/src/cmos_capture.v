/************************************************************************************
The code is designed and produced by MDY Science and Education Co., Ltd, which has the entire ownership. It is only for personal learning, which cannot be used for commercial or profit-making purposes without permission.

    MDY's Mission: Develop Chip Talents and Realize National Chip Dream.

    We sincerely hope that our students can learn the real IC / FPGA code through our standard and rigorous code.

    For more FPGA learning materials, please visit the Forum: http://fpgabbs.com/ and official website: http://www.mdy-edu.com/index.html 

    *************************************************************************************/
module cmos_capture(
    clk         ,
    rst_n       ,
    en_capture  ,
    vsync       ,
    href        ,
    din         ,
    dout        ,
    dout_vld    ,
    dout_sop    ,
    dout_eop     
);

    parameter     COL    = 640;
    parameter     ROW    = 480;

    input          clk          ; 
    input          rst_n        ;
    input          en_capture   ;
    input          vsync        ;
    input          href         ;
    input  [7:0]   din          ;

    output [15:0]  dout         ;
    output         dout_vld     ;
    output         dout_sop     ;
    output         dout_eop     ;

    reg    [15:0]  dout         ;
    reg            dout_vld     ;
    reg            dout_sop     ;
    reg            dout_eop     ;
    reg    [10:0]  cnt_x      ;
    reg    [9:0]   cnt_y      ;
    reg            flag_capture ;
    reg            vsync_ff0    ;

    wire           add_cnt_x  ;
    wire           end_cnt_x  ;
    wire           add_cnt_y  ;
    wire           end_cnt_y  ;
    wire           vsync_l2h    ;
    wire           din_vld      ;
    wire           flag_dout_vld;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_x <= 0;
        end
        else if(add_cnt_x)begin
            if(end_cnt_x)begin
                cnt_x <= 0;
            end
            else begin
                cnt_x <= cnt_x + 1;
            end
        end
    end

    assign add_cnt_x = flag_capture && din_vld;
    assign end_cnt_x = add_cnt_x && cnt_x == COL*2-1;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_y <= 0;
        end
        else if(add_cnt_y)begin
            if(end_cnt_y)begin
                cnt_y <= 0;
            end
            else begin
                cnt_y <= cnt_y + 1;
            end
        end
    end

    assign add_cnt_y = end_cnt_x;
    assign end_cnt_y = add_cnt_y && cnt_y == ROW-1;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            flag_capture <= 0;
        end
        else if(flag_capture == 0 && vsync_l2h && en_capture)begin
            flag_capture <= 1;
        end
        else if(end_cnt_y)begin
            flag_capture <= 0;
        end
    end

    assign vsync_l2h = vsync_ff0 == 0 && vsync == 1;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            vsync_ff0 <= 0;
        end
        else begin
            vsync_ff0 <= vsync;
        end
    end

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            dout <= 0;
        end
        else if(din_vld)begin
            dout <= {dout[7:0],din};
        end
    end

    assign din_vld = flag_capture && href;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            dout_vld <= 0;
        end
        else if(flag_dout_vld)begin
            dout_vld <= 1;
        end
        else begin
            dout_vld <= 0;
        end
    end

    assign flag_dout_vld = add_cnt_x && cnt_x[0] == 1;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            dout_sop <= 0;
        end
        else if(flag_dout_vld && cnt_x[10:1] == 0 && cnt_y == 0)begin
            dout_sop <= 1;
        end
        else begin
            dout_sop <= 0;
        end
    end

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            dout_eop <= 0;
        end
        else if(flag_dout_vld && cnt_x[10:1] == COL-1 && cnt_y == ROW-1)begin
            dout_eop <= 1;
        end
        else begin
            dout_eop <= 0;
        end
    end

endmodule

