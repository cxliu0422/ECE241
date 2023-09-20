module part3(ClockIn, Resetn, Start, Letter, DotDashOut, NewBitOut);

       input ClockIn, Resetn, Start;
       input [2:0] Letter;
       output DotDashOut;
       output NewBitOut;
       wire enable;
       wire [11:0] pattern;
       

       lookuptable t0(Letter, pattern);
       ratedDivider r0(ClockIn, enable, Reset, Start);  
       assign NewBitOut = enable;
       subcircuit r1(enable, Start, ClockIn, Reset, pattern, DotDashOut);
     
endmodule

 
module subcircuit(enable, Start, Clock, Reset, D, DotDashOut);
       input enable, Start, Clock, Reset;
       input [11:0]D;
       output DotDashOut;
       reg store;
       reg [11:0]Q;

      		 
       always @(posedge Clock, negedge Reset)
       begin

              if(Reset == 0)
		begin
                     Q <= 12'b0;

		end

	      else if(Start == 1)
			Q<=D;


              else if(enable == 1'b1)
                  begin
					Q[0]<=1'b0;
					Q[1]<=Q[0];
					Q[2]<=Q[1];		
				        Q[3]<=Q[2];
					Q[4]<=Q[3];
					Q[5]<=Q[4];
					Q[6]<=Q[5];
					Q[7]<=Q[6];
					Q[8]<=Q[7];
					Q[9]<=Q[8];
					Q[10]<=Q[9];
					Q[11]<=Q[10];
					store<=Q[11];
		   end	  
							
       end

	assign DotDashOut=store;

endmodule

 

module lookuptable (Letter, pattern);
       input [2:0] Letter;
       output reg [11:0] pattern;

      

       always@(*)
       begin

              case(Letter)
                     3'b000: pattern = {5'b10111, 7'b0};//A
                     3'b001: pattern = {9'b111010101, 3'b0};///B
                     3'b010: pattern = {12'b111010111010};//C
                     3'b011: pattern = {7'b1110101, 5'b0};//D
                     3'b100: pattern = {1'b1, 11'b0};//E
                     3'b101: pattern = {12'b101011101000};//F
                     3'b110: pattern = {12'b111011101000};//G
                     3'b111: pattern = {8'b10101010, 4'b0};//H
                     default: pattern = 12'b0;

              endcase
       end
endmodule

 


module ratedDivider(Clock, enable, Reset, Start);//(500/2)-->3'd249

       input Clock, Reset, Start;
       output enable;
       reg[7:0] Q;

       always@(posedge Clock, negedge Reset)
   	begin
              if(Q == 8'b11111001)
                   Q <= 8'b0;
					
              else if(Start == 1'b1)
                   Q <= 8'b11111001;
	      else
		   Q <= Q+1;

end

	assign enable = (Q == 8'b11111001)? 1:0;
endmodule

