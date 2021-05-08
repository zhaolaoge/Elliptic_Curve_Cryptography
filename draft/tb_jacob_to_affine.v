module	tb_jacob_to_affine;
reg	clk,nrst,flag_input;
reg	[255:0]	x3,y3,z3,p;
initial begin
	clk = 1'b0;
	nrst = 1'b0;
	flag_input	=	1'b0;
	p  = 29;
	x3 = 9;
	y3 = 9;
	z3 = 21;
	#2 nrst = 1'b1;
	#5 flag_input	=	1'b1;
	#10	flag_input	=	1'b0;
end
always #5 clk = !clk;
wire	[255:0]	x,y;
wire	flag_output;
jacob_to_affine	u0(
	.clk(clk),
	.nrst(nrst),
	.x3(x3),
	.y3(y3),
	.z3(z3),
	.p(p),
	.flag_input(flag_input),
	.x(x),
	.y(y),
	.flag_output(flag_output)
);
endmodule

	