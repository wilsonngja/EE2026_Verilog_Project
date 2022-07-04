`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2022 17:02:34
// Design Name: 
// Module Name: noise_sampling
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


module noise_sampling(input clk20k, input [11:0] mic_in, output reg [11:0] noise = 0);
    reg [11:0] count      = 0;
    reg [11:0] curr_peak  = 0;   
    always @ (posedge clk20k) begin   //50microsecs period
        count <= count + 1;
        if(curr_peak < mic_in) begin
            curr_peak <= mic_in; 
        end
        if(count == 1999) begin   //0.1s interval
            noise     <= curr_peak;
            curr_peak <= 0;
            count     <= 0;
        end 
    end
endmodule
