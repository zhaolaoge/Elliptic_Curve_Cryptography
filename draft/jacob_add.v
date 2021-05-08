module	jacob_add(
	input	clk,
	input	nrst,
	input	[255:0]	p,
	input	[255:0]	x1,
	input	[255:0]	y1,
	input	[9:0]	z1,
	input	[255:0]	x2,
	input	[255:0]	y2,
	input	[9:0]	z2,
	input	en,
	output	reg	[255:0]	x3,
	output	reg	[255:0]	y3,
	output	reg	[255:0]	z3,
	output	reg	flag
);
parameter STEP1 = 2,STEP2 = 3,STEP3 = 4,STEP4 = 5,STEP5 = 6,STEP6 = 7;
parameter STEP7 = 8,STEP8 = 9,STEP9 = 10,STEP10 = 11,STEP11 = 12,STEP12 = 13,STEP13 = 14;

parameter IDLE = 0,START = 1,COMPUTE = 2,DONE = 3;
reg	[1:0]	state,nextstate;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		state	<=	IDLE;
	else
		state	<=	nextstate;
end

reg	[3:0]	counter;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		nextstate	<=	IDLE;
		counter	<=	4'd0;
	end
	else	begin
	case(state)
	IDLE:	if(en	||	nextstate	==	START)begin
				nextstate	<=	START;
				counter	<=	4'd0;
			end
			else
				nextstate	<=	IDLE;
	START:	nextstate	<=	COMPUTE;
	COMPUTE:if(nextstate	==	DONE)
				nextstate	<=	IDLE;
			else if(counter == 9)
				nextstate	<=	DONE;
			else	begin
				counter	<=	counter	+	1'b1;
				nextstate	<=	COMPUTE;
			end
	DONE:	nextstate	<=	IDLE;
	endcase
	end
end
//《椭圆曲线密码学导论》P84页给出的计算流程
// first cycle
reg	[19:0]	a;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		a	<=	18'd0;
	else	if(counter 	==	4'd1)
		a	<=	z1	*	z1;
	else
		a	<=	a;
end


// second cycle
reg	[29:0]	b;
reg	[275:0]	c;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		b	<=	30'd0;
		c	<=	276'd0;
	end
	else	if(counter 	==	4'd2)begin
		b	<=	a	*	z1;
		c	<=	x2	*	a;
	end
	else	begin
		b	<=	b;
		c	<=	c;
	end
end
//third cycle
reg	[285:0]	d;
reg	[275:0]	e;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		d	<=	286'd0;
		e	<=	276'd0;
	end
	else	if(counter 	==	4'd3)begin
		d	<=	y2	*	b;
		e	<=	c	-	x1;
	end
	else	begin
		d	<=	d;
		e	<=	e;
	end
end
//forth cycle
reg	[285:0]	f;
reg	[551:0]	g;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		f	<=	286'd0;
		g	<=	552'd0;
	end
	else	if(counter 	==	4'd4)begin
		f	<=	d	-	y1;
		g	<=	e	*	e;
	end
	else	begin
		f	<=	f;
		g	<=	g;
	end
end
//fifth cycle
reg	[829:0]	h;
reg	[807:0]	i;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		h	<=	830'd0;
		i	<=	808'd0;
	end
	else	if(counter 	==	4'd5)begin
		h	<=	g	*	e;
		i	<=	x1	*	g;
	end
	else	begin
		h	<=	h;
		i	<=	i;
	end
end
//sixth cycle
reg	[255:0]	h_moded;
reg	[255:0]	i_moded;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		h_moded	<=	256'd0;
		i_moded	<=	256'd0;
	end
	else	if(counter 	==	4'd6	&&	!h[829])begin
		h_moded	<=	h	%	p;
		i_moded	<=	i	%	p;
	end
	else	if(counter 	==	4'd6	&&	h[829])begin
		h_moded	<=	p	-	(~	(h[828:0]	-	1)	%	p);
		i_moded	<=	i	%	p;
	end
	else	begin
		h_moded	<=	h_moded;
		i_moded	<=	i_moded;
	end
end
//seventh cycle
reg	[571:0]	x3_r;
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		x3_r	<=	572'd0;
	else	if(counter 	==	4'd7)
		x3_r	<=	(f	*	f)	-	(h_moded	+	i_moded	+	i_moded);
	else
		x3_r	<=	x3_r;
end
//eighth cycle
reg	[857:0]	y3_r;
reg	[285:0]	z3_r;
always@(posedge clk or negedge nrst)begin
	if(!nrst)begin
		y3_r	<=	858'd0;
		z3_r	<=	286'd0;
	end
	else	if(counter 	==	4'd8)	begin
		y3_r	<=	(f	*	(i_moded	-	x3_r))	-	(y1	*	h_moded);
		z3_r	<=		z1	*	e;
	end
	else	begin
		y3_r	<=	y3_r;
		z3_r	<=	z3_r;
	end
end
//ninth cycle
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		x3	<=	256'd0;
	else	if(counter 	==	4'd9	&&	!x3_r[571])
		x3	<=	x3_r	%	p;
	else	if(counter 	==	4'd9	&&	x3_r[571])
		x3	<=	p	-	(~	(x3_r[571:0]	-	1)	%	p);
	else
		x3	<=	x3;
end
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		y3	<=	256'd0;
	else	if(counter 	==	4'd9	&&	!y3_r[857])
		y3	<=	y3_r	%	p;
	else	if(counter 	==	4'd9	&&	y3_r[857])
		y3	<=	p	-	(~	(y3_r[857:0]	-	1)	%	p);
	else
		y3	<=	y3;
end
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		z3	<=	256'd0;
	else	if(counter 	==	4'd9	&&	!z3_r[285])
		z3	<=	z3_r	%	p;
	else	if(counter 	==	4'd9	&&	z3_r[285])
		z3	<=	p	-	(~	(z3_r[285:0]	-	1)	%	p);
	else
		z3	<=	z3;
end
//
always@(posedge clk or negedge nrst)begin
	if(!nrst)
		flag	<=	1'b0;
	else	if(state	==	DONE)
		flag	<=	1'b1;
	else
		flag	<=	1'b0;
end

endmodule