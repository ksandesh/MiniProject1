`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team 3
// Engineer: Chandana, Sandesh, Albert
// 
// Create Date: 	Sept 13, 2014
// Design Name: 	RX
// Module Name:    	RX 
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

module RX(
	input clk,
    input rx_enable,
    input rst,
	input read,
    output reg rda,  
    output reg [7:0] rx_out,
    input rxd
    );
    
    
    reg [ 7:0] rx_buffer;
    reg [ 7:0] rx_shift_reg;
    reg        rx_start;
    reg        rx_sample1;
    reg        rx_sample2;
    reg [ 3:0] rx_index;                  		// rx_cnt 
    reg [ 3:0] rx_enable_counter;               // rx_sample_cnt is rx_enable_counter;
    reg        rx_error;
    reg        rx_over_run;
   
     
    
    always@(posedge clk, posedge rst) begin
		if(rst) begin
		//	rx_buffer    <= 0;
			rx_shift_reg <= 8'b11111111;
			rx_sample1   <= 1;
			rx_sample2   <= 1;
			rx_index     <= 0;                  // rx_cnt 
			rx_enable_counter <= 0;               // rx_sample_cnt is rx_enable_counter;
			rx_start     <= 0;
			rx_error     <= 0;
			rx_out <= 0;
			rda <= 0;
 		end
		else if(read) begin
			rx_out <= rx_shift_reg;
			rda <= 0;
		end 
		else if(rx_enable) begin
		
			rx_sample1 <= rxd;   		// Load input rxd to 
			rx_sample2 <= rx_sample1;  	// double flop
          
			if( (rx_start == 0) && (rx_sample2 == 0) ) begin  // start bit detected
				rx_start <= 1'b1;
				rx_enable_counter <= 1;
				rx_index <= 0;
			end
              
            // Start bit is detected
			if( rx_start == 1) begin
				rx_enable_counter <= rx_enable_counter + 1;
                 
				// Shift data to the right. Assumption LSB is received first
				if( rx_enable_counter == 7 ) begin
					rx_index <= rx_index + 1;
					if( (rx_index > 0) && (rx_index < 9) ) begin
						rx_shift_reg[7:0] <= { rx_sample2, rx_shift_reg[7:1]};
					end                
					else if( rx_index == 9) begin
						rx_index <= 0;
                        rx_start <= 0;
						if ( rx_sample2 != 1) begin // check if the end of transmit is received without error
							rda <= 0;
							rx_error <= 1;
						end
						else begin
							rda <= 1;   // data is available for read
							rx_error <= 0;
							rx_over_run <= (rda)? 1: 0;
						end
					end
                end
					/*
                    else begin
                        rx_index <= rx_index + 1;
                    end
                     */
            end
		end
		
	end
	
endmodule

