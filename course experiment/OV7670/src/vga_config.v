/************************************************************************************
The code is designed and produced by MDY Science and Education Co., Ltd, which has the entire ownership. It is only for personal learning, which cannot be used for commercial or profit-making purposes without permission.

    MDY's Mission: Develop Chip Talents and Realize National Chip Dream.

    We sincerely hope that our students can learn the real IC / FPGA code through our standard and rigorous code.

    For more FPGA learning materials, please visit the Forum: http://fpgabbs.com/ and official website: http://www.mdy-edu.com/index.html 

    *************************************************************************************/
module vga_config(
    clk         ,
    clk_in      ,
    rst_n       ,
    din         ,
    din_vld     ,
    din_sop     ,
    din_eop     ,
    dout        ,
	wr_req      ,
	rd_req      ,
	wdata       ,
	wr_ack      ,
	rd_ack      ,
	sd_rdata    ,
	sd_rdata_vld,
	display_area, 
	bank        ,
	addr
);

    input          clk                  ;
	input          clk_in               ;
    input          rst_n                ;
    input  [15:0]  din                  ;
    input          din_vld              ;
    input          din_sop              ;
    input          din_eop              ;
	input          wr_ack               ;
	input          rd_ack               ;
	input  [15:0]  sd_rdata             ;
	input          sd_rdata_vld         ;
	input          display_area         ;       
	
    
    
    
   
    output [15:0]  dout                 ; 
    output         wr_req               ;
    output         rd_req               ;
    output [15:0]  wdata                ;
    output [12:0]  addr                 ;
    output [1 :0]  bank                 ;
  

    wire   [15:0]  dout                 ; 
    reg            wr_req               ;
    reg            rd_req               ;
    wire   [1 :0]  wbank                ;  
    wire   [12:0]  waddr                ;
    wire   [15:0]  wdata                ;
    reg    [1:0]   waddr_bank           ;
    reg    [1:0]   raddr_bank           ;
    wire   [1 :0]  rbank                ;
    wire   [12:0]  raddr                ;
    reg    [12:0]  addr                 ;
    reg    [1 :0]  bank                 ;
    reg            wfifo_rdreq          ;   
    wire           wfifo_wrreq          ;   
    wire           wfifo_rdempty        ;     
    wire   [10:0]  wfifo_rdusedw        ;     
    wire           rfifo_wrreq          ;   
    wire           rfifo_rdempty        ;     
    wire   [10:0]  rfifo_rdusedw        ;     	
    reg    [9:0]   cnt_rd_wfifo	        ;
	wire           add_cnt_rd_wfifo	    ;
    wire           end_cnt_rd_wfifo     ;	 
    reg    [9:0]   cnt_wr_rfifo         ;
    wire           add_cnt_wr_rfifo     ; 
    wire           end_cnt_wr_rfifo     ; 	    
    reg    [12:0]  cnt_waddr            ;
	wire           add_cnt_waddr        ;
	wire           end_cnt_waddr        ;	    
	reg    [12:0]  cnt_raddr            ;
	wire           add_cnt_raddr        ;
	wire           end_cnt_raddr        ;    
	reg    [2:0]   cnt_bank             ;
	wire           add_cnt_bank         ;
	wire           end_cnt_bank         ;
	 
	wire   [15:0]  sd_rdata             ;
	wire           sd_rdata_vld         ;
	reg            change_bank_instr    ;
	reg	           change_bank_instr_ff0;
	reg	           change_bank_instr_ff1; 
    reg            change_bank_instr_ff2;  	
    reg            get_data_flag        ;
    wire           wr_wfifo_flag        ;
    wire           rd_wfifo_star        ;
    wire           wr_rfifo_star        ; 
	reg            wr_rfifo_flag        ; 
    reg            rd_wfifo_flag	    ;
	reg            wr_finish            ;
	wire           dout_rd              ;
	wire           get_data_flag_start  ;
	wire           get_data_flag_end    ;
	 
	
  always  @(*)begin
            if(rd_wfifo_flag)
                bank=waddr_bank;
            else 
                bank=raddr_bank;
    end
	 always  @(*)begin
            if(rd_wfifo_flag)
                addr=waddr;
            else
                addr=raddr;
    end
	
	 
fifo_16bwrite	fifo_16bwrite_inst (
	.aclr        ( ~rst_n        ),
	.data        (din             ),
	.rdclk       (clk_in          ),
	.rdreq       (wfifo_rdreq     ),
	.wrclk       (clk             ),
	.wrreq       (wfifo_wrreq     ),
	.q           (wdata           ),
	.rdempty     (wfifo_rdempty   ),
	.rdusedw     (wfifo_rdusedw   )

	);
fifo_16bread	fifo_16bread_inst (
    .aclr        ( ~rst_n         ) ,
	.data        (sd_rdata        ),
	.rdclk       (clk             ),
	.rdreq       (display_area    ),
	.wrclk       (clk_in          ),
	.wrreq       (sd_rdata_vld    ),
	.q           (dout            ),
	.rdempty     (rfifo_rdempty   ),
	.rdusedw     (rfifo_rdusedw   )

	);
	
	assign wfifo_wrreq= din_vld &&(din_sop || get_data_flag);
	assign waddr  = cnt_waddr ;
	assign wbank  = waddr_bank ;
   

	  always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            get_data_flag <= 0;
        end
        else if(din_vld && din_sop)begin
            get_data_flag <= 1;
				end
        else if(din_vld && din_eop) begin
            get_data_flag <= 0;
        end
    end

	 
assign rd_wfifo_start = rd_wfifo_flag==0&&wfifo_rdusedw>=512;

	  always @ (posedge clk_in or negedge rst_n)begin
        if(!rst_n)begin
            rd_wfifo_flag <= 0;
        end
        else if(wfifo_rdusedw>=512)begin
            rd_wfifo_flag <= 1;
				end
        else if(end_cnt_rd_wfifo) begin
            rd_wfifo_flag <= 0;
        end
    end


	  always @ (posedge clk_in or negedge rst_n)begin
        if(!rst_n)begin
            wr_req <= 0;
        end
        else if(rd_wfifo_flag==0&&wfifo_rdusedw>=512)begin
           wr_req <= 1 ;
				end
        else if(wr_ack) begin
             wr_req <= 0;
        end
    end
  

    always @(posedge clk_in or negedge rst_n)begin
        if(!rst_n)begin
            cnt_rd_wfifo <= 0;
        end
        else if(add_cnt_rd_wfifo)begin
            if(end_cnt_rd_wfifo)
                cnt_rd_wfifo <= 0;
            else
                cnt_rd_wfifo <= cnt_rd_wfifo + 1;
        end
    end
	 
    assign add_cnt_rd_wfifo = rd_wfifo_flag&&((cnt_rd_wfifo==0&&wr_ack)||(cnt_rd_wfifo!=0));       
    assign end_cnt_rd_wfifo = add_cnt_rd_wfifo && cnt_rd_wfifo== 512-1;   


    always  @(*)begin
            if(add_cnt_rd_wfifo&&wfifo_rdempty==0)
                wfifo_rdreq=1;
            else
                wfifo_rdreq=0;
    end


    always @(posedge clk_in or negedge rst_n)begin
        if(!rst_n)begin
            cnt_waddr <= 0;
        end
        else if(add_cnt_waddr)begin
            if(end_cnt_waddr)
                cnt_waddr <= 0;
            else
                cnt_waddr <= cnt_waddr + 1;
        end
    end

    assign add_cnt_waddr = end_cnt_rd_wfifo;       
    assign end_cnt_waddr = add_cnt_waddr && cnt_waddr==600-1 ;   


	assign  raddr=  cnt_raddr;
	assign  rbank=  raddr_bank;
	
assign wr_rfifo_star= wr_rfifo_flag==0&&rfifo_rdusedw<550;

always  @(posedge clk_in or negedge rst_n)begin
    if(rst_n==1'b0)begin
        wr_rfifo_flag <= 0;
    end
    else if(wr_rfifo_star)begin
          wr_rfifo_flag <= 1;
    end
    else if(end_cnt_wr_rfifo)begin
         wr_rfifo_flag <= 0;
    end
end

always  @(posedge clk_in or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rd_req <= 0;
    end
    else if(wr_rfifo_star)begin
        rd_req <= 1;
    end
    else if(rd_ack)begin
         rd_req <= 0;
    end
end

  always @(posedge clk_in or negedge rst_n)begin
        if(!rst_n)begin
            cnt_wr_rfifo <= 0;
        end
        else if(add_cnt_wr_rfifo)begin
            if(end_cnt_wr_rfifo)
                cnt_wr_rfifo <= 0;
            else
                cnt_wr_rfifo <= cnt_wr_rfifo + 1;
        end
    end

    assign add_cnt_wr_rfifo = sd_rdata_vld ;       
    assign end_cnt_wr_rfifo = add_cnt_wr_rfifo && cnt_wr_rfifo== 512-1;   

 
   
    always @(posedge clk_in or negedge rst_n)begin
        if(!rst_n)begin
            cnt_raddr <= 0;
        end
        else if(add_cnt_raddr)begin
            if(end_cnt_raddr)
                cnt_raddr <= 0;
            else
                cnt_raddr <= cnt_raddr + 1;
        end
    end

    assign add_cnt_raddr = end_cnt_wr_rfifo;       
    assign end_cnt_raddr = add_cnt_raddr && cnt_raddr==600-1 ; 

	 

    always  @(posedge clk_in or negedge rst_n)begin
        if(rst_n==1'b0)begin
            waddr_bank <= 2'b00;
        end
        else if(end_cnt_waddr)begin
            waddr_bank <= ~waddr_bank;
        end
    end

assign change_bank = end_cnt_raddr&&raddr_bank==waddr_bank;

always  @(posedge clk_in or negedge rst_n)begin
    if(rst_n==1'b0)begin
        raddr_bank <= 2'b11;
    end
    else if(end_cnt_raddr&&raddr_bank==waddr_bank)begin
          raddr_bank <= ~raddr_bank;
    end

end


always  @(posedge clk_in or negedge rst_n)begin
    if(rst_n==1'b0)begin
        change_bank_instr <= 0 ;
    end
    else if(change_bank)begin
        change_bank_instr<=1;
    end
    else if(end_cnt_bank)begin
         change_bank_instr <= 0 ;
    end
end



always @(posedge clk_in or negedge rst_n)begin
    if(!rst_n)begin
        cnt_bank <= 0;
    end
    else if(add_cnt_bank)begin
        if(end_cnt_bank)
            cnt_bank <= 0;
        else
            cnt_bank <= cnt_bank + 1;
    end
end

assign add_cnt_bank = change_bank_instr;       
assign end_cnt_bank = add_cnt_bank && cnt_bank==8-1 ;   




endmodule

