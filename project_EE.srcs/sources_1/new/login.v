`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 11:21:39
// Design Name: 
// Module Name: login
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


module login(input [15:0] sw, input pass, input clk100, input btnC, input [1:0] state, output reg unlock = 0, output reg [1:0] wrong_x = 0);

    always @ (posedge clk100) begin
        if(sw == 16'b1110_1110_10_0_10_110) begin
            wrong_x <= 0;
        end
       
        //LOGIN PAGE BUT LOCKED STATE (STATE1 -> STATE2)
        if(state == 1 && unlock == 0) begin
            //unlock
            if (btnC) begin
                if(pass) begin
                    unlock <= 1;
                    wrong_x <= 0;
                end else begin
                    if(wrong_x <3) begin
                        wrong_x <= wrong_x + 1;
                    end               
                end
            end
        end 
        //LOGOUT
        else if (state == 0) begin
            unlock  <= 0;
        end 
    end

endmodule
