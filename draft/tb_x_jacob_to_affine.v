module	tb_x_jacob_to_affine;

reg	clk,nrst,flag;
reg	[255:0]	x3,z3,p;

initial begin
	clk	=	1'b0;
	nrst	=	1'b0;
	flag	=	1'b0;
	x3	=	256'd9;
	z3	=	256'd27;
	p	=	256'd29;
	#2	nrst	=	1'b1;
		flag	=	1'b1;
	#10	flag	=	1'b0;
end
always #5	clk	=	~clk;

wire	[255:0]	x;
wire	mod_x_done;
x_jacob_to_affine	u0(
	.clk(clk),
	.nrst(nrst),
	.x3(x3),
	.z3(z3),
	.p(p),
	.flag(flag),
	.x(x),
	.mod_x_done(mod_x_done)
);

endmodule