/************************************************************************************
The code is designed and produced by MDY Science and Education Co., Ltd, which has the entire ownership. It is only for personal learning, which cannot be used for commercial or profit-making purposes without permission.

    MDY's Mission: Develop Chip Talents and Realize National Chip Dream.

    We sincerely hope that our students can learn the real IC / FPGA code through our standard and rigorous code.

    For more FPGA learning materials, please visit the Forum: http://fpgabbs.com/ and official website: http://www.mdy-edu.com/index.html 

    *************************************************************************************/
module ov7670_config(
    clk        ,
    rst_n      ,
    config_en  ,
    rdy        ,
    rdata      ,
    rdata_vld  ,
    wdata      ,
    addr       ,
    wr_en	   ,
	rd_en      ,
    cmos_en    , 
    pwdn         
    );

    parameter      DATA_W  =         8;
    parameter      RW_NUM  =         2;
    

    input               clk        ;   
    input               rst_n      ;
    input               config_en  ;
    input               rdy        ;
    input [DATA_W-1:0]  rdata      ;
    input               rdata_vld  ;

    output[DATA_W-1:0]  wdata      ;
    output[DATA_W-1:0]  addr       ;
    
    output              cmos_en    ;
    output              wr_en      ;
    output              rd_en      ;
    output              pwdn       ;
    reg   [DATA_W-1:0]  wdata      ;
    reg   [DATA_W-1:0]  addr       ;
    reg                 cmos_en    ;
    reg                 wr_en      ;
    reg                 rd_en      ;

    reg   [8 :0]        reg_cnt    ;
    wire                add_reg_cnt;
    wire                end_reg_cnt;
    reg                 flag       ;
    reg   [17:0]        add_wdata  ;

    reg   [ 1:0]        rw_cnt     ;
    wire                add_rw_cnt ;

    assign              pwdn = 0;


    `include "ov7670_para.v"
		
		
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            reg_cnt <= 0;
        end
        else if(add_reg_cnt)begin
            if(end_reg_cnt)
                reg_cnt <= 0;
            else
                reg_cnt <= reg_cnt + 1;
        end
    end

    assign add_reg_cnt = end_rw_cnt;   
    assign end_reg_cnt = add_reg_cnt && reg_cnt==REG_NUM-1;

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rw_cnt <= 0;
        end
        else if(add_rw_cnt) begin
            if(end_rw_cnt)
                rw_cnt <= 0;
            else
                rw_cnt <= rw_cnt + 1;
        end
    end

    assign  add_rw_cnt = flag && rdy;
    assign  end_rw_cnt = add_rw_cnt && rw_cnt==RW_NUM-1;


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            flag <= 1'b0;
        end
        else if(config_en)begin
            flag <= 1'b1;
        end
        else if(end_reg_cnt)begin
            flag <= 1'b0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cmos_en <= 1'b0;
        end
        else if(end_reg_cnt)begin
            cmos_en <= 1'b1;
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            wdata <= 8'b0;
        end
        else begin
            wdata <= add_wdata[7:0];
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            addr <= 8'b0;
        end
        else begin
            addr <= add_wdata[15:8];
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            wr_en <= 1'b0;
        end
        else if(add_rw_cnt && rw_cnt==0 && add_wdata[16])begin
            wr_en <= 1'b1;
        end
        else begin
            wr_en <= 1'b0;
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rd_en <= 1'b0;
        end
        else if(add_rw_cnt && rw_cnt==1 && add_wdata[17])begin
            rd_en <= 1'b1;
        end
        else begin
            rd_en <= 1'b0;
        end
    end
	

endmodule

