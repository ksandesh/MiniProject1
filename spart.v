`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
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
module spart(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );
	
reg read, write, load_high, load_low;
wire [7:0] rx_out;

RX RX1(
	.clk(clk),
	.rst(rst),
	.rda(rda),
	.rx_out(rx_out),
	.rxd(rxd),
	.read(read),
	.rx_enable(rx_enable)
        );

TX TX1(
	.clk(clk),
	.rst(rst),
	.txd(txd),
	.tx_in(databus),
	.tbr(tbr),
	.write(write),
	.tx_enable(tx_enable)
        );
	
brg brg1(
	.clk(clk),
    .rst(rst),				
    .load_low(load_low),			
	.load_high(load_high),		
	.data_in(databus),		
	.rx_enable(rx_enable),
	.tx_enable(tx_enable)
		);

		
assign databus = (iorw) ? rx_out : 8'bzzzzzzzz ;

always@(*) begin
	read = 0;
	write = 0;
	load_low = 0;
	load_high = 0;
		case({ioaddr,iocs,iorw})
		4'b1110: load_high = 1;	
		4'b1010: load_low = 1;
		4'b0010: write = 1;
		4'b0011: read = 1;
			default:  ;
		endcase
end


endmodule