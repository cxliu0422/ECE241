module part2(ClockIn, Reset, Speed, CounterValue);
	input ClockIn;
	input Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	wire [10:0] w1;
	wire w2;
	
	fourto1mul m1(Speed, w1);
	ratedivider r1(ClockIn, Reset, w1, w2);
	fourbitcounter c1(ClockIn, Reset, w2, CounterValue);
endmodule
	
	
module fourto1mul(speed,ParLoad);
	input [1:0]speed;
	output reg [10:0]ParLoad;
	always@(*)
	begin
		case(speed)
			2'b00: ParLoad = 11'b0;
			2'b01: ParLoad = 11'b00111110011;
			2'b10: ParLoad = 11'b01111100111;
			2'b11: ParLoad = 11'b11111001111;
			default: ParLoad = 11'b0;
		endcase
		end
endmodule

//to derive the slower flashing rates	
module ratedivider(Clock, Clear_b, ParLoad, enable);
	input Clock;
	input Clear_b;
	input [10:0] ParLoad;
	output enable;
	reg[10:0] q;
	
	always@(posedge Clock)
	begin
		if(Clear_b==1'b1)
			q<=11'b0;
		else if(q==11'b0)
			q<=ParLoad;
		else
			q<=q-1;
	end
	assign enable = (q == 11'b0)?1:0;
endmodule
	
	
module fourbitcounter(clock,reset,En,Q);
	input clock,reset,En;
	output reg [3:0] Q;
	always@(posedge clock)
		begin
		if(reset==1'b1)
			Q<=0;
		else if(En==1'b1)
			Q<=Q+1;
		end
endmodule			
