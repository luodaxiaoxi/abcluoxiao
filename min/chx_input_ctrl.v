
module CHX_INPUT_CTRL(
    input                               clk                        ,
    input                               rst_n                      ,

    input              [   7:0]         chx_data_in                ,
    input                               chx_sop_in                 ,
    input                               chx_eop_in                 ,
    input                               chx_qos_in                 ,
    input              [   2:0]         chx_id_in                  ,

    //Interrupt
    output reg                          pkg_cnt_incr               ,

     //RR Interface 
    output reg         [   7:0]         chx_data_out               ,//Combinational logic output
    output reg                          chx_sop_out                ,
    output reg                          chx_eop_out                ,
    output                              chx_qos_out                ,
    //   output reg [2:0] chx_id_out  ,
    output             [   7:0]         rr_req                     ,
    output             [   7:0]         rr_ack                      
);

    //output to ram 
wire                                    hram_wen                   ;
wire                   [  10:0]         hram_waddr                 ;
wire                   [  10:0]         hram_wdata                 ;

wire                                    lram_wen                   ;
wire                   [  10:0]         lram_waddr                 ;
wire                   [  10:0]         lram_wdata                 ;

wire                   [  10:0]         high_real_waddr            ;
wire                   [  10:0]         low_real_waddr             ;

wire                                    hram_ren                   ;
wire                   [  10:0]         hram_raddr                 ;
wire                   [  10:0]         hram_rdata                 ;
wire                                    lram_ren                   ;
wire                   [  10:0]         lram_raddr                 ;
wire                   [  10:0]         lram_rdata                 ;


PKG_WR_CTRL u_PKG_WR_CTRL(
    .clk                               (clk                       ),
    .rst_n                             (rst_n                     ),
    .chx_data_in                       (chx_data_in               ),
    .chx_sop_in                        (chx_sop_in                ),
    .chx_eop_in                        (chx_eop_in                ),
    .chx_qos_in                        (chx_qos_in                ),
    .chx_id_in                         (chx_id_in                 ),
    .hram_wen                          (hram_wen                  ),
    .hram_waddr                        (hram_waddr                ),
    .hram_wdata                        (hram_wdata                ),
    .lram_wen                          (lram_wen                  ),
    .lram_waddr                        (lram_waddr                ),
    .lram_wdata                        (lram_wdata                ),
    .high_real_waddr                   (high_real_waddr           ),
    .low_real_waddr                    (low_real_waddr            ),
    .pkg_cnt_incr                      (pkg_cnt_incr              ) 
);


PKG_RD_CTRL u_PKG_RD_CTRL(
    .clk                               (clk                       ),
    .rst_n                             (rst_n                     ),
    .high_real_waddr                   (high_real_waddr           ),
    .low_real_waddr                    (low_real_waddr            ),
    .hram_ren                          (hram_ren                  ),
    .hram_raddr                        (hram_raddr                ),
    .hram_rdata                        (hram_rdata                ),
    .lram_ren                          (lram_ren                  ),
    .lram_raddr                        (lram_raddr                ),
    .lram_rdata                        (lram_rdata                ),
    .chx_data_out                      (chx_data_out              ),
    .chx_sop_out                       (chx_sop_out               ),
    .chx_eop_out                       (chx_eop_out               ),
    .chx_qos_out                       (chx_qos_out               ),
    .rr_req                            (rr_req                    ),
    .rr_ack                            (rr_ack                    ) 
);



RF_MEM#(
    .ADDR_WIDTH ( 11 ),
    .DATA_WIDTH ( 11 ),
    .DEPTH     ( 1144 )
)u_RF_MEM_HIGH(
    .clk          ( clk          ),
    .rst_n        ( rst_n        ),
    .wr_en        ( hram_wen        ),
    .addr_a       ( hram_waddr       ),
    .data_a       ( hram_wdata       ),
    .re_en        ( hram_ren        ),
    .addr_b       ( hram_rdata       ),
    .data_b       ( hram_rdata       )
);

RF_MEM#(
    .ADDR_WIDTH ( 11 ),
    .DATA_WIDTH ( 11 ),
    .DEPTH     ( 1144 )
)u_RF_MEM_LOW(
    .clk          ( clk          ),
    .rst_n        ( rst_n        ),
    .wr_en        ( lram_wen        ),
    .addr_a       ( lram_waddr       ),
    .data_a       ( lram_wdata       ),
    .re_en        ( lram_ren        ),
    .addr_b       ( lram_rdata       ),
    .data_b       ( lram_rdata       )
);


    
endmodule




