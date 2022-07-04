`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2022 20:20:38
// Design Name: 
// Module Name: led_display
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


module led_display(input CLOCK, input SW13,input [2:0] noise_lv, output reg [4:0] led = 0);
    always @ (posedge CLOCK) begin
        if(SW13) begin
            if(noise_lv == 0) begin
                led <= 0;
            end
            else if(noise_lv == 1) begin
                led <= 1;
            end
            //noise_lv 2         
            else if(noise_lv == 2) begin
                led <= 5'b00011;        
            end                  
            else if (noise_lv == 3) begin
                led <= 5'b00111;
            end 
            else if (noise_lv == 4) begin
                led <= 5'b01111;
            end 
            else begin
                led <= 5'b11111;
            end
        end // END OF SW13 
        
        //START OF NOT SW13
        else begin
        
        end //END OF NOT SW13
    end //END OF ALWAYS BLOCK
endmodule
