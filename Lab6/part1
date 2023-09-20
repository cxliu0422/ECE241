module fsm(LEDR, KEY, SW);
	  input [1:0] SW;
	  inout [0:0] KEY;
	   output [9:0] LEDR;
		
		part1 u0(
					.Clock(KEY[0]),
					.Resetn(SW[0]),
					.w(SW[1]),
					.z(LEDR[9]),
					.CurState(LEDR[3:0])
					);
endmodule



module part1(Clock, Resetn, w, z,CurState);
	input Clock;
	input Resetn;
	input w;
	output z;
	output [3:0] CurState;
	
	reg [3:0] y_Q,Y_D;//y_Q represents current state, Y_D represents next state
	
	localparam A = 4'b0000, B=4'b0001, C= 4'b0010, D=4'b0011, E=4'b0100, F=4'b0101, G=4'b0110;
	
	always@(*)
	begin: state_table
		case(y_Q)
			
			A:begin
				if(!w) 
					Y_D=A;
				else 
					Y_D=B;
				end
			
			B:begin
				if(!w)
					Y_D=A;
				else
					Y_D=C;
				end
				
			C:begin
				if(!w)
					Y_D=E;
				else
					Y_D=D;
				end
				
			D:begin
				if(!w)
					Y_D=E;
				else
					Y_D=F;
				end
			
			E:begin
				if(!w)
					Y_D=A;
				else
					Y_D=G;
				end
			
			F:begin
				if(!w)
					Y_D=E;
				else
					Y_D=F;
				end
			
			G:begin
				if(!w)
					Y_D=A;
				else
					Y_D=C;
				end
				
			default: Y_D=A;
		endcase
	end
	
	always@(posedge Clock)
	begin: state_FFs
		if(Resetn==1'b0)
			y_Q<=A;
		else
			y_Q<=Y_D;
	end
	assign z=((y_Q==F)|(y_Q==G));
	assign CurState = y_Q;

endmodule
