module shizhong
(
input    clk    ,
input    rst_n  ,

output wire [5:0]    seg_sel,
output wire [6:0]   seg_ment
);



wire[3:0]        m_g;//秒个位 最大值9
wire[2:0]        m_s;//秒十位 最大值5
wire[3:0]        f_g;//分个位 最大值9
wire[2:0]        f_s;//分十位 最大值5
wire[3:0]        s_g;//时个位 最大值9
wire[1:0]        s_s;//时十位 最大值2



	shizhong1 shizhong1
(
	.clk   (clk) ,
	.rst_n (rst_n) ,

	.m_g (m_g),
	.m_s (m_s),
	.f_g (f_g),
	.f_s (f_s),
	.s_g (s_g),
	.s_s (s_s),
		
	.seg_sel (seg_sel),
	.seg_ment(seg_ment)
);


	shizhong2 shizhong2
(
	.clk   (clk) ,
	.rst_n (rst_n) ,

	.m_g (m_g),
	.m_s (m_s),
	.f_g (f_g),
	.f_s (f_s),
	.s_g (s_g),
	.s_s (s_s)
	   
);


endmodule

