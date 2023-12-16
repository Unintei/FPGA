//发送模块
`timescale 1ns / 1ps
module uart_tx
#(
//****************************************************//	
parameter		 CLK	 	= 50_000_000 , //晶振
parameter		 Baud		= 9600 ,	 	   //波特率
parameter   	 DATA_bit	= 8,  		   //数据位个数
parameter   	 NUM_bit  	= 4,           //计数bit值的位宽 
parameter   	 CNT	  	= 14,	  	   //波特率计数器位宽
parameter   	 BPS  		= CLK/Baud    //波特率计数器值
//****************************************************//
)
(
 input 			          	 	 clk,
 input			            	 rst_n,
 input			[DATA_bit-1:0]	 d_in,
 input  		          		 d_in_cnl,
 output  reg         			 d_out
);

reg		[25 :0]   	 	 cnt0; //秒计数器值
reg		[DATA_bit-1:0]   tx_data_buff;	//待发送数据的寄存器
reg		[NUM_bit-1 :0]   data_bit;//位宽计数
reg		[CNT-1 :0]   	 cnt1;	//波特率计数器
reg		               	 tx_flag;//串口发送标志信号


//计数一秒
always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)	begin
        cnt0 <=0;end
    else if(cnt0==CLK-1)	begin
            cnt0<=26'd0;	end
        else 				 begin
            cnt0 <=cnt0+1'b1;	 end
end

//tx_flag发送标志信号  一秒发送一次受 d_in_cnl 信号控制
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)			begin
        tx_flag <= 1'b0;	end
    else if(tx_flag==1'b0 && d_in_cnl && cnt0==CLK-1) begin
        tx_flag <= 1'b1;			  end
    else if(tx_flag && data_bit==9 && cnt1==BPS-1)begin
        tx_flag <= 1'b0;						 end
end


//BPS计数，等待数据稳定采集
always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)	begin
        cnt1 <=0;end
    else if(tx_flag)				   begin
        if(cnt1==BPS-1)	begin
            cnt1<=14'd0;	end
        else 				 begin
            cnt1 <=cnt1+1'b1;	 end
    end
    else 	   begin
        cnt1<=0;end
end


//待发送数据的采集保存
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) 				begin
		tx_data_buff <=8'd0;	end
	else if(tx_flag==1'b0 && d_in_cnl) begin	
		tx_data_buff <= d_in;			  end
end


//数据发送计数器
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_bit<= 4'd0;
	end
    else if(tx_flag)begin
        if(cnt1==BPS-1)begin
            if(data_bit==9)
                data_bit <= 0;
            else
                data_bit <= data_bit+1'b1;
	    end
    end
    else begin
        data_bit <= 4'd0;
    end
end


//发送数据
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		d_out <= 1'b1;
	end
	else if(tx_flag)begin
        if(data_bit==0)begin
            d_out<=1'b0;
        end
        else if(data_bit==9)begin
            d_out<=1'b1;
        end
        else begin
            d_out <= tx_data_buff[data_bit-1];
        end
	end
    else begin
        d_out<=1'b1;
    end 
end


endmodule
