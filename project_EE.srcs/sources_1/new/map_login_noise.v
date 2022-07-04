`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 11:36:53
// Design Name: 
// Module Name: map_login_noise
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


module map_login_noise(input [11:0] noise, output pass);
    parameter lb = 3192;
    parameter ub = 4095;

    assign pass = (noise >= lb && noise <= ub) ? 1 : 0;

endmodule
