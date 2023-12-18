/************************************************************************************
The code is designed and produced by MDY Science and Education Co., Ltd, which has the entire ownership. It is only for personal learning, which cannot be used for commercial or profit-making purposes without permission.

    MDY's Mission: Develop Chip Talents and Realize National Chip Dream.

    We sincerely hope that our students can learn the real IC / FPGA code through our standard and rigorous code.

    For more FPGA learning materials, please visit the Forum: http://fpgabbs.com/ and official website: http://www.mdy-edu.com/index.html 

    *************************************************************************************/
   
module mdyOV7670CameraDisplay_top(
    clk         ,
    rst_n       ,
    key_in      ,
    pclk        ,
    vsync       ,
    href        ,
    din         ,
    xclk        ,
    pwdn        ,
    sio_c       ,
    sio_d       ,
    vga_hys     ,
    vga_vys     ,
    vga_rgb     ,
    cke         ,
    cs          ,
    ras         ,
    cas         ,
    we          ,
    dqm         ,
    sd_addr     ,
    sd_bank     ,
    sd_clk      ,
    dq
);

    input               clk           ;
    input               rst_n         ;
    input               pclk          ;
    input  [3:0]        key_in        ;
    input               vsync         ;
    input               href          ;
    input  [7:0]        din           ;

    output              xclk          ;
    output              pwdn          ;
    output              vga_hys       ;
    output              vga_vys       ;
    output [15:0]       vga_rgb       ;
    output              sio_c         ;
    output              cs            ;
    output              ras           ;
    output              cas           ;
    output              we            ;
    output [1 :0]       dqm           ;
    output [12:0]       sd_addr       ;
    output [1 :0]       sd_bank       ;
    output              sd_clk        ;
	output              cke           ;    
	
  
	 
    inout  [15:0]       dq            ;
	inout               sio_d         ;
    wire   [15:0]       dq_in         ;
    wire   [15:0]       dq_out        ;
    wire                dq_out_en     ; 
    wire                en_sio_d_w    ;
    wire                sio_d_w       ;
    wire                sio_d_r       ;
    wire                xclk_         ;
    wire                clk_100m      ;
    wire                locked        ;
    wire   [3:0]        key_num       ;
    wire                en_coms       ;
    wire   [7:0]        value_gray    ;
    wire                rdy           ;
    wire                wen           ;
    wire                ren           ;
    wire   [7:0]        wdata         ;
    wire                capture_en    ;
    wire   [7:0]        rdata         ;
    wire                rdata_vld     ;
    wire   [15:0]       cmos_dout     ;
    wire                cmos_dout_vld ;
    wire                cmos_dout_sop ;
    wire                cmos_dout_eop ;
    wire   [15:0]       rd_addr       ;
    wire                rd_en         ;
    wire   [15:0]       vga_data      ;
    wire                rd_end        ;
    wire                wr_end        ;
    wire                rd_addr_sel   ;
    wire   [3:0]        key_vld       ;
    wire                display_area  ;
	wire   [7:0]        sub_addr      ;	 
    wire                cke           ;
    wire                cs            ;
    wire                ras           ;
    wire                cas           ;
    wire                we            ;
    wire   [1 :0]       dqm           ;
    wire   [12:0]       sd_addr       ;
    wire   [1 :0]       sd_bank       ;
    wire                sd_clk        ;
    wire   [15:0]       sd_rdata      ;
    wire                sd_rdata_vld  ;
    wire   [15:0]       fifo2sd_wdata ;
    wire                wr_ack        ;
    wire                rd_ack        ;
    wire                wr_req        ;
    wire                rd_req        ;
	wire   [1 :0]       bank          ;
	wire   [12:0]       addr          ;

    assign  dq_in = dq;
    assign  dq    = dq_out_en?dq_out:16'hzzzz;


    assign sio_d = en_sio_d_w ? sio_d_w : 1'dz;
    assign sio_d_r = sio_d;

   

	
	
    pll_sd  pll_sd_inst2 (
	    .inclk0       (clk           ),
	    .c0           (xclk          ),
	    .c1           (clk_100m      )	
	);


    cmos_pll  u_cmos_pll(

        .inclk0       (pclk         ),
        .c0           (clk_25M       ) 
	);
 
   

    key_module#(.KEY_W(4)) u_key_module(
        .clk          (xclk         ),
        .rst_n        (rst_n        ),
        .key_in       (key_in       ),
        .key_vld      (key_vld      )   
    );

    ov7670_config u4(
        .clk          (xclk         ),
        .rst_n        (rst_n        ),
        .config_en    (key_vld[1]   ),
        .rdy          (rdy          ),
        .rdata        (rdata        ),
        .rdata_vld    (rdata_vld    ),
        .wdata        (wdata        ),
        .addr         (sub_addr     ),
        .wr_en        (wen          ),
        .rd_en        (ren          ),
        .cmos_en      (en_capture   ),
        .pwdn         (pwdn         )       
    );

    sccb u5(
        .clk          (xclk         ),
        .rst_n        (rst_n        ),
        .ren          (ren          ),
        .wen          (wen          ),
        .sub_addr     (sub_addr     ),
        .rdata        (rdata        ),
        .rdata_vld    (rdata_vld    ),
        .wdata        (wdata        ),
        .rdy          (rdy          ),
        .sio_c        (sio_c        ),
        .sio_d_r      (sio_d_r      ),
        .en_sio_d_w   (en_sio_d_w   ),
        .sio_d_w      (sio_d_w      ) 
    );

    cmos_capture u6(
        .clk          (clk_25M       ),
        .rst_n        (rst_n        ),
        .en_capture   (en_capture   ),
        .vsync        (vsync        ),
        .href         (href         ),
        .din          (din          ),
        .dout         (cmos_dout    ),
        .dout_vld     (cmos_dout_vld),
        .dout_sop     (cmos_dout_sop),
        .dout_eop     (cmos_dout_eop) 
    );

	
    vga_config u11(
        .clk          (clk_25M      ),
        .clk_in       (clk_100m     ),
        .rst_n        (rst_n        ),
        .din          (cmos_dout    ),
        .din_vld      (cmos_dout_vld),
        .din_sop      (cmos_dout_sop),
        .din_eop      (cmos_dout_eop),
	    .dout         (vga_data     ),
	    .wr_req       (wr_req       ),
	    .rd_req       (rd_req       ),
		.wr_ack       (wr_ack       ),
        .rd_ack       (rd_ack       ),
        .wdata		  (fifo2sd_wdata),  	
		.sd_rdata     (sd_rdata     ),
	    .sd_rdata_vld (sd_rdata_vld ),
		.display_area (display_area ),
        .bank         (bank         ),
		.addr         (addr         )
    );
	 
	 
	 sdram_intf u20   (           
        .clk          (clk_100m     ),
        .rst_n        (rst_n        ),
        .wr_req       (wr_req       ),
        .rd_req       (rd_req       ),  
        .dq_in        (dq_in        ),
        .dq_out       (dq_out       ),
        .dq_out_en    (dq_out_en    ),
        .wr_ack       (wr_ack       ),
        .rd_ack       (rd_ack       ),
        .rdata        (sd_rdata     ),
        .rdata_vld    (sd_rdata_vld ),
        .cke          (cke          ),
        .cs           (cs           ),
        .ras          (ras          ),
        .cas          (cas          ),
        .we           (we           ),
        .dqm          (dqm          ),
        .sd_addr      (sd_addr      ),
        .sd_bank      (sd_bank      ),
        .sd_clk       (sd_clk       ),
		.wdata        (fifo2sd_wdata),
		.bank         (bank         ),
		.addr         (addr         )
		  
	 );
	 
	 

    vga_driver u12(
        .clk         (clk_25M       ),
        .rst_n       (rst_n         ),
        .din         (vga_data      ),
        .vga_hys     (vga_hys       ),
        .vga_vys     (vga_vys       ),
        .vga_rgb     (vga_rgb       ),
	    .display_area(display_area  )
    );
	


endmodule

