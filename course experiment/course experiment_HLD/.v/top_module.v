module top_module(
    input clk,
    input rst_n,
    
    output wire [2:0] led1,//3个LED
    output wire [2:0] led2,//3个LED
    output wire [3:0] seg_sel,//4位数码管位选
    output wire [6:0] seg_ment//7段数码管显示
);

parameter Red = 3'b011      ,
          Yellow = 3'b101   ,
          Green = 3'b110    ;

wire [4:0] ew_data;
wire [4:0] sn_data;
wire [4:0] x1;
wire [4:0] x2;


ztj ztj_inst1(
    .clk(clk),
    .rst_n(rst_n),      
    .sel(Red),          //初始颜色
    .state_c(led1),     //灯输出
	.x(x1),             //计数最大值
    .cnt1(ew_data)      //当前计数值
);

ztj ztj_inst2(
    .clk(clk),
    .rst_n(rst_n),
    .sel(Green),    //初始颜色
    .state_c(led),    //灯输出
	.x(x2),         //计数最大值
    .cnt1(sn_dat)    //当前计数值
);

smg smg_inst(
    .clk(clk),
    .rst_n(rst_n),
    .ew_data(ew_data),
    .sn_data(sn_data),
    .x1(x1),
    .x2(x2),
    .seg_sel(seg_sel),
    .seg_ment(seg_ment)
);

endmodule
