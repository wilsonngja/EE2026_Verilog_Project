`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2022 16:33:34
// Design Name: 
// Module Name: sc_sensor_lv
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


module sc_sensor_lv(input clk20k, input [11:0] noise, output reg [3:0] noise_lv = 0);
    //Mapping noise to volume level 0 to 7
    parameter [11:0] base     = 2304;
    parameter [11:0] interval = 256;
    always @ (posedge clk20k) begin 
        if(noise < base) begin
            noise_lv <= 0;
        end else if (noise < (base + interval)) begin
            noise_lv <= 1;
        end else if (noise < (base + 2*interval)) begin
            noise_lv <= 2;
        end else if (noise < (base + 3*interval)) begin
            noise_lv <= 3;
        end else if (noise < (base + 4*interval)) begin
            noise_lv <= 4;
        end else if (noise < (base + 5*interval)) begin
            noise_lv <= 5;
        end else if (noise < (base + 6*interval)) begin
            noise_lv <= 6;
        end else begin
            noise_lv <= 7;
        end
    end


endmodule
