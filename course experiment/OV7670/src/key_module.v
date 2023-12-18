/************************************************************************************
The code is designed and produced by MDY Science and Education Co., Ltd, which has the entire ownership. It is only for personal learning, which cannot be used for commercial or profit-making purposes without permission.

    MDY's Mission: Develop Chip Talents and Realize National Chip Dream.

    We sincerely hope that our students can learn the real IC / FPGA code through our standard and rigorous code.

    For more FPGA learning materials, please visit the Forum: http://fpgabbs.com/ and official website: http://www.mdy-edu.com/index.html 

    *************************************************************************************/
module key_module(
    clk    ,
    rst_n  ,
    key_in ,
    key_vld 
);
parameter                  	DATA_W 	  = 20          ;
parameter                  	KEY_W 	  = 4           ;
parameter               	TIME_20MS = 500_000     ;

input                    	clk                     ;
input                   	rst_n                   ;
input      [KEY_W-1 :0]		key_in                  ;
output     [KEY_W-1 :0]     key_vld                 ;
reg        [KEY_W-1 :0]     key_vld                 ;
reg        [DATA_W-1:0]     cnt                     ;
wire                       	add_cnt                 ;
wire                       	end_cnt                 ;
reg				            flag                    ;
reg     [KEY_W-1 :0]        key_in_ff1              ;
reg     [KEY_W-1 :0]        key_in_ff0              ;

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        cnt <= 20'b0;
    end
    else if(add_cnt)begin
        if(end_cnt)
            cnt <= 20'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= 0;
    end
end

assign add_cnt = flag==1'b0 && (&key_in_ff1==0);
assign end_cnt = add_cnt && cnt == TIME_20MS - 1;

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag <= 1'b0;
    end
    else if(end_cnt)begin
        flag <= 1'b1;
    end
    else if(&key_in_ff1==1)begin
        flag <= 1'b0;
    end
end

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_in_ff0 <= {{KEY_W}{1'b1}};
        key_in_ff1 <= {{KEY_W}{1'b1}};
    end
    else begin
        key_in_ff0 <= key_in    ;
        key_in_ff1 <= key_in_ff0;
    end
end

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_vld <= 0;
    end
    else if(end_cnt)begin
        key_vld <= ~key_in_ff1;
    end
    else begin
        key_vld <= 0;
    end
end
endmodule



