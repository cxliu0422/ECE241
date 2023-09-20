module part1(Clock, Enable, Clear_b, CounterValue);
	input Clock;
	input Enable;
	input Clear_b;
	output [7:0] CounterValue;
	
	wire A1,A2,A3,A4,A5,A6,A7;
	wire [7:0]  Q;
	
	
	Tflipflop f0(Enable,Clock,Clear_b,Q[0]);
	assign A1= Enable & Q[0];
	
	
	Tflipflop f1(A1,Clock,Clear_b,Q[1]);
	assign A2= A1 & Q[1];
	
	Tflipflop f2(A2,Clock,Clear_b,Q[2]);
	assign A3= A2 & Q[2];
	
	Tflipflop f3(A3,Clock,Clear_b,Q[3]);
	assign A4= A3 & Q[3];
	
	Tflipflop f4(A4,Clock,Clear_b,Q[4]);
	assign A5= A4 & Q[4];
	
	Tflipflop f5(A5,Clock,Clear_b,Q[5]);
	assign A6= A5 & Q[5];
	
	Tflipflop f6(A6,Clock,Clear_b,Q[6]);
	assign A7= A6 & Q[6];
	
	Tflipflop f7(A7,Clock,Clear_b,Q[7]);
	
	assign CounterValue = Q[7:0];
	
endmodule

	
	
module Tflipflop(enable,clock,clear_b,out);
	input enable;
	input clock;
	input clear_b;
	output reg out;
	wire w1;
	assign w1=enable^out;
	
	always@(posedge clock)
	begin
		if(clear_b==1'b0)
			out<=1'b0;
		else
			out<=w1;
	end
	
endmodule


module hex_decoder(c,display);
	input [3:0]c;
	output [6:0]display;
	assign display[0]=!((!c[0]|c[1]|c[2]|c[3])&(c[0]|c[1]|!c[2]|c[3])&(!c[0]|!c[1]|c[2]|!c[3])&(!c[0]|c[1]|!c[2]|!c[3]));
	assign display[1]=!((!c[0]|c[1]|!c[2]|c[3])&(c[0]|!c[1]|!c[2]|c[3])&(!c[0]|!c[1]|c[2]|!c[3])&(c[0]|c[1]|!c[2]|!c[3])&(c[0]|!c[1]|!c[2]|!c[3])&(!c[0]|!c[1]|!c[2]|!c[3]));
	assign display[2]=!((c[0]|!c[1]|c[2]|c[3])&(c[0]|c[1]|!c[2]|!c[3])&(c[0]|!c[1]|!c[2]|!c[3])&(!c[0]|!c[1]|!c[2]|!c[3]));
	assign display[3]=!((!c[0]|c[1]|c[2]|c[3])&(c[0]|c[1]|!c[2]|c[3])&(!c[0]|!c[1]|!c[2]|c[3])&(c[0]|!c[1]|c[2]|!c[3])&(!c[0]|!c[1]|!c[2]|!c[3]));
	assign display[4]=!((!c[0]|c[1]|c[2]|c[3])&(!c[0]|!c[1]|c[2]|c[3])&(c[0]|c[1]|!c[2]|c[3])&(!c[0]|c[1]|!c[2]|c[3])&(!c[0]|!c[1]|!c[2]|c[3])&(!c[0]|c[1]|c[2]|!c[3]));
	assign display[5]=!((!c[0]|c[1]|c[2]|c[3])&(c[0]|!c[1]|c[2]|c[3])&(!c[0]|!c[1]|c[2]|c[3])&(!c[0]|!c[1]|!c[2]|c[3])&(!c[0]|c[1]|!c[2]|!c[3]));
	assign display[6]=!((c[0]|c[1]|c[2]|c[3])&(!c[0]|c[1]|c[2]|c[3])&(!c[0]|!c[1]|!c[2]|c[3])&(c[0]|c[1]|!c[2]|!c[3]));

endmodule

