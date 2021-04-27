module jacob_double(
	input	clk,
	input	nrst,
	input	[255:0]	p,
	input	[255:0]	x1,
	input	[255:0]	y1,
	input	[9:0]	z1,
	input	[9:0]	a,
	input	en,
	output	reg	[255:0]	x3,
	output	reg	[255:0]	y3,
	output	reg	[255:0]	z3,
	output	reg	flag
);
//这个步骤是参考硕士论文的3.1.3
// 这一步得到 x1平方,z1平方,y1平方
reg	[511:0] y_power_2,x_power_2;     
reg	[19:0]	z_power_2;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		y_power_2	<=	512'd0;
		x_power_2	<=	512'd0;
		z_power_2	<=	20'd0;
	end
	else	begin
		y_power_2	<=	y1	*	y1;
		x_power_2	<=	x1	*	x1;
		z_power_2	<=	z1	*	z1;
	end
end
//得到 3倍x平方，z四次方，x乘y平方，y四次方
reg	[513:0]		x_power_2_times_3;
reg	[39:0]		z_power_4;
reg	[767:0]		y_power_2_times_x;
reg	[1023:0]	y_power_4;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		x_power_2_times_3	<=	514'd0;
		z_power_4	<=	40'd0;
		y_power_2_times_x	<=	768'd0;
		y_power_4	<=	1024'd0;
	end
	else	begin
		x_power_2_times_3	<=	3	*	y_power_2;
		z_power_4	<=	z_power_2	*	z_power_2;
		y_power_2_times_x	<=	y_power_2	*	x1;
		y_power_4	<=	y_power_2	*	y_power_2;
	end
end
//这一步得到三个参数lamda
reg	[514:0]		lamda_1;
reg	[770:0]		lamda_2;
reg	[1027:0]	lamda_3;
always@(posedge	clk	or	negedge	nrst)begin
	if(!nrst)begin
		lamda_1	<=	515'd0;
		lamda_2	<=	771'd0;
		lamda_3	<=	1028'd0;
	end
	else	begin
		lamda_1	<=	x_power_2_times_3	+	(a	*	z_power_4);
		lamda_2	<=	4	*	y_power_2_times_x;
		lamda_3	<=	8	*	y_power_4;
	end
end
//给三个lamda取模
reg	[255:0]	lamda_1_moded,lamda_2_moded,lamda_3_moded;
always@(posedge	clk	or	negedge	nrst)begin
	if(!nrst)begin
		lamda_1_moded	<=	256'd0;
		lamda_2_moded	<=	256'd0;
		lamda_3_moded	<=	256'd0;
	end
	else	begin
		lamda_1_moded	<=	lamda_1	%	p;
		lamda_2_moded	<=	lamda_2	%	p;
		lamda_3_moded	<=	lamda_3	%	p;
	end
end
//计算x3
reg	[511:0]	x3_r;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		x3_r	<=	512'd0;
	else
		x3_r	<=	(lamda_1_moded	*	lamda_1_moded)	-	(2	*	lamda_2_moded);
end
//给x3取模
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		x3	<=	256'd0;
	else
		x3	<=	x3_r	%	p;
end
//计算y3,z3;
reg	[511:0]	y3_r;
reg [266:0] z3_r;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		y3_r	<=	512'd0;
		z3_r	<=	267'd0;
	end
	else	begin
		y3_r	<=	lamda_1_moded	*	(lamda_2_moded	-	x3)	-	lamda_3_moded;
		z3_r	<=	2	*	y1	*	z1;
  end
end
//给y3,z3取模
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		y3	<=	256'd0;
		z3	<=	256'd0;
	end
	else	begin
		y3	<=	y3_r	%	p;
		z3	<=	z3_r	%	p;
	end
end

reg	en_gate;
reg	[3:0]	counter_for_flag;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		en_gate	<=	1'b0;
	else	if(en)
		en_gate	<=	1'b1;
	else	if(counter_for_flag == 4'd8)
		en_gate	<=	1'b0;
	else
		en_gate	<=	en_gate;
end

always@(posedge clk or negedge nrst)begin
	if(!nrst)
		counter_for_flag	<=	4'd0;
	else	if(en_gate)
		counter_for_flag	<=	counter_for_flag	+	1'b1;
	else	if(!en_gate)
		counter_for_flag	<=	4'd0;
	else
		counter_for_flag	<=	counter_for_flag;
end

always@(posedge clk or negedge nrst)begin
	if(!nrst)
		flag	<=	1'b0;
	else	if(counter_for_flag	==	4'd8)
		flag	<=	1'b1;
	else
		flag	<=	1'b0;
end
endmodule






		
	