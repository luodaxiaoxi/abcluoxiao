
module CHX_OUT_CTRL (
    input                               clk                        ,
    input                               rst_n                      ,

    input              [   7:0]         ch0_data_in                ,
    input                               ch0_sop_in                 ,
    input                               ch0_eop_in                 ,
    input                               ch0_qos_in                 ,

    input              [   7:0]         ch1_data_in                ,
    input                               ch1_sop_in                 ,
    input                               ch1_eop_in                 ,
    input                               ch1_qos_in                 ,

    input              [   7:0]         ch2_data_in                ,
    input                               ch2_sop_in                 ,
    input                               ch2_eop_in                 ,
    input                               ch2_qos_in                 ,

    input              [   7:0]         ch3_data_in                ,
    input                               ch3_sop_in                 ,
    input                               ch3_eop_in                 ,
    input                               ch3_qos_in                 ,

    input              [   7:0]         ch4_data_in                ,
    input                               ch4_sop_in                 ,
    input                               ch4_eop_in                 ,
    input                               ch4_qos_in                 ,

    input              [   7:0]         ch5_data_in                ,
    input                               ch5_sop_in                 ,
    input                               ch5_eop_in                 ,
    input                               ch5_qos_in                 ,

    input              [   7:0]         ch6_data_in                ,
    input                               ch6_sop_in                 ,
    input                               ch6_eop_in                 ,
    input                               ch6_qos_in                 ,

    input              [   7:0]         ch7_data_in                ,
    input                               ch7_sop_in                 ,
    input                               ch7_eop_in                 ,
    input                               ch7_qos_in                 ,

    //parameter
    input              [   2:0]         chx_id_in                  ,

    //OUTPUT Interface 
    output reg         [   7:0]         chx_data_out               ,
    output reg                          chx_sop_out                ,
    output reg                          chx_eop_out                ,
    output reg                          chx_qos_out                ,
    output reg                          chx_data_vld               ,
    output reg         [   2:0]         chx_id_out                 ,
    output                              chx_out_incr               ,

    input              [   7:0]         rr_req                     ,
    output             [   7:0]         rr_ack                      
);

//reg or wire 
reg                                     enable                     ;
wire                   [   7:0]         grant                      ;
reg                                     send_data_vld              ;
reg                    [   7:0]         grant_hold                 ;
reg                    [   7:0]         ch_select                  ;
reg                    [   7:0]         rr_req_ff1                 ;

//ire                   [   7:0]         wire_chx_data_out          ;
//ire                                    wire_chx_sop_out           ;
//ire                                    wire_chx_eop_out           ;
//ire                                    wire_chx_qos_out           ;
//ire                                    wire_chx_data_vld          ;
//ire                                    wire_chx_id_out            ;

assign rr_ack = (enable == 1'b1) ? grant : 8'b0;

RR_ARBITER#(
    .NUM_REQUESTS                      (8                         ) 
)u_RR_ARBITER(
    .clk                               (clk                       ),
    .rst_n                             (rst_n                     ),
    .enable                            (enable                    ),
    .request                           (rr_req                    ),
    .grant                             (grant                     ) 
);

assign enable = (rr_req != rr_req_ff1);

always @(posedge clk or negedge rst_n) begin                        //Used to generate data_vld signal
    if (rst_n == 1'b0) begin
        send_data_vld <= 1'b0;
    end else if(enable == 1'b1)begin
        send_data_vld <= 1'b1;
    end else if(chx_eop_out == 1'b1) begin
        send_data_vld <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin                        //Used to maintain the ack signal
    if (rst_n == 1'b0) begin
        grant_hold <= 8'b0;
    end else if(enable == 1'b1)begin
        grant_hold <= grant;
    end else if(chx_eop_out == 1'b1) begin
        grant_hold <= 8'b0;
    end
end

 //Generate channel selection signal using the maintained ack signal
 always @(*) begin                                                  //Used to maintain the ack signal
    ch_select = 8'b0;
    if(enable == 1'b1) begin
        ch_select = grant;
    end else begin
         ch_select = grant_hold;
    end
 end

always@(*) begin
    chx_data_vld = 1'b0;
    chx_id_out = 3'b0;
    if(enable == 1'b1 || send_data_vld == 1'b1) begin
        chx_data_vld = 1'b1;
        chx_id_out = chx_id_in;
    end
end

always@(*) begin
    chx_data_out = 8'b0;
    chx_sop_out  = 1'b0;
    chx_eop_out  = 1'b0;
    chx_qos_out  = 1'b0;
    chx_id_out   = 3'b0;
    if(enable == 1'b1 || send_data_vld == 1'b1)
        case(ch_select)
            8'b00000001: begin
                chx_data_out = ch0_data_in;
                chx_sop_out  = ch0_sop_in ;
                chx_eop_out  = ch0_eop_in ;
                chx_qos_out  = ch0_qos_in ;
            end
            8'b00000010:  begin
                chx_data_out = ch1_data_in;
                chx_sop_out  = ch1_sop_in ;
                chx_eop_out  = ch1_eop_in ;
                chx_qos_out  = ch1_qos_in ;
            end
            8'b00000100:  begin
                chx_data_out = ch2_data_in;
                chx_sop_out  = ch2_sop_in ;
                chx_eop_out  = ch2_eop_in ;
                chx_qos_out  = ch2_qos_in ;
            end
            8'b00001000:  begin
                chx_data_out = ch3_data_in;
                chx_sop_out  = ch3_sop_in ;
                chx_eop_out  = ch3_eop_in ;
                chx_qos_out  = ch3_qos_in ;
            end
            8'b00010000:  begin
                chx_data_out = ch4_data_in;
                chx_sop_out  = ch4_sop_in ;
                chx_eop_out  = ch4_eop_in ;
                chx_qos_out  = ch4_qos_in ;
            end
            8'b00100000:  begin
                chx_data_out = ch5_data_in;
                chx_sop_out  = ch5_sop_in ;
                chx_eop_out  = ch5_eop_in ;
                chx_qos_out  = ch5_qos_in ;
            end
            8'b01000000:  begin
                chx_data_out = ch6_data_in;
                chx_sop_out  = ch6_sop_in ;
                chx_eop_out  = ch6_eop_in ;
                chx_qos_out  = ch6_qos_in ;
            end
            8'b10000000:  begin
                chx_data_out = ch7_data_in;
                chx_sop_out  = ch7_sop_in ;
                chx_eop_out  = ch7_eop_in ;
                chx_qos_out  = ch7_qos_in ;
            end
            default: begin
                chx_data_out = 8'b0;
                chx_sop_out  = 1'b0;
                chx_eop_out  = 1'b0;
                chx_qos_out  = 1'b0;
                chx_id_out   = 3'b0;
            end
        endcase
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rr_req_ff1 <= 8'b0;
    else 
        rr_req_ff1 <= rr_req;
end
    
endmodule