`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2022 18:50:15
// Design Name: 
// Module Name: seg_digits
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


module seg_digits(input [2:0]sw, input [1:0] estate, input CLOCK, input SW13, input [2:0] noise_lv, output reg [6:0] seg_dis = 7'b1111111, output reg [3:0] an_dis = 4'b1111);
    
    reg [11:0] counter = 0;
    reg [2:0] state = 0;
    always @(posedge CLOCK) begin
        if (SW13) begin
            if(noise_lv == 0) begin
                an_dis  <= 4'b1110;
                seg_dis <= 7'b100_0000;               
            end
            else if(noise_lv == 1) begin
                an_dis  <= 4'b1110;
                seg_dis <= 7'b111_1001;
            end
            //noise_lv 2         
            else if(noise_lv == 2) begin
                an_dis  <= 4'b1110;
                seg_dis <= 7'b010_0100;        
            end                  
            else if (noise_lv == 3) begin
                an_dis  <= 4'b1110;
                seg_dis <= 7'b011_0000;
            end 
            else if (noise_lv == 4) begin
                an_dis  <= 4'b1110;
                seg_dis <= 7'b001_1001;
            end 
            else begin
                an_dis  <= 4'b1110;
                seg_dis <= 7'b001_0010;
            end
        end 
       // END OF SW13 
        else begin
        
        if (estate == 3 && (sw[0] || sw[1] || sw[2])) begin
        //SEND
                if (counter <= 200) begin
                        case(state)
                            0:  begin
                                    seg_dis[6:0] <= 7'b0100001;
                                    an_dis[3:0] <= 4'b1110;
                                end
                            1:  begin
                                    seg_dis[6:0] <= 7'b0101011;
                                    an_dis[3:0] <= 4'b1101;
                                end
                            2:  begin
                                    seg_dis[6:0] <= 7'b0000110;
                                    an_dis[3:0] <= 4'b1011;
                                end
                            3:  begin
                                    seg_dis[6:0] <= 7'b0010010;
                                    an_dis[3:0] <= 4'b0111;
                                end
                        endcase
                        
                //END_        
                end  else if (counter <= 400) begin
                      case(state)
                            0: begin
                                    seg_dis[6:0] <= 7'b1111111;
                                    an_dis[3:0] <= 4'b1110;
                               end
                            1: begin
                                    seg_dis[6:0] <= 7'b0100001;
                                    an_dis[3:0] <= 4'b1101;
                               end
                            2: begin
                                    seg_dis[6:0] <= 7'b0101011;
                                    an_dis[3:0] <= 4'b1011;
                               end
                            3: begin
                                    seg_dis[6:0] <= 7'b0000110;
                                    an_dis[3:0] <= 4'b0111;
                               end
                       endcase
                end
                        
        
                //ND_H          
                else if (counter <= 600) begin
                    case(state)
                        1:  begin
                                        seg_dis[6:0] <= 7'b0001011;
                                        an_dis[3:0] <= 4'b1110;
                                     end
                        2:  begin
                                        seg_dis[6:0] <= 7'b1111111;
                                        an_dis[3:0] <= 4'b1101;
                                     end
                        3:  begin
                                        seg_dis[6:0] <= 7'b0100001;
                                        an_dis[3:0] <= 4'b1011;
                                     end
                        4:  begin
                                        seg_dis[6:0] <= 7'b0101011;
                                        an_dis[3:0] <= 4'b0111;
                                     end
                    endcase    
                end 
                
                //D_HE
                else if (counter <= 800) begin
                    case(state)
                        1:  begin
                                        seg_dis[6:0] <= 7'b0000110;
                                        an_dis[3:0] <= 4'b1110;
                                     end
                        2:  begin
                                        seg_dis[6:0] <= 7'b0001011;
                                        an_dis[3:0] <= 4'b1101;
                                     end
                        3:  begin
                                        seg_dis[6:0] <= 7'b1111111;
                                        an_dis[3:0] <= 4'b1011;
                                     end
                        4:  begin
                                        seg_dis[6:0] <= 7'b0100001;
                                        an_dis[3:0] <= 4'b0111;
                                     end
                    endcase
                end 
                
                //_HEL
                else if (counter <= 1000) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b1000111;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b0000110;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b0001011;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase        
                end
                
                //HELP
                else if (counter <= 1200) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b0001100;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b1000111;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b0000110;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b0001011;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase
                end
                //ELP_
                else if (counter <= 1400) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b0001100;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b1000111;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b0000110;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase
                end
                
                //LP__
                else if (counter <= 1600) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b0001100;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b1000111;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase
                end
                
                //P___
                else if (counter <= 1800) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b0001100;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase
                end
                
                //____
                else if (counter <= 2000) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase
                end
                
                
                //___S
                else if (counter <= 2200) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b0010010;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase
                end
                
                //__SE
                else if (counter <= 2400) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b0000110;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b0010010;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase
                end
                
                //_SEN
                else if (counter <= 2600) begin
                    case(state)
                        1:  begin
                                seg_dis[6:0] <= 7'b0101011;
                                an_dis[3:0] <= 4'b1110;
                            end
                        2:  begin
                                seg_dis[6:0] <= 7'b0000110;
                                an_dis[3:0] <= 4'b1101;
                            end
                        3:  begin
                                seg_dis[6:0] <= 7'b0010010;
                                an_dis[3:0] <= 4'b1011;
                            end
                        4:  begin
                                seg_dis[6:0] <= 7'b1111111;
                                an_dis[3:0] <= 4'b0111;
                            end
                    endcase           

                end else begin
                    counter = 0;
                end                       
        
               
                state <= state + 1;
                counter <= counter + 1;
         end //END OF ESTATE
         //DONT DISPLAY
         else begin
                an_dis  <= 4'b1111;
                seg_dis <= 7'b1111111;
         end                 
        end  // END OF OFF sw[13]
 end //END ALWAYS BLOCK
endmodule
