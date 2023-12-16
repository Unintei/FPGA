// VGA_jpg————moduleo
//2023-10-31
//VGA_jpg显示模块

module  VGA_jpg
(
    input   wire            Clk_int     ,   //输入工作时钟,频率25MHz
    input   wire            Sys_Rst_n   ,   //输入复位信号,低电平有效
    input   wire    [9:0]   jpg_x       ,   //输入VGA有效显示区域像素点X轴坐标
    input   wire    [9:0]   jpg_y       ,   //输入VGA有效显示区域像素点Y轴坐标

    output  reg     [15:0]  jpg_colour        //输出像素点色彩信息
);

parameter   H_VALID =   10'd640 ,   //行有效数据
            V_VALID =   10'd480 ;   //场有效数据

parameter   RED     =   16'hF800,   //红色
            ORANGE  =   16'hFC00,   //橙色
            YELLOW  =   16'hFFE0,   //黄色
            GREEN   =   16'h07E0,   //绿色
            CYAN    =   16'h07FF,   //青色
            BLUE    =   16'h001F,   //蓝色
            PURPPLE =   16'hF81F,   //紫色
            BLACK   =   16'h0000,   //黑色
            WHITE   =   16'hFFFF,   //白色
            GRAY    =   16'hD69A;   //灰色

//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//

//jpg_colour:输出像素点色彩信息,根据当前像素点坐标指定当前像素点颜色数据
// always@(posedge Clk_int or negedge Sys_Rst_n)
//     if(Sys_Rst_n == 1'b0)
//         jpg_colour    <= 16'd0;
//     else    if((jpg_x >= 0) && (jpg_x < (H_VALID/10)*1))
//         jpg_colour    <=  RED;
//     else    if((jpg_x >= (H_VALID/10)*1) && (jpg_x < (H_VALID/10)*2))
//         jpg_colour    <=  ORANGE;
//     else    if((jpg_x >= (H_VALID/10)*2) && (jpg_x < (H_VALID/10)*3))
//         jpg_colour    <=  YELLOW;
//     else    if((jpg_x >= (H_VALID/10)*3) && (jpg_x < (H_VALID/10)*4))
//         jpg_colour    <=  GREEN;
//     else    if((jpg_x >= (H_VALID/10)*4) && (jpg_x < (H_VALID/10)*5))
//         jpg_colour    <=  CYAN;
//     else    if((jpg_x >= (H_VALID/10)*5) && (jpg_x < (H_VALID/10)*6))
//         jpg_colour    <=  BLUE;
//     else    if((jpg_x >= (H_VALID/10)*6) && (jpg_x < (H_VALID/10)*7))
//         jpg_colour    <=  PURPPLE;
//     else    if((jpg_x >= (H_VALID/10)*7) && (jpg_x < (H_VALID/10)*8))
//         jpg_colour    <=  BLACK;
//     else    if((jpg_x >= (H_VALID/10)*8) && (jpg_x < (H_VALID/10)*9))
//         jpg_colour    <=  WHITE;
//     else    if((jpg_x >= (H_VALID/10)*9) && (jpg_x < H_VALID))
//         jpg_colour    <=  GRAY;
//     else
//         jpg_colour    <=  BLACK;

always@(posedge Clk_int or negedge Sys_Rst_n)
    if(Sys_Rst_n == 1'b0)
        jpg_colour    <= 16'd0;
     else    if((jpg_x - 100) * (jpg_x -200)+(jpg_y - 200) * (jpg_y - 300)<=1000)
         jpg_colour    <=  RED;

    else
        jpg_colour    <=  BLACK;



endmodule
