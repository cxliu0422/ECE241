//
// This is the template for Part 1 of Lab 8.
//
// Paul Chow
// November 2021
//

// iColour is the colour for the box
//
// oX, oY, oColour and oPlot should be wired to the appropriate ports on the VGA controller
//

// Some constants are set as parameters to accommodate the different implementations
// X_SCREEN_PIXELS, Y_SCREEN_PIXELS are the dimensions of the screen
//       Default is 160 x 120, which is size for fake_fpga and baseline for the DE1_SoC vga controller
// CLOCKS_PER_SECOND should be the frequency of the clock being used.

module part1(iColour,iResetn,iClock,oX,oY,oColour,oPlot,oNewFrame);
   input wire [2:0] iColour;
   input wire 	    iResetn;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel drawn enable
   output wire       oNewFrame;

   parameter
     X_BOXSIZE = 8'd4,   // Box X dimension
     Y_BOXSIZE = 7'd4,   // Box Y dimension
     //define the size of screen being used
     X_SCREEN_PIXELS = 9,  // X screen width for starting resolution and fake_fpga
     Y_SCREEN_PIXELS = 7,  // Y screen height for starting resolution and fake_fpga
     //specify the clock frequency
     //automarker will set clock to 1200
     CLOCKS_PER_SECOND = 5000,// 5 KHZ for fake_fpga(default)
     X_MAX = X_SCREEN_PIXELS - 1 - X_BOXSIZE, // 0-based and account for box width
     Y_MAX = Y_SCREEN_PIXELS - 1 - Y_BOXSIZE,

     FRAMES_PER_UPDATE = 15,
     PULSES_PER_SIXTIETH_SECOND = CLOCKS_PER_SECOND / 60;

  wire [7:0] locx;
  wire [6:0] locy;
  wire update;
  wire load_en, draw_en, wait_en, erase_en, counten;
  wire [7:0] xplot;
  wire [6:0] yplot;
  CounterX c0(
          .clk(iClock), 
          .resetn(iResetn), 
          .count_en(counten),
          .locX(locx)
  );

  CounterY c1(
          .clk(iClock),
          .resetn(iResetn), 
          .count_en(counten),
          .locY(locy)
  );

  DelayCounter c2(
          .clk(iClock), 
          .resetn(iResetn),
          .oNewFrame(oNewFrame),
          .update(update)
  );

  // Framecounter c3(
  //         .clk(iClock),
  //         .resetn(iResetn),
  //         .oNewFrame(oNewFrame),
  //         .update(update)
  // );
  
  control u0(
    .clk(iClock),
    .resetn(iResetn),
    .update(update),
    .iColour(iColour),
    .xplot(xplot),//signal comes from datapath
    .yplot(yplot),
    .locx(locx),
    .locy(locy),
    .load_en(load_en),
    .draw_en(draw_en),
    .wait_en(wait_en),
    .erase_en(erase_en),
    .counten(counten),
    .oX(oX),
    .oY(oY),
    .oPlot(oPlot),
    .oColour(oColour)
  );

  datapath u1(
    .clk(iClock),
    .resetn(iResetn),
    .load_en(load_en),
    .draw_en(draw_en),
    .wait_en(wait_en),
    .erase_en(erase_en),
    .counten(counten),
    .locx(locx),
    .locy(locy),
    .xplot(xplot),//connect with input of the control
    .yplot(yplot)
  );
endmodule // part1

//control
module control(
  input clk, resetn, 
  input update,
  input [2:0] iColour,
  input [7:0] xplot,//signal comes from datapath
  input [6:0] yplot,
  input [7:0] locx,
  input [6:0] locy,
  output reg load_en, draw_en, wait_en, erase_en, counten,
  output reg [7:0] oX,//output port
  output reg [6:0] oY, 
  output reg oPlot, 
  output reg [2:0] oColour
);

  wire [7:0] xbound;
  assign xbound = locx + 2'd3;
  wire [6:0] ybound;
  assign ybound = locy + 2'd3;
  
  reg [2:0] current_state, next_state;

  localparam 
          Load=3'b0,
          Draw=3'b001,
          Draw_wait=3'b010,
          Erase=3'b011,
          Update=3'b100;

  always@(*)//state table
    if(!resetn) 
      begin:state_table
        case(current_state)
          Load:
            begin
                next_state=Draw;
            end
          Draw:
            begin
              if(xplot==xbound && yplot==ybound)
                next_state=Draw_wait;
              else
                next_state=Draw;
            end
          
          Draw_wait:
            begin
              // wait_en <= 1'b1;
              // Framecounter (clk, resetn, update);
              if(update)//when 15 frames are counted, we go to erase
                next_state=Erase;
              else
                next_state=Draw_wait;
            end
  
          Erase://same as the draw
            begin
              // erase_en <= 1'b1;
              if(xplot==xbound && yplot==ybound)
                next_state=Update;
              else
                next_state=Erase;
            end
  
          Update:
            begin
              next_state=Load;
            end
  
          default:
            next_state=Load;
  
        endcase
      end

  always@(*)
    begin
      load_en <= 1'b0;
      draw_en <= 1'b0;
      wait_en <= 1'b0;
      erase_en <= 1'b0;
      counten <= 1'b0;

      case(current_state)

        Load:begin
          load_en <= 1'b1;
          draw_en <= 1'b0;
          wait_en <= 1'b0;
          erase_en <= 1'b0;
          counten <= 1'b0;
        end

        Draw:begin
          load_en <= 1'b0;
          draw_en <= 1'b1;
          wait_en <= 1'b0;
          erase_en <= 1'b0;
          counten <= 1'b0;
        end

        Draw_wait:begin
          load_en <= 1'b0;
          draw_en <= 1'b0;
          wait_en <= 1'b1;
          erase_en <= 1'b0;
          counten <= 1'b0;
        end

        Erase:begin
          load_en <= 1'b0;
          draw_en <= 1'b0;
          wait_en <= 1'b0;
          erase_en <= 1'b1;
          counten <= 1'b0;
        end

        Update:begin
          load_en <= 1'b0;
          draw_en <= 1'b0;
          wait_en <= 1'b0;
          erase_en <= 1'b0;
          counten <= 1'b1;
        end
      endcase
    end
  

  always@(posedge clk)
  begin
    if(!resetn)
      current_state<=Load;
    else
      current_state<=next_state;
  end

  
  //output port
  always@(posedge clk) begin
    if(!resetn) begin
        oX <= 8'd0;
        oY <= 8'd0;
        oPlot <= 1'b0;
        oColour <= 3'b000;
    end
    else begin
        oX <= xplot;
        oY <= yplot;
        oPlot <= (current_state==Draw || current_state==Erase);
        oColour <= (current_state==Draw) ? iColour:3'b000;
    end
  end
endmodule


//Datapath
module datapath(
  input clk, resetn, load_en, draw_en, wait_en, erase_en, counten,
  input [7:0] locx,
  input [6:0] locy,
  output reg [7:0] xplot,//connect with input of the control
  output reg [6:0] yplot
);

  wire [7:0] xbound;
  assign xbound = locx + 2'd3;
  wire [6:0] ybound;
  assign ybound = locy + 2'd3;
  always@(posedge clk)
  begin
    if(!resetn)
      begin
        xplot<=8'b0;
        yplot<=7'b0;
      end
    else
      begin
        if(load_en) begin//load state
          xplot <= locx;//always start from upper-left corner
          yplot <= locy;
        end

        if(draw_en) begin//draw state
          if(xplot==xbound)begin
            xplot <= locx;
            yplot <= yplot + 1'b1;
          end
          else
            xplot <= xplot + 1;
        end

        if(wait_en) begin//draw_wait state
          xplot <= locx;
          yplot <= locy;
        end

        if(erase_en) begin//erase state
          if(xplot==xbound) begin
            xplot <= locx;
            yplot <= yplot + 1'b1;
          end
          else
            xplot <= xplot + 1;
        end
      end
  end
endmodule


//rate divider --> DelayCounter generates an enable pulse every 1/60th of a second-->frame period
//PULSES_PER_SIXTIETH_SECOND = 1200 / 60 = 20; CLOCKS_PER_SECOND = 1200;
module DelayCounter(input clk, resetn, output reg oNewFrame, update);
  reg[23:0] Q;
  reg [8:0] frameCounter;
  //wire temp;
  
  always@(posedge clk)
    begin
      if(!resetn) 
      begin
          Q<=24'd0;
      end
      else 
        begin
        if(Q==24'd19)
        begin
          Q<=24'd0;
        end
        else
        begin
          Q<=Q+1'b1;
        end
        end
    end
      

  //assign temp = (Q==24'd19);

  always@(posedge clk) begin
    if(!resetn)
      begin
        oNewFrame <= 1'b0;
        frameCounter<=8'd0;
        update<=1'b0;
      end
    else begin
        oNewFrame <= (Q==24'd19)? 1:0;
    
        if(oNewFrame) begin
          if(frameCounter==8'd14)
            frameCounter<=8'd0;
          else
            frameCounter<=frameCounter+1'b1;
        end

      update<=(frameCounter==8'd14 && oNewFrame)?1:0;
        // if(frameCounter==8'd14 && oNewFrame)
        //   update <= 1'b1;
    end
  end
endmodule  


//FRAMES_PER_UPDATE = 15; 20*15frames = 300
// module Framecounter(input clk, resetn, oNewFrame, output reg update);
//   reg[8:0] Q;

//   always@(posedge clk)
//     begin
//       if(!resetn) 
//       begin
//           Q<=8'd0;
//       end
//       else begin
//         if(oNewFrame) begin
//           if(Q == 8'd14 && oNewFrame)
//             Q<=8'd0;
//         end
//         else begin
//             Q<=Q+8'b1;
//         end
//       end
//     end 

//   always@(posedge clk) begin
//     if(!resetn)
//         update<=1'b0;
//     else
//       begin
//         update <= (Q==8'd14)? 1:0;
//       end
//   end
// endmodule

module CounterX(input clk, resetn, count_en, output reg [7:0] locX);
  reg DirH;// left0/righ1
  
  //The direction register
  always@(posedge clk)
  begin
    if(locX>=8'd4)//X_MAX = 9-1-4=4; flip to count down
        DirH<=1'b0;//left
      if(locX==8'd0)
        DirH<=1'b1;//right
  end
  
  //implementation of CounterX
  always@(posedge clk)
  begin
      if(!resetn)
      begin
          DirH<=1;//right
          locX<=0;
      end
      
      if(count_en)
      begin
          if(DirH==1'b1)//right
            // if(locX>=8'd4)
            //   locX<=locX-1;
            // else
              locX<=locX+1;
          if(DirH==1'b0)//left
            // if(locX==8'd0)
            //   locX<=8'd5;
            // else
              locX<=locX-1;
      end 
  end
  
endmodule
        
    
module CounterY(input clk, resetn, count_en, output reg [6:0] locY);
  reg DirY;// up0/down1

  //The direction register
  always@(posedge clk)
  begin
    if(locY==7'd3)//Y_MAX = 7-1-4=2;flip to count down
        DirY<=1'b1;//up
      if(locY==7'd0)
        DirY<=1'b0;//down
  end
  
  //implementation of CounterY
  always@(posedge clk)
  begin
      if(!resetn)
      begin
          DirY<=1;//down
          locY<=0;
      end
      
      if(count_en)
      begin
          if(DirY==1'b0)//down
            if(locY>=7'd3)
              locY<=7'd0;
            else
              locY<=locY+1;
          if(DirY==1'b1)//up
            if(locY==7'd0)
              locY<=7'd3;
            else
              locY<=locY-1;
      end
  end
endmodule



//draw the 4*4 box
      // if(iPlotBox&&count_en) 
      // begin
      //     if(counter==4'd15)
      //         count<=4'b0;
      //     else
      //     begin
      //         count<=count+4'd1;
      //         xout<=rx+counter[1:0];
      //         yout<=ry+counter[3:2];
      //     end
      // end
      
      // //erase 4*4 box-->same as draw
      // if(iBlack&&count_en) 
      // begin
      //     if(counter==4'd15)
      //     count<=4'b0;
      //     else
      //     begin
      //       count<=count+4'd1;
      //       xout<=rx+counter[1:0];
      //       yout<=ry+counter[3:2];
      //     end
      // end

      // //After erase the box, count_en is activated, otherwise x,y counter are not enabled
      // if(!count_en) begin
      //         counter<=4'b0;
