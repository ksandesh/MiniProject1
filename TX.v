`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Team 3
// Engineer: 		Chandana, Albert
// 
// Create Date:   	Sept 14, 2014
// Design Name: 	TX
// Module Name:    	TX 
// Project Name: 	SPART
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TX(
	input clk,
    input tx_enable,
    input rst,
	input write,
    output reg txd,
    input [7:0] tx_in,
    output reg tbr
    );
	
	reg [7:0] tx_buffer;
    reg [3:0] count;
 
	always@(posedge clk) // tx_clk counts at baud rate 
	begin
		if(rst)
			begin
			tbr <= 1;
			tx_buffer <= 8'b11111111;
			txd <= 1;
			count <=0;
			end
		else if(tx_enable)
			begin
			if( write && tbr) // 
				begin
				tx_buffer <= tx_in;
				tbr <= 0;
				end
			else if(tbr==0)
				begin
				if        (count == 4'd0)     begin count <= count+1; txd <= 1'b0        ; end  //start bit
				else if   (count == 4'd1)     begin count <= count+1; txd <= tx_buffer[0]; end
				else if   (count == 4'd2)     begin count <= count+1; txd <= tx_buffer[1]; end
				else if   (count == 4'd3)     begin count <= count+1; txd <= tx_buffer[2]; end
				else if   (count == 4'd4)     begin count <= count+1; txd <= tx_buffer[3]; end
				else if   (count == 4'd5)     begin count <= count+1; txd <= tx_buffer[4]; end
				else if   (count == 4'd6)     begin count <= count+1; txd <= tx_buffer[5]; end
				else if   (count == 4'd7)     begin count <= count+1; txd <= tx_buffer[6]; end
				else if   (count == 4'd8)     begin count <= count+1; txd <= tx_buffer[7]; end
				else /*if (count == 4'd9)*/   begin count <= 0      ; txd <= 1'b1        ; tbr <= 1; end // stop bit			
				end 
			else
				begin
				count <= 0;
				txd <= 1;
				tbr <= 1;
				tx_buffer <= 8'b11111111;
				end
			end
				
	end
endmodule



/*
module TX(
    input clk,
    input rst,
    input write,
    output reg txd,
    input [7:0] tx_in,
    output reg tbr
    );
	
    reg [ 7:0] tx_buffer;
	reg        state, next_state;
	reg [ 3:0] state_count;

	// States
	parameter IDLE     = 1'b0;
	parameter TRANSMIT = 1'b1;
	
	
	// State transition
	always@(posedge clk, posedge rst) // tx_clk counts at baud rate 
	begin
		if(rst) 
			state <= IDLE;
		else    
			if(enable)
				state <= next_state;
	end	
	
	// Next State logic
	always@(state,write) 
		begin
	
		case(state)
		IDLE: begin

			if (write) 
				begin
                tx_buffer = tx_in;
				next_state = TRANSMIT;
				state_count = 4'd1;
				end
			else begin //writes to the buffer but doesn't transmit untill a chip select comes
			  next_state = IDLE;
			  tx_buffer = 8'b11111111;
			end
			tx_tbr = 1;
			txd = 1;

		end
		
		TRANSMIT: begin

			if      (state_count == 4'd1) txd = 1'b0; //start bit
			else if (state_count == 4'd2) txd = tx_buffer[0];
			else if (state_count == 4'd3) txd = tx_buffer[1];
			else if (state_count == 4'd4) txd = tx_buffer[2];
			else if (state_count == 4'd5) txd = tx_buffer[3];
			else if (state_count == 4'd6) txd = tx_buffer[4];
			else if (state_count == 4'd7) txd = tx_buffer[5];
			else if (state_count == 4'd8) txd = tx_buffer[6];
			else                          txd = tx_buffer[7];

			tx_tbr = 0;
			state_count = state_count + 1;

			if (state_count == 10) 
			begin
			  txd    = 1'b1;          //stop bit
			  tx_tbr = 1'b1;
			  next_state = IDLE;     
			end
			else next_state = TRANSMIT;

		end
		endcase

endmodule
*/


	
    /*
	reg [ 7:0] tx_buffer;
	reg [ 3:0] state, next_state;
	
	
	// States
	parameter IDLE = 4'b1010, WRITE = 4'b1011; 
	parameter TX_0 = 4'b0000;
	parameter TX_1 = 4'b0001;
	parameter TX_2 = 4'b0010;
	parameter TX_3 = 4'b0011;
	parameter TX_4 = 4'b0100;
	parameter TX_5 = 4'b0101;
	parameter TX_6 = 4'b0110;
	parameter TX_7 = 4'b0111;
	parameter TX_8 = 4'b1000;
	parameter TX_9 = 4'b1001;
	
   */
   
   
	
   /* 
	
	
	// Next State logic
	always@(state, write)
	begin
	
		case(state)
		IDLE : 
			if(write)  // write signal
				begin
				next_state = WRITE;
				end
		WRITE: 
			begin
			next_state = TX_0;
			end
		
		TX_0:
			next_state = TX_1;
		TX_1:
			next_state = TX_2;
		TX_2:
			next_state = TX_3;
		TX_3:
			next_state = TX_4;
		TX_4:
			next_state = TX_5;
		TX_5:
			next_state = TX_6;
		TX_6:
			next_state = TX_7;
		TX_7:
			next_state = TX_8;
		TX_8:
			next_state = TX_9;
		
		TX_9:
			next_state = IDLE;
		endcase
	end		
	
	always@(state)
	begin
		case(state)
		IDLE:
		begin
			tx_buffer = 8'b11111111;
			tbr = 1;
			txd = 1;
		end
		
		WRITE:
		begin
			tx_buffer = tx_in;
			tx_tbr = 0;
			txd = 1;
		end
		
		TX_0:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = 0;  // send start bit
		end
		
		TX_1:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[0]; 
		end
		
		TX_2:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[1]; 
		end
		
		TX_3:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[2]; 
		end
		
		TX_4:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[3]; 
		end
		
		TX_5:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[4]; 
		end
		
		TX_6:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[5]; 
		end
		
		TX_7:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[6]; 
		end
		
		TX_8:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = tx_buffer[7];   
		end
		
		TX_9:
		begin
			tx_buffer = tx_buffer;
			tx_tbr =0;
			txd = 1; // sending the stop bit
		end
		
		endcase
	end
	
	
	*/	
		
			
			
    

    
    
