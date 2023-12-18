/************************************************************************************
The code is designed and produced by MDY Science and Education Co., Ltd, which has the entire ownership. It is only for personal learning, which cannot be used for commercial or profit-making purposes without permission.

    MDY's Mission: Develop Chip Talents and Realize National Chip Dream.

    We sincerely hope that our students can learn the real IC / FPGA code through our standard and rigorous code.

    For more FPGA learning materials, please visit the Forum: http://fpgabbs.com/ and official website: http://www.mdy-edu.com/index.html 

    *************************************************************************************/
module sdram_intf(
    clk       ,   
    rst_n     ,
    wr_req    ,
    rd_req    ,
    wdata     ,
    dq_in     ,
    dq_out    ,
    dq_out_en ,
    wr_ack    ,
    rd_ack    ,
    rdata     ,
    rdata_vld ,
    cke       ,
    cs        ,
    ras       ,
    cas       ,
    we        ,
    dqm       ,
    sd_addr   ,
    sd_bank   ,
    sd_clk    ,
    bank,
    addr  
    
);


    parameter  NOP       = 0; 
    parameter  PRECHARGE = 1;
    parameter  REF       = 2;
    parameter  MODE      = 3;
    parameter  IDLE      = 4;
    parameter  ACTIVE    = 5;
    parameter  WRITE     = 6;
    parameter  READ      = 7;

    parameter  NOP_CMD      = 4'b0111;
    parameter  PRECHARGE_CMD= 4'b0010;
    parameter  AR_CMD       = 4'b0001;
    parameter  MODE_CMD     = 4'b0000;
    parameter  ACTIVE_CMD   = 4'b0011;
    parameter  WRITE_CMD    = 4'b0100;
    parameter  READ_CMD     = 4'b0101;

    parameter  ALL_BANK     = 13'b001_0_00_000_0_000;
    parameter  CODE         = 13'b000_0_00_010_0_111;

    parameter  TIME_1046    = 1046  ;      
    parameter  TIME_200US   = 20_000;   
    parameter  TIME_TRP     = 2     ;        
    parameter  TIME_TRC     = 7     ;        
    parameter  TIME_TMRD    = 2     ;    
    parameter  TIME_TRCD    = 2     ;    
    parameter  TIME_512     = 512   ;

    input            clk                 ;
    input            rst_n               ;
    input            wr_req              ;
    input            rd_req              ;
    input  [15:0]    wdata               ;
    input  [15:0]    dq_in               ;
    input  [1 :0]    bank                ;  
    input  [12:0]    addr                ;

    output [15:0]    dq_out              ;
    output           dq_out_en           ;
    output           wr_ack              ;
    output           rd_ack              ;
    output [15:0]    rdata               ;
    output           rdata_vld           ;
    output           cke                 ;
    output           cs                  ;
    output           ras                 ;
    output           cas                 ;
    output           we                  ;
    output [1 :0]    dqm                 ;
    output [12:0]    sd_addr             ;
    output [1 :0]    sd_bank             ;
    output           sd_clk              ;

    wire   [15:0]    dq_out              ;
    reg              dq_out_en           ;
    wire             wr_ack              ;
    wire             rd_ack              ;
    reg    [15:0]    rdata               ;
    reg              rdata_vld           ;
    reg              cke                 ;
    reg              cs                  ;
    reg              ras                 ;
    reg              cas                 ;
    reg              we                  ;
    reg    [1 :0]    dqm                 ;
    reg    [12:0]    sd_addr             ;
    reg    [1 :0]    sd_bank             ;
    wire             sd_clk              ;
    reg    [3:0]     state_c             ;
    reg    [3:0]     state_n             ;
    wire             nop_to_pre_start    ; 
    wire             pre_to_ref_start    ; 
    wire             ref_to_ref_start    ; 
    wire             idle_to_ref_start   ; 
    wire             ref_to_mode_start   ; 
    wire             ref_to_idle_start   ; 
    wire             pre_to_idle_start   ; 
    wire             mode_to_idle_start  ; 
    wire             idle_to_active_start; 
    wire             active_to_rd_start  ; 
    wire             active_to_wr_start  ; 
    wire             wr_to_pre_start     ; 
    wire             rd_to_pre_start     ; 
    reg    [3:0]     conmand             ;
    reg    [13:0]    cnt                 ;
    wire             add_cnt             ;
    wire             end_cnt             ;
    reg    [2:0]     cnt1                ;
    wire             add_cnt1            ;
    wire             end_cnt1            ;
    reg    [10:0]    cnt_1046            ;
    wire             add_cnt_1046        ;
    wire             end_cnt_1046        ;
    reg    [13:0]    x                   ;
    reg              flag_init           ;
    wire             init_done           ;
    reg              ref_req             ;
    wire             ref_ack             ;
    reg              flag_rd             ;
    wire             rd_en               ;
    reg              rdata_vld_ff0       ;
    reg              rdata_vld_ff1       ;
    reg              rdata_vld_ff2       ;
    reg              flag_syn            ;
    




    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            state_c <= NOP;
        end
        else begin
            state_c <= state_n;
        end
    end
    
   
    always@(*)begin
        case(state_c)
            NOP:begin
                if(nop_to_pre_start)begin
                    state_n = PRECHARGE;
                end
                else begin
                    state_n = state_c;
                end
            end
            PRECHARGE:begin
                if(pre_to_ref_start)begin
                    state_n = REF;
                end
                else if(pre_to_idle_start)begin
                    state_n = IDLE;
                end
                else begin
                    state_n = state_c;
                end
            end
            REF:begin
                if(ref_to_ref_start)begin
                    state_n = REF;
                end
                else if(ref_to_mode_start)begin
                    state_n = MODE;
                end
                else if(ref_to_idle_start)begin
                    state_n = IDLE;
                end
                else begin
                    state_n = state_c;
                end
            end
            MODE:begin
                if(mode_to_idle_start)begin
                    state_n = IDLE;
                end
                else begin
                    state_n = state_c;
                end
            end
            IDLE:begin
                if(idle_to_ref_start)begin
                    state_n = REF;
                end
                else if(idle_to_active_start)begin
                    state_n = ACTIVE;
                end
                else begin
                    state_n = state_c;
                end
            end
            ACTIVE:begin
                if(active_to_rd_start)begin
                    state_n = READ;
                end
                else if(active_to_wr_start)begin
                    state_n = WRITE;
                end
                else begin
                    state_n = state_c;
                end
            end
            WRITE:begin
                if(wr_to_pre_start)begin
                    state_n = PRECHARGE;
                end
                else begin
                    state_n = state_c;
                end
            end
            READ:begin
                if(rd_to_pre_start)begin
                    state_n = PRECHARGE;
                end
                else begin
                    state_n = state_c;
                end
            end
            default:begin
                state_n = IDLE;
            end
        endcase
    end  
    
    
    assign nop_to_pre_start      = state_c==NOP       && end_cnt;
    assign pre_to_ref_start      = state_c==PRECHARGE && flag_init     && end_cnt;
    assign ref_to_ref_start      = state_c==REF       && flag_init     && cnt1==0  && end_cnt;
    assign idle_to_ref_start     = state_c==IDLE      && ref_req       ;
    assign ref_to_mode_start     = state_c==REF       && flag_init     && end_cnt1;
    assign ref_to_idle_start     = state_c==REF       && flag_init==0  && end_cnt ;
    assign pre_to_idle_start     = state_c==PRECHARGE && flag_init==0  && end_cnt ;
    assign mode_to_idle_start    = state_c==MODE      && flag_init     && end_cnt ;
    assign idle_to_active_start  = state_c==IDLE      && ref_req==0    && (rd_req || wr_req);
    assign active_to_rd_start    = state_c==ACTIVE    && ((flag_syn==1 && flag_rd==0) || (flag_syn==0 && rd_req)) && end_cnt;
    assign active_to_wr_start    = state_c==ACTIVE    && ((flag_syn==1 && flag_rd==1) || (flag_syn==0 && wr_req)) && end_cnt;
    assign wr_to_pre_start       = state_c==WRITE     && end_cnt;
    assign rd_to_pre_start       = state_c==READ      && end_cnt;
    
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            conmand <= NOP_CMD;
        end
        else if(nop_to_pre_start || wr_to_pre_start || rd_to_pre_start)begin
            conmand <= PRECHARGE_CMD;
        end
        else if(pre_to_ref_start || ref_to_ref_start || idle_to_ref_start)begin
            conmand <= AR_CMD;
        end
        else if(ref_to_mode_start)begin
            conmand <= MODE_CMD;
        end
        else if(idle_to_active_start)begin
            conmand <= ACTIVE_CMD;
        end
        else if(active_to_wr_start)begin
            conmand <= WRITE_CMD;
        end
        else if(active_to_rd_start)begin
            conmand <= READ_CMD;
        end
        else begin
            conmand <= NOP_CMD;
        end
    end
    
    always  @(*)begin
        {cs,ras,cas,we} = conmand;
    end

    assign sd_clk = ~clk;
        
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cke <= 1'b0;
        end
        else if(nop_to_pre_start)begin
            cke <= 1'b1;
        end
    end
    


   
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dqm <= 2'b11;
        end
        else if(init_done)begin
            dqm <= 2'b00;
        end
    end



	 always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            sd_addr <= 13'b0;
        end
        else if(nop_to_pre_start || wr_to_pre_start || rd_to_pre_start)begin
            sd_addr <= ALL_BANK;             
        end
        else if(ref_to_mode_start)begin
            sd_addr <= CODE;               
        end
        else if(idle_to_active_start)begin
		       sd_addr <= addr;  		       		                 
        end
        else begin
            sd_addr <= 13'b0;               
        end
    end
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            sd_bank <= 2'b00;
        end
        else if(idle_to_active_start||active_to_wr_start|| active_to_rd_start)begin  
		 	 sd_bank <= bank;  
		        end
        else begin
            sd_bank <= 2'b00;
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt <= 0;
        end
        else if(add_cnt)begin
            if(end_cnt)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end
    
    assign add_cnt = state_c!=IDLE;
    assign end_cnt = add_cnt && cnt==x-1;
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt1 <= 0;
        end
        else if(add_cnt1)begin
            if(end_cnt1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;
        end
    end
    
    assign add_cnt1 = state_c==REF && flag_init && end_cnt;
    assign end_cnt1 = add_cnt1 && cnt1==2-1;
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt_1046 <= 0;
        end
        else if(add_cnt_1046)begin
            if(end_cnt_1046)
                cnt_1046 <= 0;
            else
                cnt_1046 <= cnt_1046 + 1;
        end
    end
    
    assign add_cnt_1046 = flag_init==0;
    assign end_cnt_1046 = add_cnt_1046 && cnt_1046==TIME_1046-1;
    
    always  @(*)begin
        if(state_c==NOP)
            x = TIME_200US;
        else if(state_c==PRECHARGE)
            x = TIME_TRP;     
        else if(state_c==REF)
            x = TIME_TRC;     
        else if(state_c==MODE)
            x = TIME_TMRD;    
        else if(state_c==ACTIVE)
            x = TIME_TRCD;   
        else 
            x = TIME_512;    
    end
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            flag_init <= 1;
        end
        else if(init_done)begin
            flag_init <= 0;
        end
    end
    
    assign init_done = state_c==MODE && end_cnt;
    
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            ref_req <= 0;
        end
        else if(end_cnt_1046)begin
            ref_req <= 1;
        end
        else if(ref_ack)begin
            ref_req <= 0;
        end
    end
    
    assign ref_ack = state_c==IDLE && ref_req;


 /*   always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            flag_rd <= 0;
        end
        else if(rd_en)begin
            flag_rd <= 1;
        end
        else if(end_cnt)begin
            flag_rd <= 0;
        end 
    end
    
    assign  rd_en = state_c==IDLE && ref_req==0 && flag_rd==0 && rd_req;*/
   always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_rd <= 0;
    end
    else if(state_c==READ)begin
        flag_rd <= 1;
    end
    else if(state_c==WRITE)begin
        flag_rd <= 0;
    end
end


always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_syn <= 0;
    end
    else if(state_c==ACTIVE && wr_req && rd_req)begin
        flag_syn <= 1;
    end
    else if(end_cnt)begin
        flag_syn <= 0;
    end
end


    assign wr_ack = active_to_wr_start;
    assign rd_ack = active_to_rd_start;
     

    assign dq_out = wdata;
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dq_out_en <= 1'b0;
        end
        else if(active_to_wr_start)begin
            dq_out_en <= 1'b1;
        end
        else if(end_cnt)begin
            dq_out_en <= 1'b0;
        end
    end

    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rdata <= 16'b0;
        end
        else begin
            rdata <= dq_in;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rdata_vld_ff0 <= 0;
        end
        else if(active_to_rd_start)begin
            rdata_vld_ff0 <= 1;
        end
        else if(end_cnt)begin
            rdata_vld_ff0 <= 0;
        end
    end
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rdata_vld_ff1 <= 0;
            rdata_vld_ff2 <= 0;
            rdata_vld     <= 0;
        end
        else begin
            rdata_vld_ff1 <= rdata_vld_ff0;
            rdata_vld_ff2 <= rdata_vld_ff1;
            rdata_vld     <= rdata_vld_ff2;
        end
    end
    
    endmodule
    
