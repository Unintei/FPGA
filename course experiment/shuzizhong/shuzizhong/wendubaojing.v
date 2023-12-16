module wendubaojing(
        clk    ,  
	    rst_n  ,
        temp   ,
        buzzer
);
input                   clk         ;  
input                   rst_n       ;
input   [23:0]          temp       	;
output                  buzzer      ;
output                  led         ;
reg                     led         ;
reg                     buzzer      ;

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
    led <= 1 ;
    buzzer<=1;
    end
    else if(temp>=300000) begin
    led <=0;
    buzzer<=0; 
	end
end

endmodule
