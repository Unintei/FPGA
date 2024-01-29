module top(
	input clk,
	input rst_n,
	input  wire rx_uart,
	output wire [7:0] seg_sel,
	output wire [6:0] seg_ment
	);
//模块之间的连接用wire型 只是起到一根线连接的作用
wire [7:0] uart_data;
//串口接收模块例化
uart_rx uart_rx_inst(
	.clk(clk),           //input form top
	.rst_n(rst_n),       //input from top
	.rx_uart(rx_uart),   //input from top 
	.uart_data(uart_data)//output to smg
	);
//数码管显示例化
//子模块名（即被例化模块的名称） 例化模块名 
smg smg_inst(
	.clk(clk),            //input form top
	.rst_n(rst_n),        //input form top
	.uart_data(uart_data),//input form uart_rx
	.seg_sel(seg_sel),    //output to top
	.seg_ment(seg_ment)   //output to top
	);

	
endmodule
