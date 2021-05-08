//将雅克比坐标x转化为仿射坐标系
module x_jacob_to_affine(
	input	clk,
	input	nrst,
	input	[255:0]	x3,
	input	[255:0]	z3,
	input [255:0]  p,
	input	flag,
	output	reg	[255:0]	x,
	output	reg	mod_x_done
);
parameter IDLE = 0, START = 1, COMPUTE = 2, DONE = 3;

reg	[1:0]	state,nextstate;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		state	<=	IDLE;
	else
		state	<=	nextstate;
end

reg	[255:0]		counter;
reg	[767:0]		fenmu_2;

always@(posedge clk or negedge nrst)begin
	if(!nrst)	begin
		nextstate	<=	IDLE;
		counter	<=	256'd1;
		fenmu_2	<=	z3	*	z3;
	end
	else	begin
	case(state)
	IDLE:		if(flag)
					nextstate	<=	START;
				else	if(nextstate	==	START)
					nextstate	<=	START;
				else
					nextstate	<=	IDLE;
	START:		begin
					nextstate	<=	COMPUTE;
					fenmu_2	<=	z3	*	z3;
				end	
	COMPUTE:	if(nextstate	==	DONE)
					nextstate	<=	IDLE;
				else	if((fenmu_2	%	p)	==	x3)
					nextstate	<=	DONE;
				else	begin
					counter	<=	counter	+	1;
					nextstate	<=	COMPUTE;
					fenmu_2	<=	fenmu_2	+	(z3	*	z3);
				end
	DONE:		nextstate	<=	IDLE;
	endcase
	end
end



always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		mod_x_done	<=	1'b0;
		x	<=	256'd0;
	end
	else	if(nextstate == DONE)begin
		mod_x_done	<=	1'b1;
		x	<=	counter;
	end
	else	begin
		mod_x_done	<=	1'b0;
		x	<=	x;
	end
end

endmodule