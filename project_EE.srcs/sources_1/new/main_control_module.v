`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): THURSDAY A.M.
//
//  STUDENT A NAME: ANG JIA LE MARCUS
//  STUDENT A MATRICULATION NUMBER: A0235025R
//
//  STUDENT B NAME: WILSON NG JING AN
//  STUDENT B MATRICULATION NUMBER: A0244474B
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student(
    input  CLOCK,
    input  btnC, btnL , btnR, btnU, btnD,
   // sw15 active low for Orange Bar;  sw14 active low for ALL Borders 
    input  [15:0] sw,
    input  J_MIC3_Pin3,    // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,    // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    output [0:7] JC,
    
    input  J_MIC2_Pin3,    // Connect from this signal to Audio_Capture.v
    output J_MIC2_Pin1,    // Connect to this signal from Audio_Capture.v
    output J_MIC2_Pin4,    // Connect to this signal from Audio_Capture.v
    output [0:7] JA,
    
    output [4:0] led,
    output [3:0] an,     
    output [7:0] seg
    );
    
    //******************Prep & Instantiation of requied modules**********    
    wire clk20k;
    m_clock clk_20kHz  (.CLOCK(CLOCK), .f_req(20_000), .adj_clk(clk20k));  

    wire clk6p25m;
    m_clock clk_6p25MHz   (.CLOCK(CLOCK), .f_req(6_250_000), .adj_clk(clk6p25m));      
 
//    wire clk10;
//    m_clock clk_10Hz   (.CLOCK(CLOCK), .f_req(10), .adj_clk(clk10));  
    
    //LEFT MIC AND SCREEN
    wire [11:0] mic_in1;
    wire [15:0] oled_data1; 
    wire frame_begin1, sending_pixels1, sample_pixel1; 
    wire [12:0] pixel_index1;
    wire [4:0] teststate1; 
    //RIGHT MIC AND SCREEN
    wire [11:0] mic_in2;
    reg [15:0] oled_data2; 
    wire frame_begin2, sending_pixels2, sample_pixel2; 
    wire [12:0] pixel_index2;
    wire [4:0] teststate2; 
    
    Audio_Capture audioL   (.CLK(CLOCK), .cs(clk20k), .MISO(J_MIC2_Pin3),.clk_samp(J_MIC2_Pin1), .sclk(J_MIC2_Pin4), .sample(mic_in1));  
    Audio_Capture audioR   (.CLK(CLOCK), .cs(clk20k), .MISO(J_MIC3_Pin3),.clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(mic_in2));  
    
    Oled_Display  displayL (.clk(clk6p25m), .reset(0), .frame_begin(frame_begin1), .sending_pixels(sending_pixels1), .sample_pixel(sample_pixel1)
                          , .pixel_index(pixel_index1), .pixel_data(oled_data1)
                          , .cs(JA[0]), .sdin(JA[1]), .sclk(JA[3]), .d_cn(JA[4]), .resn(JA[5]), .vccen(JA[6]),.pmoden(JA[7]), .teststate(teststate1)); 
                          
    Oled_Display  displayR (.clk(clk6p25m), .reset(0), .frame_begin(frame_begin2), .sending_pixels(sending_pixels2), .sample_pixel(sample_pixel2)
                                                , .pixel_index(pixel_index2), .pixel_data(oled_data2)
                                                , .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),.pmoden(JC[7]), .teststate(teststate2)); 
   //*********************************************************************************
   wire [11:0] noiseL;
   wire [11:0] noiseR;     //sampled noise
   wire [2:0]  noise_lv;  //noise level
   noise_sampling data_noiseL(.clk20k(clk20k), .mic_in(mic_in1), .noise(noiseL));
   noise_sampling data_noiseR(.clk20k(clk20k), .mic_in(mic_in2), .noise(noiseR));
   mapping_noise_lv update_noise_lv(.clk20k(clk20k), .noise(noiseR), .noise_lv(noise_lv));    
   
   wire [3:0] sc_lv_l, sc_lv_r;
   sc_sensor_lv sensor_L (.clk20k(clk20k), .noise(noiseL), .noise_lv(sc_lv_l));
   sc_sensor_lv sensor_R (.clk20k(clk20k), .noise(noiseR), .noise_lv(sc_lv_r));
   //***************************************************************************
  
   wire [7:0] X;
   assign X = pixel_index2 % 96;
   wire [6:0] Y;
   assign Y = pixel_index2 / 96;
   
   //***************************************************************************
   
   
   //Initial startup screen (or reboot)
   //Security lv: NORMAL(0); ALERT(1); HEIGHTEN ALERT(2); LOCKDOWN(3) 
   reg [1:0] secure_lv = 0;
   reg sc_l_trig = 0, sc_r_trig = 0;
   reg [31:0] ld_count = 0;
   reg ld_blink = 0;
   
   
   //OLED Module Display Doggy for 3secs
   
   
   //OLED Module Display MENU (LOGIN or EMERGENCY)
   //EMERGENCY BLOCK
       //DISPLAY calling FIRE STATION (7seg SEND HELP)
       
       //DISPLAY calling POLICE (7seg SEND HELP)
       
       //DISPLAY calling AMBULANCE (7seg SEND HELP)
       
       //LOCKDOWN
       //secure_lv = 3;
       
   //LOGIN BLOCK
   
   
   reg [0:31] LDBL1 = 32'b1111_1111_1111_1111_0000_0000_0000_0000;
   reg [0:31] LDBL2 = 32'b1111_1111_1111_1111_0000_0000_0000_0000;
   reg [0:31] LDBL3 = 32'b1111_1111_1111_1111_0000_0000_0000_0000; 
   reg L1 = 0, L2 = 0, L3 = 0; 
   reg [6:0] i;
   
   reg [0:31] LDBR1 = 32'b0000_0000_0000_0000_1111_1111_1111_1111;
   reg [0:31] LDBR2 = 32'b0000_0000_0000_0000_1111_1111_1111_1111;
   reg [0:31] LDBR3 = 32'b0000_0000_0000_0000_1111_1111_1111_1111; 
   reg R1 = 0, R2 = 0, R3 = 0; 
   reg [6:0] iR;
   
   reg [1:0] main_page_selection = 0;
   reg [1:0] state = 0;
   
   wire faster_clock;
   wire my_clock;
   m_clock fasterclock(.CLOCK(CLOCK), .f_req(500), .adj_clk(faster_clock));
   m_clock my_clock_1(.CLOCK(CLOCK), .f_req(12_000_000), .adj_clk(my_clock));
   
   wire clk1k;
   m_clock clk1kHz(.CLOCK(CLOCK), .f_req(1000), .adj_clk(clk1k));  
   wire clk100;
   m_clock clk100Hz(.CLOCK(CLOCK), .f_req(100), .adj_clk(clk100));  

   //*******************LOGIN*****************************************
   wire pulseR;
   single_pulse center (clk1k, btnR, pulseR);
   wire unlock, pass;
   reg  [1:0] p_wrong_x = 0;
   wire [1:0] wrong_x;   
   map_login_noise mln(.noise(noiseL), .pass(pass));
   login login(.sw(sw), .pass(pass), .clk100(clk100), .btnC(pulseR), .state(state), .unlock(unlock), .wrong_x(wrong_x));
  //*****************END OF LOGIN************************************* 
   
   
   
   //****************LOGIN LOGIC***************************************
   //if unlock == 1, go to state 2
 
   //****************END OF LOGIN LOGIC********************************
   wire S_L, S_R, RESET, M_LD;
   //START OF LEFT OLED MODULES
   seg_digits   mysegdigit(.sw(sw[2:0]), .estate(state), .CLOCK(faster_clock), .seg_dis(seg[6:0]), .an_dis(an[3:0]), .noise_lv(noise_lv), .SW13(sw[13]));
   page_display maindis(.RESET(RESET), .M_LD(M_LD) ,.S_L(S_L),.S_R(S_R), .oled_data(oled_data1), .curr_pixel_index(6144 - pixel_index1), .CLOCK(my_clock),
                        .btnU(btnU), .btnD(btnD), .main_page_level(main_page_selection), .state(state), .SW11(sw[11]), .SW12(sw[12]), .SW0(sw[0]),
                         .SW1(sw[1]), .SW2(sw[2]), .SW3(sw[3]), .SW13(sw[13]) , .SW14(sw[14]), .SW15(sw[15]),.noise_lv(noise_lv), .wrong_count(wrong_x),
                         .correct_ans(unlock));
   //END OF LEFT OLED MODULES
   led_display(.CLOCK(CLOCK), .SW13(sw[13]),.noise_lv(noise_lv), .led(led));
   
   wire clk25m;
   m_clock clk25MHz   (.CLOCK(CLOCK), .f_req(25_000_000), .adj_clk(clk25m));
   //DISPLAY DEFAULT SECURITY SYSTEM LV & SOUND SENSOR
   always @ (posedge clk25m) begin
        if(M_LD || sc_l_trig || sc_r_trig || wrong_x == 3) begin
            secure_lv <= 3;
        end else if (RESET) begin
            secure_lv <= 0;
            sc_l_trig <= 0;
            sc_r_trig <= 0;
          
        end
        //IF LOCKDOWN
        if(secure_lv == 3) begin
            if(sw == 16'b1110_1110_10_0_10_110) begin
                  secure_lv <= 0;
                  //trig reset
            end
        end
        
        if(wrong_x == 0) begin
            p_wrong_x <= 0;           
        end else if (p_wrong_x < wrong_x) begin
            if(secure_lv < 3) begin
                secure_lv <= secure_lv + 1;
            end
            p_wrong_x <= wrong_x;
        end
        
   //*************START OF LEFT OLED (2)**************************************** 
        if ((btnD == 1) && (btnU == 0) && (state == 0)) begin
            main_page_selection <= 1;
        end  else if ((btnU == 1) && (btnD == 0) && (state == 0)) begin
            main_page_selection <= 0;
        end
        
        if ((unlock) && (state == 1) && (secure_lv != 3)) begin
            state <= 2;
        end else if ((btnC == 1) && (state == 0) && (sw[0] == 0) && (sw[1] == 0) && (sw[2] == 0)) begin
            if (main_page_selection == 1) begin
                state <= 3;
            end else begin
                state <= 1;
            end
        end else if (((state == 3) || (state == 2) || (state == 1)) && (btnL == 1)) begin
            state <= 0;
        end
   //*************END OF LEFT OLED (2)****************************************
     
      
   //*************START OF RIGHT OLED (2)****************************************
        //LEFT SENSOR TRIGGERED (LOCKDOWN)
        if(sc_lv_l == 7 && !S_L && !(state >= 1 && state <= 2)) begin    //only when sw[11] is OFF => S.L ON
            sc_l_trig <= 1;   
        end 
        //RIGHT SENSOR TRIGGERED (LOCKDOWN)
        if(sc_lv_r == 7 && !S_R) begin   //only when sw[12] is OFF => S.R ON
            sc_r_trig <= 1;    
        end    
        //REBOOT SENSOR TRIGGERS (sw[10] for now)
        
        //CONTROL DISPLAY FOR TASK BARS & BORDERS (sw[x])
     //   if(!sw[7])begin
            //SENSOR LEFT BARS
            if((Y >= 30 && Y <= 39) && (X >= 19 && X <= 72)) begin
                //START OF OFF STATE LEFT
                if(S_L || state == 1) begin
                    sc_l_trig <= 0; //OFF STATE NO ALARM TRIGGERED
                    if(((Y >= 32 && Y <= 37) && (X == 32 || X == 33 || X == 38 || X == 39)) || ((X >= 34 && X <= 37) && (Y == 30 || Y == 31 || Y == 38 || Y == 39))) begin
                        oled_data2 <= 16'hffff;
                    end else if ((Y >= 30 && Y <= 39) && (X == 42 || X == 43 || X == 52 || X == 53)) begin
                        oled_data2 <= 16'hffff;
                    end else if ((Y >= 30 && Y <= 31) && ((X >= 44 && X <= 49) || (X >= 54 && X <= 59))) begin
                        oled_data2 <= 16'hffff;
                    end else if ((Y >= 34 && Y <= 35) && ((X >= 44 && X <= 47) || (X >= 54 && X <= 57))) begin
                        oled_data2 <= 16'hffff;
                    end else begin
                        oled_data2 <= 0;
                    end                        
                end //END OF OFF STATE LEFT
                //ON STATE
                else begin
                    //DEFAULT GREEN BAR (LOWEST VOLUME)
                    if((Y >= 31 && Y <= 38) && (X >= 19 && X <= 23)) begin
                        oled_data2 <= 16'b00000_111111_00000; //green
                    end 
                    //sensor right lv 1 & above               
                    else if((Y >= 31 && Y <= 38) && (X >= 26 && X <= 30)) begin
                        if(sc_lv_l > 0) begin
                            oled_data2 <= 16'h77e0; //light green
                        end 
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //sensor right lv 2 & above               
                    else if((Y >= 31 && Y <= 38) && (X >= 33 && X <= 37)) begin
                        if(sc_lv_l > 1) begin
                            oled_data2 <= 16'hbfe0; //yellow green
                        end 
                        else begin
                            oled_data2 <= 0;
                        end
                    end               
                    //sensor right lv 3 & above     
                    else if((Y >= 31 && Y <= 38) && (X >= 40 && X <= 44)) begin
                        if(sc_lv_l > 2) begin
                            oled_data2 <= 16'hffe0; //yellow 
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end                 
                    //sensor right lv 4 & above     
                    else if((Y >= 31 && Y <= 38) && (X >= 47 && X <= 51)) begin
                        if(sc_lv_l > 3) begin
                            oled_data2 <= 16'hfde0; //yellow orange 
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //sensor right lv 5 & above     
                    else if((Y >= 31 && Y <= 38) && (X >= 54 && X <= 58)) begin
                        if(sc_lv_l > 4) begin
                            oled_data2 <= 16'hfc60; //orange 
                        end
                        else begin
                            oled_data2 <= 0;
                        end 
                    end                  
                    //sensor right lv 6 & above     
                    else if((Y >= 31 && Y <= 38) && (X >= 61 && X <= 65)) begin
                        if(sc_lv_l > 5) begin
                            oled_data2 <= 16'hfa60; //redish orange 
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //sensor right lv 7 (LOCKDOWN)     
                    else if((Y >= 31 && Y <= 38) && (X >= 68 && X <= 72)) begin
                        if(sc_lv_l > 6) begin
                            oled_data2 <= 16'hf800; //red
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //REST BLACK                                                        
                    else begin
                        oled_data2 <= 0;
                    end     
                end  //END OF ON STATE
            end  //END OF LEFT SENSOR BARS
            //SENSOR RIGHT BARS
            else if((Y >= 48 && Y <= 59) && (X >= 19 && X <= 72)) begin
                //START OF ON STATE RIGHT
                if(!S_R) begin
                    //DEFAULT GREEN BAR (LOWEST VOLUME)               
                    if((Y >= 50 && Y <= 57) && (X >= 19 && X <= 23)) begin
                        oled_data2 <= 16'b00000_111111_00000; //green
                    end 
                    //sensor right lv 1 & above               
                    else if((Y >= 50 && Y <= 57) && (X >= 26 && X <= 30)) begin
                        if(sc_lv_r > 0) begin
                            oled_data2 <= 16'h77e0; //light green
                        end 
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //sensor right lv 2 & above               
                    else if((Y >= 50 && Y <= 57) && (X >= 33 && X <= 37)) begin
                        if(sc_lv_r > 1) begin
                            oled_data2 <= 16'hbfe0; //yellow green
                        end 
                        else begin
                            oled_data2 <= 0;
                        end
                    end               
                    //sensor right lv 3 & above     
                    else if((Y >= 50 && Y <= 57) && (X >= 40 && X <= 44)) begin
                        if(sc_lv_r > 2) begin
                            oled_data2 <= 16'hffe0; //yellow 
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end                 
                    //sensor right lv 4 & above     
                    else if((Y >= 50 && Y <= 57) && (X >= 47 && X <= 51)) begin
                        if(sc_lv_r > 3) begin
                            oled_data2 <= 16'hfde0; //yellow orange 
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //sensor right lv 5 & above     
                    else if((Y >= 50 && Y <= 57) && (X >= 54 && X <= 58)) begin
                        if(sc_lv_r > 4) begin
                            oled_data2 <= 16'hfc60; //orange 
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end                  
                    //sensor right lv 6 & above     
                    else if((Y >= 50 && Y <= 57) && (X >= 61 && X <= 65)) begin
                        if(sc_lv_r > 5) begin
                            oled_data2 <= 16'hfa60; //redish orange 
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //sensor right lv 7 (LOCKDOWN)     
                    else if((Y >= 50 && Y <= 57) && (X >= 68 && X <= 72)) begin
                        if(sc_lv_r > 6) begin
                            oled_data2 <= 16'hf800; //red
                        end
                        else begin
                            oled_data2 <= 0;
                        end
                    end
                    //REST BLACK                                                        
                    else begin
                        oled_data2 <= 0;
                    end       
                end // END OF ON STATE RIGHT 
                //OFF STATE
                else begin
                    sc_r_trig <= 0; //OFF STATE NO ALARM TRIGGERED
                    if(((Y >= 51 && Y <= 56) && (X == 32 || X == 33 || X == 38 || X == 39)) || ((X >= 34 && X <= 37) && (Y == 49 || Y == 50 || Y == 57 || Y == 58))) begin
                        oled_data2 <= 16'hffff;
                    end else if ((Y >= 49 && Y <= 58) && (X == 42 || X == 43 || X == 52 || X == 53)) begin
                        oled_data2 <= 16'hffff;
                    end else if ((Y >= 49 && Y <= 50) && ((X >= 44 && X <= 49) || (X >= 54 && X <= 59))) begin
                        oled_data2 <= 16'hffff;
                    end else if ((Y >= 53 && Y <= 54) && ((X >= 44 && X <= 47) || (X >= 54 && X <= 57))) begin
                        oled_data2 <= 16'hffff;
                    end else begin
                        oled_data2 <= 0;
                    end 
                end  //END OF OFF STATE RIGHT    
            end  //END OF SENSOR RIGHT BARS
            //WARNING BARS            
            else if(Y >= 0 && Y <= 5) begin
                if (secure_lv == 3) begin
                    for(i = 0; i < 32; i = i + 1)begin
                        if(X == i)begin
                            if(LDBL1[i] == 1) begin
                                oled_data2 <= 16'B11111_111111_00000;  //YELLOW                      
                            end else begin
                                oled_data2 <= 0;
                            end
                        end
                    end            
                    for(i = 0; i < 32; i = i + 1)begin
                        if(X == i + 32)begin
                            if(LDBL2[i] == 1) begin
                                oled_data2 <= 16'B11111_111111_00000;  //YELLOW                      
                            end else begin
                                oled_data2 <= 0;
                            end
                        end
                    end                
                    for(i = 0; i < 32; i = i + 1)begin
                        if(X == i + 64)begin
                            if(LDBL3[i] == 1) begin
                                oled_data2 <= 16'B11111_111111_00000;  //YELLOW                      
                            end else begin
                                oled_data2 <= 0;
                            end
                        end
                    end
                    L1       <= LDBL1[31];  L2       <= LDBL2[31];  L3       <= LDBL3[31];  
                    LDBL1    <= LDBL1 >> 1; LDBL2    <= LDBL2 >> 1; LDBL3    <= LDBL3 >> 1;
                    LDBL1[0] <= L3;         LDBL2[0] <= L1;         LDBL3[0] <= L2;           
                end 
                //sw[3] - NON-LOCKDOWN MODE 
                else begin
                    oled_data2 <= 0;
                end              
            end
            else if(Y >= 19 && Y <= 23) begin
                if (secure_lv == 3) begin
                    for(iR = 0; iR < 32; iR = iR + 1)begin
                        if(X == iR)begin
                            if(LDBR1[iR] == 1) begin
                                oled_data2 <= 16'B11111_111111_00000;  //YELLOW                      
                            end else begin
                                oled_data2 <= 0;
                            end
                        end
                    end            
                    for(iR = 0; iR < 32; iR = iR + 1)begin
                        if(X == iR + 32)begin
                            if(LDBR2[iR] == 1) begin
                                oled_data2 <= 16'B11111_111111_00000;  //YELLOW                      
                            end else begin
                                oled_data2 <= 0;
                            end
                        end
                    end                
                    for(iR = 0; iR < 32; iR = iR + 1)begin
                        if(X == iR + 64)begin
                            if(LDBR3[iR] == 1) begin
                                oled_data2 <= 16'B11111_111111_00000;  //YELLOW                      
                            end else begin
                                oled_data2 <= 0;
                         end
                    end
                end
                    R1        <= LDBR1[0];   R2        <= LDBR2[0];   R3        <= LDBR3[0];  
                    LDBR1     <= LDBR1 << 1; LDBR2     <= LDBR2 << 1; LDBR3     <= LDBR3 << 1;
                    LDBR1[31] <= R2;         LDBR2[31] <= R3;         LDBR3[31] <= R1;           
                end 
                //sw[3] - NON-LOCKDOWN MODE 
                else begin
                    oled_data2 <= 0;
                end              
            end   //END OF WARNING BARS       
            //SECURITY LEVEL: NORMAL/ALERT/H.ALERT/LOCKDOWN
            else if (Y >= 7 && Y <= 16) begin
                //Print NORMAL IN GREEN
                if (secure_lv == 0) begin
                    if(X == 16 || X == 17 || X == 22 || X == 23 ||((Y >= 9 && Y <= 10) && (X == 18|| X == 19)) || ((Y >= 11 && Y <= 12) && (X == 20|| X == 21))) begin
                        oled_data2 <= 16'b00000_111111_00000; //green
                    end else if (((X >= 28 && X <= 31) && (Y == 7|| Y == 8 || Y == 15 || Y == 16)) || ((Y >= 9 && Y <= 14) && (X == 26 || X == 27 || X == 32 || X == 33))) begin
                        oled_data2 <= 16'b00000_111111_00000; //green                
                    end else if (X == 36 || X == 37 || ((X >= 38 && X <= 41) && (Y == 7|| Y == 8 || Y == 11|| Y == 12)) || ((Y >= 13 && Y <= 14) && (X == 40|| X == 41)) || ((X >= 42 && X <= 43) && (Y == 9 || Y == 10 || Y == 15 || Y == 16))) begin
                        oled_data2 <= 16'b00000_111111_00000; //green                
                    end else if (X == 46 || X == 47 || X == 54 || X == 55 ||((Y >= 9 && Y <= 10) && (X == 48|| X == 49 || X == 52 || X == 53)) || (Y >= 11 && Y <= 12) && (X == 50|| X == 51)) begin
                        oled_data2 <= 16'b00000_111111_00000; //green
                    end else if ((Y >= 9 && Y <= 16) && (X == 58|| X == 59 || X == 64 || X == 65) || (X >= 60 && X <= 63) && (Y == 7|| Y == 8 || Y == 11 || Y == 12)) begin
                        oled_data2 <= 16'b00000_111111_00000; //green                
                    end else if (X == 68 || X == 69 || (X >= 70 && X <= 75) && (Y == 15|| Y == 16)) begin
                        oled_data2 <= 16'b00000_111111_00000; //green                   
                    end else begin
                        oled_data2 <= 0; //rest black                  
                    end
                end 
                //PRINT ALERT IN YELLOW
                else if (secure_lv == 1) begin
                    if (((Y >= 9 && Y <= 16) && (X == 23|| X == 24 || X == 29 || X == 30)) || ((X >= 25 && X <= 28) && (Y == 7|| Y == 8 || Y == 11 || Y == 12))) begin
                        oled_data2 <= 16'b11111_111111_00000; //yellow                     
                    end else if (X == 33 || X == 34 || X == 43 || X == 44 || X == 53 || X == 54 || X == 67 || X == 68) begin
                        oled_data2 <= 16'b11111_111111_00000; //yellow                     
                    end else if (((X >= 35 && X <= 40) && (Y == 15|| Y == 16)) || ((X >= 45 && X <= 50) && (Y == 7 || Y == 8 || Y == 15|| Y == 16)) || ((X >= 45 && X <= 48) && (Y == 11|| Y == 12))) begin
                        oled_data2 <= 16'b11111_111111_00000; //yellow                
                    end else if (((X >= 55 && X <= 58) && (Y == 7|| Y == 8 || Y == 11 || Y == 12)) || ((X >= 57 && X <= 58) && (Y == 13|| Y == 14)) || ((X >= 59 && X <= 60) && (Y == 9 || Y == 10 || Y == 15|| Y == 16))) begin
                        oled_data2 <= 16'b11111_111111_00000; //yellow                  
                    end else if (((X >= 63 && X <= 72) && (Y == 7|| Y == 8))) begin
                        oled_data2 <= 16'b11111_111111_00000; //yellow                         
                    end else begin
                        oled_data2 <= 0; //rest black
                    end                
                end 
                //PRINT H.ALERT(HEIGHTEN ALERT) IN ORANGE
                else if (secure_lv == 2) begin
                    if(X == 15 || X == 16 || X == 21 || X == 22 || X == 43 || X == 44 || X == 53 || X == 54 || X == 63 || X == 64 || X == 77 || X == 78) begin
                        oled_data2 <= 16'b11111_011100_00000; //orange                          
                    end else if (((X >= 17 && X <= 20) && (Y == 11|| Y == 12)) || ((X >= 27 && X <= 28) && (Y == 15|| Y == 16))) begin
                        oled_data2 <= 16'b11111_011100_00000; //orange                 
                    end else if (((X >= 35 && X <= 38) && (Y == 7|| Y == 8 || Y == 11 || Y == 12)) || ((Y >= 9 && Y <= 16) && (X == 33|| X == 34 || X == 39 || X == 40))) begin
                        oled_data2 <= 16'b11111_011100_00000; //orange                 
                    end else if (((X >= 45 && X <= 50) && (Y == 15|| Y == 16)) || ((X >= 55 && X <= 60) && (Y == 7|| Y == 8 || Y == 15 || Y == 16)) || ((X >= 55 && X <= 58) && (Y == 11|| Y == 12))) begin
                        oled_data2 <= 16'b11111_011100_00000; //orange                 
                    end else if (((X >= 65 && X <= 68) && (Y == 7|| Y == 8 || Y == 11 || Y == 12)) || ((X >= 67 && X <= 68) && (Y == 13|| Y == 14)) || ((X >= 69 && X <= 70) && (Y == 9|| Y == 10 || Y == 15 || Y == 16))) begin
                        oled_data2 <= 16'b11111_011100_00000; //orange                 
                    end else if (((X >= 73 && X <= 82) && (Y == 7|| Y == 8))) begin
                        oled_data2 <= 16'b11111_011100_00000; //orange                
                    end else begin
                        oled_data2 <= 0; //rest black
                    end
                end
                //ADD WHEN NOT LOCKDOWN STATE (NORMAL-H.ALERT) RESET ld_count TO 0
                //PRINT LOCKDOWN IN RED
                else if (secure_lv == 3) begin  //sw[3] simulate lockdown status
                    if (ld_count == 1_562_500) begin  //every 0.25s toggle
                        ld_blink <= ~ld_blink;                    
                        ld_count <= 0;
                    end else begin
                        ld_count <= ld_count + 1;
                    end
                    
                    if (ld_blink) begin
                        if (X == 8 || X == 9 || X == 38 || X == 39 || X == 48 || X == 49 || X == 68 || X == 69 || X == 76 || X == 77 || X == 80 || X == 81 || X == 86 || X == 87) begin
                            oled_data2 <= 16'b11111_000000_00000; //red                  
                        end else if (((X >= 10 && X <= 15) && (Y == 15|| Y == 16))) begin
                            oled_data2 <= 16'b11111_000000_00000; //red   
                        end else if (((Y >= 9 && Y <= 14) && (X == 18|| X == 19 || X == 24 || X == 25 || X == 28 || X == 29 || X == 54 || X == 55 || X == 58 || X == 59 || X == 64 || X == 65))) begin
                            oled_data2 <= 16'b11111_000000_00000; //red   
                        end else if (((X >= 20 && X <= 23) && (Y == 7|| Y == 8 || Y == 15 || Y == 16)) || ((X >= 30 && X <= 33) && (Y == 7|| Y == 8 || Y == 15 || Y == 16)) || ((X >= 34 && X <= 35) && (Y == 9 || Y == 10 || Y == 13 || Y == 14))) begin
                            oled_data2 <= 16'b11111_000000_00000; //red   
                        end else if (((Y >= 11 && Y <= 12) && (X == 40|| X == 41 || X == 72 || X == 73 || X == 84 || X == 85))) begin
                            oled_data2 <= 16'b11111_000000_00000; //red   
                        end else if (((X >= 42 && X <= 43) && (Y == 9|| Y == 10 || Y == 13 || Y == 14)) || ((X >= 44 && X <= 45) && (Y == 7|| Y == 8 || Y == 15 || Y == 16))) begin
                            oled_data2 <= 16'b11111_000000_00000; //red   
                        end else if (((X >= 50 && X <= 53) && (Y == 7|| Y == 8 || Y == 15 || Y == 16)) || ((X >= 60 && X <= 63) && (Y == 7|| Y == 8 || Y == 15 || Y == 16))) begin
                            oled_data2 <= 16'b11111_000000_00000; //red   
                        end else if (((Y >= 13 && Y <= 14) && (X == 70|| X == 71 || X == 74 || X == 75)) || ((X >= 82 && X <= 83) && (Y == 9|| Y == 10))) begin
                            oled_data2 <= 16'b11111_000000_00000; //red   
                        end else begin
                            oled_data2 <= 0; //rest black
                        end
                    end else begin
                        oled_data2 <= 0;
                    end  //END OF BLINKING LOCKDOWN DISPLAY
                end //END OF LOCKDOWN            
                else begin
                    oled_data2 <= 0; //rest black                 
                end            
            end
            //S.L & S.R LABELS (SENSOR LEFT AND RIGHT)
            else if (((Y >= 33 && Y <= 37) || (Y >= 52 && Y <= 56)) && (X >= 1 && X <= 13)) begin
                if((X == 1 && (Y == 34 || Y == 37 || Y == 53 || Y == 56))) begin
                    oled_data2 <= 16'b11111_111111_11111; //white  
                end else if (((X >= 2 && X <= 3) && (Y == 33|| Y == 35 || Y == 37 || Y == 52 || Y == 54 || Y == 56))) begin
                    oled_data2 <= 16'b11111_111111_11111; //white  
                end else if (((X == 4) && (Y == 33|| Y == 36 || Y == 52 || Y == 55))) begin
                    oled_data2 <= 16'b11111_111111_11111; //white  
                end else if ((X == 7) && (Y == 37 || Y == 56)) begin
                    oled_data2 <= 16'b11111_111111_11111; //white  
                end else if (((Y >= 33 && Y <= 37) && (X == 10)) || ((X >= 11 && X <= 13) && (Y == 37))) begin
                    oled_data2 <= 16'b11111_111111_11111; //white  
                end else if (((Y >= 52 && Y <= 56) && (X ==10)) || ((X >= 11 && X <= 12) && (Y == 52|| Y == 54))) begin
                    oled_data2 <= 16'b11111_111111_11111; //white  
                end else if ((X == 12 && Y == 55) || (X == 13 && (Y == 53 || Y == 56))) begin
                    oled_data2 <= 16'b11111_111111_11111; //white  
                end else begin
                    oled_data2 <= 0; //rest black
                end          
            end
            //S.L & S.R BORDERS
            else if ((X >= 15 && X <= 76) && (Y == 27 || Y == 28 || Y == 41 || Y == 42 || Y == 46 || Y == 47 || Y == 60 || Y == 61)) begin
                oled_data2 <= 16'b11111_111111_11111; //white          
            end else if (((Y >= 27 && Y <= 42) && (X >= 15 && X <= 16 || X == 75 || X == 76)) || ((Y >= 46 && Y <= 61) && (X >= 15 && X <= 16 || X == 75 || X == 76))) begin
                oled_data2 <= 16'b11111_111111_11111; //white          
            end
            // '!' ICON FOR S.L
            else if ((Y >= 27 && Y <= 42) && (X >= 79 && X <= 92)) begin
                if (sc_l_trig) begin
                    if (((Y >= 31 && Y <= 38) && (X == 79 || X == 80 || X == 91 || X == 92))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red                 
                    end else if (((X >= 83 && X <= 88) && (Y == 27 || Y == 28 || Y == 41 || Y == 42))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red 
                    end else if (((Y >= 29 && Y <= 30) && (X == 81 || X == 82 || X == 89 || X == 90)) || ((Y >= 39 && Y <= 40) && (X == 81 || X == 82 || X == 89 || X == 90))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red 
                    end else if (((Y >= 30 && Y <= 36) && (X == 85 || X == 86)) || ((Y >= 38 && Y <= 39) && (X == 85 || X == 86))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red 
                    end else begin
                        oled_data2 <= 0; //rest black
                    end
                end else begin
                    oled_data2 <= 0; //LEFT SENSOR NOT TRIGGERED
                end
            end
            // '!' ICON FOR S.R
            else if ((Y >= 46 && Y <= 61) && (X >= 79 && X <= 92)) begin
                if (sc_r_trig) begin
                    if (((Y >= 50 && Y <= 57) && (X == 79 || X == 80 || X == 91 || X == 92))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red                 
                    end else if (((X >= 83 && X <= 88) && (Y == 46 || Y == 47 || Y == 60 || Y == 61))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red 
                    end else if (((Y >= 48 && Y <= 49) && (X == 81 || X == 82 || X == 89 || X == 90)) || ((Y >= 58 && Y <= 59) && (X == 81 || X == 82 || X == 89 || X == 90))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red 
                    end else if (((Y >= 49 && Y <= 55) && (X == 85 || X == 86)) || ((Y >= 57 && Y <= 58) && (X == 85 || X == 86))) begin
                        oled_data2 <= 16'b11111_000000_00000; //red 
                    end else begin
                        oled_data2 <= 0; //rest black
                    end
                end else begin
                    oled_data2 <= 0; //LEFT SENSOR NOT TRIGGERED
                end        
            end
            //MAIN BLOCK DEFAULT BLACK
            else begin
                oled_data2 <= 0;
            end
  //  end 
    //DISPLAY RIGHT (SC_LV; SOUND SENSOR LEFT & RIGHT; LOCKDOWN BARS) 
//    else begin
//        if(noise_lv == 0) begin
//            oled_data2 <= 0;       //black screen
//        end
//        //NOISE LV > 0
//        else begin
//            if (X > 18 && X < 77) begin
//                if (Y > 13 && Y < 51)
//                oled_data2 <= 16'b00000_111111_000000;       
//            end else
//            //Green Border
//            if(((Y == 1 || Y == 62) && (X >= 1 && X <= 94) || ((X == 1 || X == 94) && (Y >= 2 && Y <= 61))) && sw[14] == 0)begin
//                oled_data2 <= 16'b00000_111111_00000;   //Green 
//            end else begin
//                oled_data2 <= 0;  
//            end        
        
//            //At this point, the green bar has already been set to display in the OLED and the default case has been
//            //defined (7 segment and LED). The code below will add and edit the display based on the noise level.
//            if ((noise_lv == 3) || (noise_lv == 4) || (noise_lv == 5)) begin
//                if ((X > 18 && X < 77 && Y > 27 && Y < 37) && (noise_lv == 5)) begin
//                    oled_data2 <= 16'b11111_000000_00000;    //Red Bar
//                end else if ((!sw[14] && (((Y >= 5 && Y <= 7) || (Y <= 58 && Y >= 56)) && (X >= 5 && X <= 90) || 
//                (((X >= 5 && X <= 7) || (X <= 90 && X >= 88)) && (Y >= 6 && Y <= 57)))) && (noise_lv == 5)) begin
//                    oled_data2 <= 16'b11111_000000_00000;    //Red Border
//                end else if (!sw[15] && (X > 18 && X < 77 && Y > 20 && Y < 44)) begin
//                    oled_data2 <= 16'b11111_100011_00000;   //Orange Bar
//                end else if (!sw[14] && ((Y == 3 || Y == 60) && (X >= 3 && X <= 92) || ((X == 3 || X == 92) && (Y >= 4 && Y <= 59)))) begin
//                    oled_data2 <= 16'b11111_100011_00000;   //Orange Border
//                end else if (X > 18 && X < 77) begin
//                    if (Y > 13 && Y < 51)
//                        oled_data2 <= 16'b00000_111111_000000; //Green Bar
//                end else if(((Y == 1 || Y == 62) && (X >= 1 && X <= 94) || ((X == 1 || X == 94) && (Y >= 2 && Y <= 61))) && sw[14] == 0) begin
//                    oled_data2 <= 16'b00000_111111_00000;    //Green Border    
//                end else begin
//                    oled_data2 <= 0;                         //Black 
//                end
                          
//            end  
//        end
//    end   //END OF SW[7]
   //*************END OF RIGHT OLED (2)****************************************
end    //END OF ALWAYS BLOCK
endmodule

