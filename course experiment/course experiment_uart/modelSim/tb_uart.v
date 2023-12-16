`timescale 1 ns/1 ns

module tb_uart();


reg clk  ;
reg rst_n;


reg  rx_uart;


wire [7:0] led;

parameter T		   =4  ;

parameter CYCLE    = 20;


parameter RST_TIME = 3 ;


uart  
#(
	.T					 (   T    )
) uart_inst
(
    .clk                 (clk     ), 
    .rst_n               (rst_n   ),
    .rx_uart             (rx_uart ),
    .led                 (led     )
);


initial begin
    clk = 0;
    forever
    #(CYCLE/2)
    clk=~clk;
end


initial begin
    rst_n = 1;
    #2;
    rst_n = 0;
    #(CYCLE*RST_TIME);
    rst_n = 1;
end


initial begin
    #1;
    rx_uart=1;
    #(T*CYCLE);
    rx_uart=0;
    #(2*T*CYCLE); //0
    rx_uart=1;
    #(T*CYCLE);   //01
    rx_uart=0;
    #(T*CYCLE);   //010
    rx_uart=1;
    #(3*T*CYCLE); //010111
    rx_uart=0;
    #(2*T*CYCLE); //01011100
    rx_uart=1;
    #(T*CYCLE);
    rx_uart=1;
	
	


    #(8*T*CYCLE);
    rx_uart=0;
    #(T*CYCLE);
    rx_uart=1;
    #(2*T*CYCLE);
    rx_uart=0;
    #(3*T*CYCLE);
    rx_uart=1;
    #(T*CYCLE);
    rx_uart=0;
    #(2*T*CYCLE);
    rx_uart=1;
    #(T*CYCLE);
    rx_uart=1;
	
end
endmodule

