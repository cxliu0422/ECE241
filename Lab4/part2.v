module part2(Clock, Reset_b, Data, Function, ALUout);
	
	input [3:0] Data;
	input Clock;
	input Reset_b;
	input [2:0] Function;
	output [7:0] ALUout;

	wire [7:0] alu;
	wire [7:0] register;

	aluout u1(Data,register[3:0],Function,alu);
	register u2(Clock,Reset_b,alu,register);

	assign ALUout=register;

endmodule

module register(Clock,Reset_b,in,out);
	input Clock,Reset_b;
	input [7:0] in;
	output [7:0] out;

	reg[7:0] store;	

	always@(posedge Clock)
		begin
			if(Reset_b == 1'b0)
				store<=8'b0;
			else
				store<=in;
		end
	assign out=store;

endmodule

module aluout(A,B,Function, ALUout);
	input [3:0] A;
	input [3:0] B;
	input [2:0] Function;
	output [7:0] ALUout;

	reg [7:0] temp;

	wire [4:0] c1;
	wire [3:0] c2;
	fouradder u0(A,B,0,c1,c2);
	
	always@(*)
	begin
		case(Function)
			3'b000: temp= c1;
			3'b001: temp=A+B;
			3'b010: temp={B[3],B[3],B[3],B[3],B};
			3'b011:
				begin
				if(A!=4'b0|B!=4'b0)
					temp=8'b00000001;
				else
					temp=8'b0;
				end
			3'b100:
				begin
				if(A==4'b1111&B==4'b1111)
					temp=8'b00000001;
				else
					temp=8'b0;
				end
			3'b101: temp=B<<A;
			3'b110: temp=A*B;
			3'b111: temp=ALUout;
			default:temp=8'b0;
		endcase
	end
	assign ALUout=temp;
endmodule
		

module FA(a,b,cin,s,cout);
	input a,b,cin;
	output s,cout;
	assign s=cin^a^b;
	assign cout=(a&b)|(cin&a)|(cin&b);
endmodule


module fouradder(a,b,c_in,s,c_out);
 input [3:0] a,b;
 input c_in;
 output [4:0] s;
 output [3:0]c_out;
 wire c1,c2,c3;
 
 FA bit0(a[0],b[0],c_in,s[0],c1);
 FA bit1(a[1],b[1],c1,s[1],c2);
 FA bit2(a[2],b[2],c2,s[2],c3);
 FA bit3(a[3],b[3],c3,s[3],s[4]);
 
endmodule
 
 module HexDecoder (c, HEX);
	input [3:0] c;
	output [6:0] HEX;
	assign c0 = c[0];
	assign c1 = c[1];
	assign c2 = c[2];
	assign c3 = c[3];
	
	assign HEX[0] = (~c3 & ~c2 & ~c1 & c0) + (~c3 & c2 & ~c1 & ~c0) + (c3 & ~c2 & c1 & c0) + (c3 & c2 & ~c1 & c0);
	assign HEX[1] = (~c3 & c2 & ~c1 & c0) + (~c3 & c2 & c1 & ~c0) + (c3 & ~c2 & c1 & c0) + (c3 & c2 & ~c1 & ~c0) + (c3 & c2 & c1 & ~c0) + (c3 & c2 & c1 & c0);
	assign HEX[2] = (~c3 & ~c2 & c1 & ~c0) + (c3 & c2 & ~c1 & ~c0) + (c3 & c2 & c1 & ~c0) + (c3 & c2 & c1 & c0);
	assign HEX[3] = (~c3 & ~c2 & ~c1 & c0) + (~c3 & c2 & ~c1 & ~c0) + (~c3 & c2 & c1 & c0) + (c3 & ~c2 & ~c1 & c0) + (c3 & ~c2 & c1 & ~c0) + (c3 & c2 & c1 & c0);
	assign HEX[4] = (~c3 & ~c2 & ~c1 & c0) + (~c3 & ~c2 & c1 & c0) + (~c3 & c2 & ~c1 & ~c0) + (~c3 & c2 & ~c1 & c0) + (~c3 & c2 & c1 & c0) + (c3 & ~c2 & ~c1 & c0);
	assign HEX[5] = (~c3 & ~c2 & ~c1 & c0) + (~c3 & ~c2 & c1 & ~c0) + (~c3 & ~c2 & c1 & c0) + (~c3 & c2 & c1 & c0) + (c3 & c2 & ~c1 & c0);
	assign HEX[6] = (~c3 & ~c2 & ~c1 & ~c0) + (~c3 & ~c2 & ~c1 & c0) + (~c3 & c2 & c1 & c0) + (c3 & c2 & ~c1 & ~c0);

	endmodule 
