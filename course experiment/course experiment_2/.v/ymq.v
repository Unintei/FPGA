/*****************************************************
	动态数码管 
	2023/11/21    1s切换一位
*****************************************************/
module  ymq

(
    input   wire            sys_clk     ,   //输入工作时钟,频率50MHz
    input   wire            sys_rst_n   ,   //输入复位信号,低电平有效
	 input   wire            end_cnt0   ,
	 input   wire    [7:0]    Led_cnt		,
    output  reg    [6:0]    led          //输出行同步信号

);

//led:数码管显示值
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
       led<=7'b111_1111;
	else if( end_cnt0  )	begin
	case(Led_cnt)
		8'b1111_1110:led<=7'b000_0001;
		8'b1111_1101:led<=7'b100_1111;
		8'b1111_1011:led<=7'b001_0010;
		8'b1111_0111:led<=7'b000_0110;
		8'b1110_1111:led<=7'b100_1100;
		8'b1101_1111:led<=7'b010_0100;
		8'b1011_1111:led<=7'b010_0000;
		8'b0111_1111:led<=7'b000_1111;
	endcase
//	ledcnt<=7'b000_1111;
	end

endmodule
