`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2022 10:01:20
// Design Name: 
// Module Name: m_clock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module m_clock(input CLOCK, input [31:0] f_req, output reg adj_clk = 0);
    reg  [31:0] count = 0;
    wire [31:0] m = (100_000_000/(2*f_req)) - 1;
    
    always @ (posedge CLOCK) begin
        count <= (count == m) ? 0 : count + 1;
        adj_clk <= (count == 0) ? ~adj_clk : adj_clk;
    end
endmodule
