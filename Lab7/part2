//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow(baili gaojiao)
// November 2021
//

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire          iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire       oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here

    wire l_x,l_y,l_colour;
	 wire enBlack,enPlot;
    wire drawEnd,blackEnd;
		
    control u0(iResetn,iClock,iLoadX,iPlotBox,iBlack,drawEnd,blackEnd, oPlot,oDone,l_y,l_colour,l_x,enBlack,enPlot);
    datapath u1(iClock,iResetn,enBlack,enPlot,l_x,l_y,l_colour,iColour,iXY_Coord,oX,oY,oColour,drawEnd,blackEnd);


endmodule // part2


module control(
	input resetn,
    input clk,
    input go,
    input plot,
    input clear,
	input drawend,
	input blackend,
//            input [3:0] counter,
//            input [7:0] counterx,
//            input [6:0] countery,
            
    output reg oPlot, oDone,l_y, l_colour, l_x,enblack,enplot
);
            
            reg [2:0] current_state, next_state;

            
            localparam s_load_x = 3'd0,
                         s_load_x_wait = 3'd1,
                         s_load_y = 3'd2,
                         s_load_y_wait = 3'd3,
                         draw = 3'd4,
                         black = 3'd5,
							 done=3'd6;
            
    always@(*)
       begin: state_table
            case(current_state)
                 s_load_x: next_state = go ? s_load_x_wait:s_load_x;
                 s_load_x_wait: next_state = go ? s_load_x_wait:s_load_y;
                 s_load_y: next_state = plot ? s_load_y_wait:s_load_y;
                 s_load_y_wait: next_state=plot ? s_load_y_wait:draw;
                 draw: next_state = drawend? done:draw;
                 black: next_state = blackend? done:black;
					done:
						begin
							if(go)
								next_state=s_load_x;
							else if(clear)
								next_state=black;
							else
								next_state=done;
							end
         default: next_state=s_load_x;
     endcase
  end

   always@(*)
      begin: enable_signals
            oPlot=1'b0;
            oDone=1'b0;
            l_x=1'b0;
            l_y=1'b0;
            l_colour=1'b0;
            
            case(current_state)
                  s_load_x: begin
                        oPlot=1'b0;
                        l_x=1'b1;
                        l_y=1'b0;
                        l_colour=1'b0;
							oDone=1'b0;
                  end
                  
                  s_load_y:begin
                        oPlot=1'b0;
                        l_x=1'b0;
                        l_y=1'b1;
                        l_colour=1'b1;
                  end
                  
                  draw: begin
                        oPlot=1'b1;
                        l_x=1'b0;
                        l_y=1'b0;
                        l_colour=1'b0;
							enplot=1'b1;
                  end
                  
                  black: begin
                        oPlot=1'b1;
                        l_x=1'b0;
                        l_y=1'b0;
                        l_colour=1'b0;
							enblack=1'b1;
                  end

					done: begin
							oPlot=1'b0;
							enblack=1'b0;
							enplot=1'b0;
							oDone=1'b1;
						end

            endcase
      end
      
//      always@(posedge clk)
//      begin
//            if(current_state==cycle_0 && counter==4'd15)
//                  oDone<=1'b1;
//            else if(current_state==black && counterx==8'd159 && countery==7'd119)
//                  oDone<=1'b1;
//            else
//                  oDone<=1'b0;
//      end
//      
  always@(posedge clk)
      begin: state_FFs
            if(!resetn)
                  current_state<=s_load_x;
            else if(clear)
                  current_state<=black;
            else
                  current_state<=next_state;
      end


	always@(posedge clk)
      begin
            if(!resetn)
				oDone<=1'b0;
			else if(clear)
				oDone<=1'b0;
      end

endmodule
      
      
      
module datapath(
     input clk,
     input resetn,
     input iblack,
	  input iPlotBox,
     input l_x,l_y,l_colour,
     input [2:0] icolour,
     input [6:0] ixycoor,

     output reg [7:0] xout,
     output reg [6:0] yout,
     output reg [2:0] colourout,
     output reg  drawend,
     output reg  blackend
);


            
    reg [7:0] ox;
    reg [6:0] oy;
    reg [2:0] col;
	reg [7:0] xcounter;
	reg [6:0] ycounter;
	reg [4:0] counter;

            
    always@(posedge clk)
       begin
            //registers x, y, colour with respective input logic
             if(!resetn)
                  begin
						xout<=8'd0;
						yout<=7'd0;
						colourout<=3'd0;
						drawend<=1'b0;
						blackend<=1'b0;
                     ox<=8'd0;
                     oy<=7'd0;
                     col<=3'd0;
						xcounter<=8'd0;
						ycounter<=7'd0;
						counter<=5'd0;
                 end
             else
                        //load x, y, colour when their enable signals are high
                 begin
                     if(l_x)
                        ox <= {1'b0,ixycoor};
                     if(l_y)
                        oy <= ixycoor;
                     if(l_colour)
                        col<=icolour;
                  end
            end
            
            //output xout, yout and colourout register
     always@(posedge clk)
			begin
				if(iPlotBox)
					begin
						if(counter<=5'd15)
							begin
								counter<=counter+4'd1;
								xout<=ox+counter[1:0];
                            yout<=oy+counter[3:2];
                            colourout<=col;
								drawend=1'b0;
							end
						else
							begin
							drawend=1'b1;
							counter<=5'd0;
							end
					end
			end
			
	always@(posedge clk)
			begin
				if(iblack)
				begin
				if(xcounter==8'd0&&ycounter==7'd0)
					blackend<=1'b0;
				if(xcounter==8'd159 && ycounter==7'd119)
                 begin
                     xcounter<=8'd0;
                     ycounter<=7'd0;
						blackend<=1'b1;
                 end
             else if(xcounter==8'd159&&ycounter!=7'd119)
					begin
						xcounter<=8'd0;
						ycounter<=ycounter+7'd1;
					end
				else
					begin
					 xcounter<=xcounter+8'd1;
					end
                xout<=xcounter;
                yout<=ycounter;
                colourout<=3'd0;                          
          end
   end
endmodule
//            begin
//                  if(!resetn)
//                        begin
//                              xout<=8'd0;
//                              yout<=7'd0;
//                              colourout<=3'd0;
//                              xcounter<=8'd0;
//                              ycounter<=7'd0;
//                              counter<=4'd0;
//                        end
//                  else//reset is high
//                        begin
//                        if(iblack == 0)
//                              begin
//                        //need to plot a box
//                              if(iPlotBox)
//                                    begin
//                                          if(counter <= 4'd15)
//                                          begin
//                                                counter<=counter+4'd1;
//                                                xout<=ox+counter[1:0];
//                                                yout<=oy+counter[3:2];
//                                                colourout<=col;
//                                          end
//                                          else
//                                                counter <= 4'd0;
//                                    end                                 
//                              end
//                     else//iblack is high, we need to clear the whole screen to black(000)
//                              begin                                                       
//                                          if(xcounter==8'd159 && ycounter!=7'd119)
//                                                begin
//                                                      xcounter<=8'd0;
//                                                      ycounter<=ycounter+7'd1;
//                                                end
//                                          else
//                                                begin
//                                                      xcounter<=xcounter+8'd1;
//                                                end
//                                          xout<=xcounter;
//                                          yout<=ycounter;
//                                          colourout<=3'd0;                          
//                              end
//                        end
//            end
//endmodule
