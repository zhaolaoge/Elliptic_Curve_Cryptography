module	tb_jacob_double;

reg	clk,nrst,en;
reg	[255:0]	p,x1,y1;
reg	[9:0]	z1,a;

initial begin
	nrst	=	1'b0;
	clk	=	1'b0;
	en	=	1'b0;
	p	=	256'd29;
	x1	=	256'd2;
	y1	=	256'd6;
	z1	=	256'd1;
	a	=	256'd4;
	#10	nrst	=	1'b1;
		en	=	1'b1;
	#	10	en	=	1'b0;
end

always#5	clk	=	~clk;

wire	[255:0]	x3,y3,z3;
wire	flag;
jacob_double	u0(
	.clk(clk),
	.nrst(nrst),
	.p(p),
	.x1(x1),
	.y1(y1),
	.z1(z1),
	.a(a),
	.en(en),
	.x3(x3),
	.y3(y3),
	.z3(z3),
	.flag(flag)
);
endmodule