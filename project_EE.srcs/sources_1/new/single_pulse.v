`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 11:27:18
// Design Name: 
// Module Name: single_pulse
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


module single_pulse(input clk1k, input btn, output reg pulse);
    reg btn_release      = 1;     //'1' for button release state; Otherwise '0' 
    reg detect           = 1;     //'1' for detection mode; '0' for stop detection
    reg [6:0] count_d    = 0;
    reg [4:0] count_high = 0;
    reg pulse_high       = 0;     //'1' to pulse HIGH, '0' otherwise
    
    always @ (posedge clk1k) begin
        if(pulse_high == 1) begin    //output 10ms HIGH
            pulse <= 1;
            if(count_high == 9)begin
                detect <= 0;
                count_high <= 0;
                pulse_high <= 0;
            end else begin
                count_high <= count_high + 1;
            end
        end
        
        if(detect == 1) begin
            if (btn == 1) begin
                if(btn_release == 1) begin
                    pulse_high <= 1;
                end
                btn_release <= 0;
            end else begin
                btn_release <= 1;
            end        
        end else begin //cooldown 50ms when detect is '0'
            pulse <= 0;
            if(count_d == 49) begin
                detect  <= 1;
                count_d <= 0;
            end else begin
                count_d <= count_d + 1;
            end       
        end
    end
endmodule
