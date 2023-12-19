// VGA_Ctrl————module
//2023-10-31
//VGA控制模块

module VGA_Ctrl(
input	wire			Clk_int		,
input	wire			Sys_Rst_n	,
input	wire	[15:0]	jpg_colour	,

output	wire	[15:0]	Rgb			,//该点色彩信息
output	wire			H_sys		,//行同步信号
output	wire			V_sys		,//场同步信号
output	wire	[9:0]	jpg_x		,//x坐标有效图像质量是640,为10位宽
output	wire	[9:0]	jpg_y		 //x坐标有效图像质量是480,取同x好编写为10位宽
);
reg		[9:0]	cnt_h;			//行计数器 行扫描周期为800
reg		[9:0]	cnt_v;			//场计数器 行扫描周期为525
wire				Rgb_valid;		//图像有效信号

parameter	H_SYNC	= 10'd96  ,
			H_BACK	= 10'd40  ,
			H_LEFT	= 10'd8   ,
			H_VALID	= 10'd640 ,
			H_RIGHT	= 10'd8   ,
			H_FRONT	= 10'd8   ,
			H_TOTAL	= 10'd800 ;
							  
parameter	V_SYNC	= 10'd2   ,
			V_BACK	= 10'd25  ,
			V_TOP	= 10'd8   ,
			V_VALLD	= 10'd480 ,
			V_BOTTOM= 10'd8   ,
			V_FRONT	= 10'd2   ,
			V_TOTAL	= 10'd525 ;
							  
//用aiways语句

always@ (posedge Clk_int or negedge Sys_Rst_n)begin
	if(Sys_Rst_n==1'b0)		begin
		cnt_h	<=	10'b0;		end
	else if(cnt_h == H_TOTAL - 1)	begin
		cnt_h	<= 	10'b0;		end
	else 
		cnt_h	<=	cnt_h + 1'b1;
		
end

always@ (posedge Clk_int or negedge Sys_Rst_n)begin
	if(Sys_Rst_n==1'b0)		begin
		cnt_v	<=	10'b0;		end
	else if((cnt_v == V_TOTAL - 1)&&(cnt_h == H_TOTAL - 1))	begin
		cnt_v	<= 	10'b0;		end
	else if(cnt_h == H_TOTAL - 1) 	begin
		cnt_v	<=	cnt_v + 1'b1;	end
	else 
		cnt_v	<=	cnt_v ;	
end


//扫描有效图像在 ‘同步-后沿-左边框’ 以及 ‘右边框-前沿’ 之间
//只有同时在X有效图像和Y有效图像同时时才有效
//图像有效信号的设计
assign	Rgb_valid = ((  cnt_h >= H_SYNC + H_BACK + H_LEFT )
					&&( cnt_h <= H_SYNC + H_BACK + H_LEFT +H_VALID )
					&&( cnt_v >= V_SYNC + V_BACK + V_TOP )
					&&( cnt_v <= V_SYNC + V_BACK + V_VALLD + V_TOP ))
					?1'b1:1'b0;
					
//坐标信号的设计
assign	jpg_x = (Rgb_valid == 1'b1 ) ?cnt_h - (H_SYNC+H_BACK+H_LEFT):10'b0  ;

assign	jpg_y = (Rgb_valid == 1'b1 ) ?cnt_v - (V_SYNC+V_BACK+V_TOP):10'b0  ;

//行同步信号 和 场同步信号   H_SYNC-1和V_SYNC-1是因为从零开始计数
//行同步信号 和 场同步信号只有在‘同步’阶段为高电平
assign	H_sys = ( cnt_h <= H_SYNC - 1'b1) ? 1'b1 :1'b0 ;
assign	V_sys = ( cnt_v <= V_SYNC - 1'b1) ? 1'b1 :1'b0 ;


//图像数据赋值
assign	Rgb = ( Rgb_valid == 1'b1) ? jpg_colour :16'h0000 ;

endmodule
