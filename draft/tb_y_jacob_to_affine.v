module	tb_y_jacob_to_affine;

reg	clk,nrst,flag;
reg	[255:0]	y3,z3,p;

initial begin
	clk	=	1'b0;
	nrst	=	1'b0;
	flag	=	1'b0;
	y3	=	256'd27;
	z3	=	256'd27;
	p	=	256'd29;
	#2	nrst	=	1'b1;
		flag	=	1'b1;
	#10	flag	=	1'b0;
end
always #5	clk	=	~clk;

wire	[255:0]	y;
wire	mod_y_done;
y_jacob_to_affine	u0(
	.clk(clk),
	.nrst(nrst),
	.y3(y3),
	.z3(z3),
	.p(p),
	.flag(flag),
	.y(y),
	.mod_y_done(mod_y_done)
);

endmodule