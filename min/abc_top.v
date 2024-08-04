
module ABC_TOP(
    input                               clk                        ,
    input                               rst_n                      ,

    input              [   7:0]         ch0_data_in                ,
    input                               ch0_sop_in                 ,
    input                               ch0_eop_in                 ,
    input                               ch0_qos_in                 ,
    input              [   2:0]         ch0_id_in                  ,

    input              [   7:0]         ch1_data_in                ,
    input                               ch1_sop_in                 ,
    input                               ch1_eop_in                 ,
    input                               ch1_qos_in                 ,
    input              [   2:0]         ch1_id_in                  ,

    input              [   7:0]         ch2_data_in                ,
    input                               ch2_sop_in                 ,
    input                               ch2_eop_in                 ,
    input                               ch2_qos_in                 ,
    input              [   2:0]         ch2_id_in                  ,

    input              [   7:0]         ch3_data_in                ,
    input                               ch3_sop_in                 ,
    input                               ch3_eop_in                 ,
    input                               ch3_qos_in                 ,
    input              [   2:0]         ch3_id_in                  ,

    input              [   7:0]         ch4_data_in                ,
    input                               ch4_sop_in                 ,
    input                               ch4_eop_in                 ,
    input                               ch4_qos_in                 ,
    input              [   2:0]         ch4_id_in                  ,

    input              [   7:0]         ch5_data_in                ,
    input                               ch5_sop_in                 ,
    input                               ch5_eop_in                 ,
    input                               ch5_qos_in                 ,
    input              [   2:0]         ch5_id_in                  ,

    input              [   7:0]         ch6_data_in                ,
    input                               ch6_sop_in                 ,
    input                               ch6_eop_in                 ,
    input                               ch6_qos_in                 ,
    input              [   2:0]         ch6_id_in                  ,
    
    input              [   7:0]         ch7_data_in                ,
    input                               ch7_sop_in                 ,
    input                               ch7_eop_in                 ,
    input                               ch7_qos_in                 ,
    input              [   2:0]         ch7_id_in                  ,

        //OUTPUT Interface 
    output reg         [   7:0]         ch0_data_out               ,
    output reg                          ch0_sop_out                ,
    output reg                          ch0_eop_out                ,
    output                              ch0_qos_out                ,
    output                              ch0_data_vld               ,
    output                              ch0_id_out                 ,

    output reg         [   7:0]         ch1_data_out               ,
    output reg                          ch1_sop_out                ,
    output reg                          ch1_eop_out                ,
    output                              ch1_qos_out                ,
    output                              ch1_data_vld               ,
    output                              ch1_id_out                 ,

    output reg         [   7:0]         ch2_data_out               ,
    output reg                          ch2_sop_out                ,
    output reg                          ch2_eop_out                ,
    output                              ch2_qos_out                ,
    output                              ch2_data_vld               ,
    output                              ch2_id_out                 ,

    output reg         [   7:0]         ch3_data_out               ,
    output reg                          ch3_sop_out                ,
    output reg                          ch3_eop_out                ,
    output                              ch3_qos_out                ,
    output                              ch3_data_vld               ,
    output                              ch3_id_out                 ,

    output reg         [   7:0]         ch4_data_out               ,
    output reg                          ch4_sop_out                ,
    output reg                          ch4_eop_out                ,
    output                              ch4_qos_out                ,
    output                              ch4_data_vld               ,
    output                              ch4_id_out                 ,

    output reg         [   7:0]         ch5_data_out               ,
    output reg                          ch5_sop_out                ,
    output reg                          ch5_eop_out                ,
    output                              ch5_qos_out                ,
    output                              ch5_data_vld               ,
    output                              ch5_id_out                 ,

    output reg         [   7:0]         ch6_data_out               ,
    output reg                          ch6_sop_out                ,
    output reg                          ch6_eop_out                ,
    output                              ch6_qos_out                ,
    output                              ch6_data_vld               ,
    output                              ch6_id_out                 ,

    output reg         [   7:0]         ch7_data_out               ,
    output reg                          ch7_sop_out                ,
    output reg                          ch7_eop_out                ,
    output                              ch7_qos_out                ,
    output                              ch7_data_vld               ,
    output                              ch7_id_out                 ,

    output                              ch0_out_incr               ,
    output                              ch1_out_incr               ,
    output                              ch2_out_incr               ,
    output                              ch3_out_incr               ,
    output                              ch4_out_incr               ,
    output                              ch5_out_incr               ,
    output                              ch6_out_incr               ,
    output                              ch7_out_incr               ,

    output                              pkg_cnt_incr0              ,
    output                              pkg_cnt_incr1              ,
    output                              pkg_cnt_incr2              ,
    output                              pkg_cnt_incr3              ,
    output                              pkg_cnt_incr4              ,
    output                              pkg_cnt_incr5              ,
    output                              pkg_cnt_incr6              ,
    output wire                         pkg_cnt_incr7               
    );

wire                   [   7:0]         chx_data_in_arr[7:0]       ;
wire                                    chx_sop_in_arr[7:0]        ;
wire                                    chx_eop_in_arr[7:0]        ;
wire                                    chx_qos_in_arr[7:0]        ;
wire                   [   2:0]         chx_id_in_arr[7:0]         ;
wire                   [   7:0]         chx_pkg_cnt_incr           ;


wire                   [   7:0]         chx_data_rr_arr[7:0]       ;
wire                                    chx_sop_rr_arr[7:0]        ;
wire                                    chx_eop_rr_arr[7:0]        ;
wire                                    chx_qos_rr_arr[7:0]        ;

wire                   [   7:0]         chx_data_out_arr[7:0]      ;
wire                                    chx_sop_out_arr[7:0]       ;
wire                                    chx_eop_out_arr[7:0]       ;
wire                                    chx_qos_out_arr[7:0]       ;
wire                                    chx_data_vld_arr[7:0]      ;
wire                   [   2:0]         chx_id_out_arr[7:0]        ;
wire                   [   7:0]         pkg_cnt_incr_arr           ;

wire [7:0] in_2_out_rr_req[7:0];
wire [7:0] out_to_in_rr_ack[7:0];

wire [7:0] rr_in_req_arr[7:0];
wire [7:0] input_in_ack_rr[7:0];

assign pkg_cnt_incr0 = chx_pkg_cnt_incr[0];
assign pkg_cnt_incr1 = chx_pkg_cnt_incr[1];
assign pkg_cnt_incr2 = chx_pkg_cnt_incr[2];
assign pkg_cnt_incr3 = chx_pkg_cnt_incr[3];
assign pkg_cnt_incr4 = chx_pkg_cnt_incr[4];
assign pkg_cnt_incr5 = chx_pkg_cnt_incr[5];
assign pkg_cnt_incr6 = chx_pkg_cnt_incr[6];
assign pkg_cnt_incr7 = chx_pkg_cnt_incr[7];

assign pkg_cnt_incr0 = pkg_cnt_incr_arr[0];
assign pkg_cnt_incr1 = pkg_cnt_incr_arr[1];
assign pkg_cnt_incr2 = pkg_cnt_incr_arr[2];
assign pkg_cnt_incr3 = pkg_cnt_incr_arr[3];
assign pkg_cnt_incr4 = pkg_cnt_incr_arr[4];
assign pkg_cnt_incr5 = pkg_cnt_incr_arr[5];
assign pkg_cnt_incr6 = pkg_cnt_incr_arr[6];
assign pkg_cnt_incr7 = pkg_cnt_incr_arr[7];

assign chx_data_in_arr[0] = ch0_data_in ;
assign chx_data_in_arr[1] = ch1_data_in ;
assign chx_data_in_arr[2] = ch2_data_in ;
assign chx_data_in_arr[3] = ch3_data_in ;
assign chx_data_in_arr[4] = ch4_data_in ;
assign chx_data_in_arr[5] = ch5_data_in ;
assign chx_data_in_arr[6] = ch6_data_in ;
assign chx_data_in_arr[7] = ch7_data_in ;

assign chx_sop_in_arr[0] = ch0_sop_in ;
assign chx_sop_in_arr[1] = ch1_sop_in ;
assign chx_sop_in_arr[2] = ch2_sop_in ;
assign chx_sop_in_arr[3] = ch3_sop_in ;
assign chx_sop_in_arr[4] = ch4_sop_in ;
assign chx_sop_in_arr[5] = ch5_sop_in ;
assign chx_sop_in_arr[6] = ch6_sop_in ;
assign chx_sop_in_arr[7] = ch7_sop_in ;

assign chx_eop_in_arr[0] = ch0_eop_in ;
assign chx_eop_in_arr[1] = ch1_eop_in ;
assign chx_eop_in_arr[2] = ch2_eop_in ;
assign chx_eop_in_arr[3] = ch3_eop_in ;
assign chx_eop_in_arr[4] = ch4_eop_in ;
assign chx_eop_in_arr[5] = ch5_eop_in ;
assign chx_eop_in_arr[6] = ch6_eop_in ;
assign chx_eop_in_arr[7] = ch7_eop_in ;

assign chx_qos_in_arr[0] = ch0_qos_in ;
assign chx_qos_in_arr[1] = ch1_qos_in ;
assign chx_qos_in_arr[2] = ch2_qos_in ;
assign chx_qos_in_arr[3] = ch3_qos_in ;
assign chx_qos_in_arr[4] = ch4_qos_in ;
assign chx_qos_in_arr[5] = ch5_qos_in ;
assign chx_qos_in_arr[6] = ch6_qos_in ;
assign chx_qos_in_arr[7] = ch7_qos_in ;

assign chx_id_in_arr[0] = ch0_id_in ;
assign chx_id_in_arr[1] = ch1_id_in ;
assign chx_id_in_arr[2] = ch2_id_in ;
assign chx_id_in_arr[3] = ch3_id_in ;
assign chx_id_in_arr[4] = ch4_id_in ;
assign chx_id_in_arr[5] = ch5_id_in ;
assign chx_id_in_arr[6] = ch6_id_in ;
assign chx_id_in_arr[7] = ch7_id_in ;

    genvar k; 
    generate
        for (k = 0; k < 8; k = k + 1) begin : REQ_ACK
            assign rr_in_req_arr[k]    = {in_2_out_rr_req[7][k],in_2_out_rr_req[6][k],
                                          in_2_out_rr_req[5][k],in_2_out_rr_req[4][k],
                                          in_2_out_rr_req[3][k],in_2_out_rr_req[2][k],
                                          in_2_out_rr_req[1][k],in_2_out_rr_req[0][k]};

            assign input_in_ack_rr[k]  = {out_to_in_rr_ack[7][k],out_to_in_rr_ack[6][k],
                                          out_to_in_rr_ack[5][k],out_to_in_rr_ack[4][k],
                                          out_to_in_rr_ack[3][k],out_to_in_rr_ack[2][k],
                                          out_to_in_rr_ack[1][k],out_to_in_rr_ack[0][k]};
        end
    endgenerate

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : CHX_INPUT_CTRL
            CHX_INPUT_CTRL u_CHX_INPUT_CTRL(
    .clk                               (clk                       ),
    .rst_n                             (rst_n                     ),
    .chx_data_in                       (chx_data_in_arr[i]        ),
    .chx_sop_in                        (chx_sop_in_arr[i]         ),
    .chx_eop_in                        (chx_eop_in_arr[i]         ),
    .chx_qos_in                        (chx_qos_in_arr[i]         ),
    .chx_id_in                         (chx_id_in_arr[i]          ),
    .pkg_cnt_incr                      (chx_pkg_cnt_incr[i]       ),
    .chx_data_out                      (chx_data_rr_arr[i]        ),
    .chx_sop_out                       (chx_sop_rr_arr[i]         ),
    .chx_eop_out                       (chx_eop_rr_arr[i]         ),
    .chx_qos_out                       (chx_qos_rr_arr[i]         ),
    .rr_req                            (in_2_out_rr_req[i]                 ),
    .rr_ack                            (input_in_ack_rr[i]                 ) 
);
        end
    endgenerate

 genvar j; // 
    generate
        for (j = 0; j < 8; j = j + 1) begin : CHX_OUT_CTRL
            CHX_OUT_CTRL u_CHX_OUT_CTRL(
    .clk                               (clk                       ),
    .rst_n                             (rst_n                     ),
    .ch0_data_in                       (chx_data_rr_arr[0]        ),
    .ch0_sop_in                        (chx_sop_rr_arr[0]         ),
    .ch0_eop_in                        (chx_eop_rr_arr[0]         ),
    .ch0_qos_in                        (chx_qos_rr_arr[0]         ),
    .ch1_data_in                       (chx_data_rr_arr[1]        ),
    .ch1_sop_in                        (chx_sop_rr_arr[1]         ),
    .ch1_eop_in                        (chx_eop_rr_arr[1]         ),
    .ch1_qos_in                        (chx_qos_rr_arr[1]         ),
    .ch2_data_in                       (chx_data_rr_arr[2]        ),
    .ch2_sop_in                        (chx_sop_rr_arr[2]         ),
    .ch2_eop_in                        (chx_eop_rr_arr[2]         ),
    .ch2_qos_in                        (chx_qos_rr_arr[2]         ),
    .ch3_data_in                       (chx_data_rr_arr[3]        ),
    .ch3_sop_in                        (chx_sop_rr_arr[3]         ),
    .ch3_eop_in                        (chx_eop_rr_arr[3]         ),
    .ch3_qos_in                        (chx_qos_rr_arr[3]         ),
    .ch4_data_in                       (chx_data_rr_arr[4]        ),
    .ch4_sop_in                        (chx_sop_rr_arr[4]         ),
    .ch4_eop_in                        (chx_eop_rr_arr[4]         ),
    .ch4_qos_in                        (chx_qos_rr_arr[4]         ),
    .ch5_data_in                       (chx_data_rr_arr[5]        ),
    .ch5_sop_in                        (chx_sop_rr_arr[5]         ),
    .ch5_eop_in                        (chx_eop_rr_arr[5]         ),
    .ch5_qos_in                        (chx_qos_rr_arr[5]         ),
    .ch6_data_in                       (chx_data_rr_arr[6]        ),
    .ch6_sop_in                        (chx_sop_rr_arr[6]         ),
    .ch6_eop_in                        (chx_eop_rr_arr[6]         ),
    .ch6_qos_in                        (chx_qos_rr_arr[6]         ),
    .ch7_data_in                       (chx_data_rr_arr[7]        ),
    .ch7_sop_in                        (chx_sop_rr_arr[7]         ),
    .ch7_eop_in                        (chx_eop_rr_arr[7]         ),
    .ch7_qos_in                        (chx_qos_rr_arr[7]         ),
    .chx_id_in                         (j                         ),
    .chx_data_out                      (chx_data_out_arr[j]       ),
    .chx_sop_out                       (chx_sop_out_arr[j]        ),
    .chx_eop_out                       (chx_eop_out_arr[j]        ),
    .chx_qos_out                       (chx_qos_out_arr[j]        ),
    .chx_data_vld                      (chx_data_vld_arr[j]       ),
    .chx_id_out                        (chx_id_out_arr[j]         ),
    .chx_out_incr                      (pkg_cnt_incr_arr[j]       ),
    .rr_req                            (rr_in_req_arr[j]          ),
    .rr_ack                            (out_to_in_rr_ack[j]       ) 
        );
        end
    endgenerate



endmodule