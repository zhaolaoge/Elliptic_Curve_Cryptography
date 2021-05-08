module	jacob_to_affine(
	input	clk,
	input	nrst,
	input	[255:0]	x3,
	input	[255:0]	y3,
	input	[255:0]	z3,
	input	[255:0]	p,
	input	flag_input,
	output	[255:0]	x,
	output	[255:0]	y,
	output	reg	flag_output
);
parameter IDLE = 0,START = 1,COMPUTE = 2,DONE = 3;
reg	[1:0]	state,nextstate;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		state	<=	IDLE;
	else
		state	<=	nextstate;
end
wire	x_flag,y_flag;
reg	x_done,y_done;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		x_done	<=	1'b0;
	else	if(x_flag)
		x_done	<=	1'b1;
	else	if(x_done	&&	y_done)
		x_done	<=	1'b0;
	else
		x_done	<=	x_done;
end
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		y_done	<=	1'b0;
	else	if(y_flag)
		y_done	<=	1'b1;
	else	if(x_done	&&	y_done)
		y_done	<=	1'b0;
	else
		y_done	<=	y_done;
end		

always@(posedge clk or negedge nrst)begin
	if(!nrst)
		nextstate	<=	IDLE;
	else	begin
	case(state)
	IDLE:	if(flag_input	||	nextstate	==	START)
				nextstate	<=	START;
			else
				nextstate	<=	IDLE;
	START:	nextstate	<=	COMPUTE;
	COMPUTE:if(x_done	&&	y_done)
				nextstate	<=	DONE;
			else
				nextstate	<=	COMPUTE	;
	DONE:	nextstate	<=	IDLE;
	endcase
	end
end

x_jacob_to_affine	u0(
	.clk(clk),
	.nrst(nrst),
	.x3(x3),
	.z3(z3),
	.p(p),
	.flag(flag_input),
	.x(x),
	.mod_x_done(x_flag)
);
y_jacob_to_affine	u1(
	.clk(clk),
	.nrst(nrst),
	.y3(y3),
	.z3(z3),
	.p(p),
	.flag(flag_input),
	.y(y),
	.mod_y_done(y_flag)
);

always@(posedge	clk	or	negedge	nrst)begin
	if(!nrst)
		flag_output	<=	1'b0;
	else	if(x_done	&&	y_done)
		flag_output	<=	1'b1;
	else
		flag_output	<=	1'b0;
end

endmodule