/************************************************************************************
The code is designed and produced by MDY Science and Education Co., Ltd, which has the entire ownership. It is only for personal learning, which cannot be used for commercial or profit-making purposes without permission.

    MDY's Mission: Develop Chip Talents and Realize National Chip Dream.

    We sincerely hope that our students can learn the real IC / FPGA code through our standard and rigorous code.

    For more FPGA learning materials, please visit the Forum: http://fpgabbs.com/ and official website: http://www.mdy-edu.com/index.html 

    *************************************************************************************/
module vga_driver(
    clk         ,
    rst_n       ,
    din         ,
    vga_hys     ,
    vga_vys     ,
    vga_rgb     ,
	display_area  
);

    parameter     DATA_W = 16;

    input                clk             ;
    input                rst_n           ;
    input  [15:0]        din             ;

    output               vga_hys         ;
    output               vga_vys         ;
    output [DATA_W-1:0]  vga_rgb         ;
    output               display_area    ;

    reg                  vga_hys         ;
    reg                  vga_vys         ;
    reg    [DATA_W-1:0]  vga_rgb         ;
    reg    [9:0]         cnt_hys         ;
    reg    [9:0]         cnt_vys         ;
    reg                  display_area    ;
    reg    [9:0]         x               ;
    reg    [9:0]         y               ;
    wire                 add_cnt_hys     ;
    wire                 end_cnt_hys     ;
    wire                 add_cnt_vys     ;
    wire                 end_cnt_vys     ;


    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_hys <= 0;
        end
        else if(add_cnt_hys)begin
            if(end_cnt_hys)
                cnt_hys <= 0;
            else
                cnt_hys <= cnt_hys + 1;
        end
    end

    assign add_cnt_hys = 1;
    assign end_cnt_hys = add_cnt_hys && cnt_hys == 800-1;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_vys <= 0;
        end
        else if(add_cnt_vys)begin
            if(end_cnt_vys)
                cnt_vys <= 0;
            else
                cnt_vys <= cnt_vys + 1;
        end
    end

    assign add_cnt_vys = end_cnt_hys;
    assign end_cnt_vys = add_cnt_vys && cnt_vys == 525-1;

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            vga_hys <= 0;
        end
        else if(add_cnt_hys && cnt_hys == 95)begin
            vga_hys <= 1;
        end
        else if(end_cnt_hys)begin
            vga_hys <= 0;
        end
    end

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            vga_vys <= 0;
        end
        else if(add_cnt_vys && cnt_vys == 1)begin
            vga_vys <= 1;
        end
        else if(end_cnt_vys)begin
            vga_vys <= 0;
        end
    end


    always @ (*)begin
        display_area = cnt_hys >= 141 && cnt_hys < (141+640) && cnt_vys >= 32 && cnt_vys < (32+480);
    end

  
    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            vga_rgb <= 0;
        end
        else if(display_area)begin
            vga_rgb <= din ;
            end
        else begin
            vga_rgb <= 0;
        end
    end
	
endmodule
