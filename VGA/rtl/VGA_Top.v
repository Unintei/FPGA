// VGA_Top————module
//2023-10-31
//VGA顶层模块


module  VGA_Top
(
    input   wire            Sys_clk     ,   //输入工作时钟,频率50MHz
    input   wire            Sys_Rst_n   ,   //输入复位信号,低电平有效

    output  wire            H_sys       ,   //输出行同步信号
    output  wire            V_sys       ,   //输出场同步信号
    output  wire    [15:0]  Rgb             //输出像素信息
);

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//
//wire define
wire            VGA_clk ;   //VGA工作时钟,频率25MHz
wire            locked  ;   //PLL locked信号
wire            Rst_n   ;   //VGA模块复位信号
wire    [9:0]   jpg_x   ;   //VGA有效显示区域X轴坐标
wire    [9:0]   jpg_y   ;   //VGA有效显示区域Y轴坐标
wire    [15:0]  jpg_colour;   //VGA像素点色彩信息

//Rst_n:VGA模块复位信号
assign  Rst_n = (Sys_Rst_n & locked);

//********************************************************************//
//*************************** Instantiation **************************//
//********************************************************************//

//------------- clk_gen_inst -------------
PLL PLL_inst
(
    .inclk0     (Sys_clk    ),  //输入50MHz晶振时钟,1bit

    .c0         (VGA_clk    ),  //输出VGA工作时钟,频率25Mhz,1bit
    .locked     (locked     )   //输出pll locked信号,1bit
);

//------------- VGA_Ctrl_inst -------------
VGA_Ctrl  VGA_Ctrl_inst
(
    .Clk_int    (VGA_clk    ),  //输入工作时钟,频率25MHz,1bit
    .Sys_Rst_n  (Rst_n      ),  //输入复位信号,低电平有效,1bit
    .jpg_colour   (jpg_colour   ),  //输入像素点色彩信息,16bit

    .jpg_x      (jpg_x      ),  //输出VGA有效显示区域像素点X轴坐标,10bit
    .jpg_y      (jpg_y      ),  //输出VGA有效显示区域像素点Y轴坐标,10bit
    .H_sys      (H_sys      ),  //输出行同步信号,1bit
    .V_sys      (V_sys      ),  //输出场同步信号,1bit
    .Rgb        (Rgb        )   //输出像素点色彩信息,16bit
);

//------------- VGA_jpg_inst -------------
VGA_jpg VGA_jpg_inst
(
    .Clk_int    (VGA_clk    ),  //输入工作时钟,频率25MHz,1bit
    .Sys_Rst_n  (Rst_n      ),  //输入复位信号,低电平有效,1bit
    .jpg_x      (jpg_x      ),  //输入VGA有效显示区域像素点X轴坐标,10bit
    .jpg_y      (jpg_y      ),  //输入VGA有效显示区域像素点Y轴坐标,10bit

    .jpg_colour   (jpg_colour   )   //输出像素点色彩信息,16bit
);

endmodule
