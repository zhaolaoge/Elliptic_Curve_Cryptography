//将雅克比坐标y转化为仿射坐标系
module y_jacob_to_affine(
	input	clk,
	input	nrst,
	input	[255:0]	y3,
	input	[255:0]	z3,
	input [255:0]  p,
	input	flag,
	output	reg	[255:0]	y,
	output	reg	mod_y_done
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
reg	[1023:0]	fenmu_3;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		counter	<=	256'd1;
		fenmu_3	<=	z3	*	z3	*	z3;
	end
	else	begin
	case(state)
	START:	begin
				counter	<=	256'd1;
				fenmu_3	<=	z3	*	z3	*	z3;
			end
	COMPUTE:begin
				counter	<=	counter	+	1;
				fenmu_3	<=	fenmu_3	+	((z3	*	z3)	*	z3);
			end
	default:begin
				counter	<=	counter;
				fenmu_3	<=	fenmu_3;
			end
	endcase
	end
end

always@(posedge clk or negedge nrst)begin
	if(!nrst)
		nextstate	<=	IDLE;
	else	begin
	case(state)
	IDLE:		if(flag)
					nextstate	<=	START;
				else
					nextstate	<=	IDLE;
	START:		nextstate	<=	COMPUTE;
	COMPUTE:	if((fenmu_3	%	p)	==	y3)
					nextstate	<=	DONE;
				else
					nextstate	<=	COMPUTE;
	DONE:		nextstate	<=	IDLE;
	endcase
	end
end



always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		mod_y_done	<=	1'b0;
		y	<=	256'd0;
	end
	else	if(state == DONE)begin
		mod_y_done	<=	1'b1;
		y	<=	counter;
	end
	else	begin
		mod_y_done	<=	1'b0;
		y	<=	y;
	end
end

endmodule