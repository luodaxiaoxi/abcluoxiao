
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

wire                   [  10:0]         jump_point                 ;
wire                   [  10:0]         high_jump_to_point         ;
wire                   [  10:0]         low_jump_to_point          ;
wire                   [   1:0]         jump_flag_for_rd           ;

wire                                    ram_wen_mux                ;
wire                   [  10:0]         ram_waddr_mux              ;
wire                   [  10:0]         ram_wdata_mux              ;
wire                                    ram_ren_mux                ;
wire                   [  10:0]         ram_raddr_mux              ;
wire                   [  10:0]         ram_rdata_mux              ;


assign ram_wen_mux   = (hram_wen == 1'b1) ? (hram_wen) : ((lram_wen == 1'b1) ? lram_wen : 1'b0);
assign ram_waddr_mux = (hram_wen == 1'b1) ? (hram_waddr) : ((lram_wen == 1'b1) ? lram_waddr : 11'b0);
assign ram_wdata_mux = (hram_wen == 1'b1) ? (hram_wdata) : ((lram_wen == 1'b1) ? lram_wdata : 11'b0);

assign ram_ren_mux = (hram_ren == 1'b1) ? (hram_wen) : ((lram_ren == 1'b1) ? lram_ren : 1'b0);
assign ram_raddr_mux = (hram_ren == 1'b1) ? (hram_raddr) : ((lram_ren == 1'b1) ? lram_raddr : 11'b0);
assign ram_rdata_mux = (hram_ren == 1'b1) ? (hram_rdata) : ((lram_ren == 1'b1) ? lram_rdata : 11'b0);


/*
always@(*) begin
    ram_wen_mux    = 1'b0;
    ram_waddr_mux  = 11'b0;
    ram_wdata_mux  = 11'b0;
    if(hram_wen == 1'b1) begin
        ram_wen_mux    = hram_wen  ;
        ram_waddr_mux  = hram_waddr;
        ram_wdata_mux  = hram_wdata;
    end else if(lram_wen == 1'b1) begin
        ram_wen_mux    = lram_wen  ;
        ram_waddr_mux  = lram_waddr;
        ram_wdata_mux  = lram_wdata;
    end
end

always@(*) begin
    ram_ren_mux    = 1'b0;
    ram_raddr_mux  = 11'b0;
    ram_rdata_mux  = 11'b0;
    if(hram_ren == 1'b1) begin
        ram_ren_mux    = hram_ren  ;
        ram_raddr_mux  = hram_raddr;
        ram_rdata_mux  = hram_rdata;
    end else if(lram_ren == 1'b1) begin
        ram_ren_mux    = lram_ren  ;
        ram_raddr_mux  = lram_raddr;
        ram_rdata_mux  = lram_rdata;
    end
end
*/
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
    .pkg_cnt_incr                      (pkg_cnt_incr              ),
    .lram_raddr                        (lram_raddr                ),
    .hram_raddr                        (hram_raddr                ),
    .jump_point                        (jump_point                ),
    .high_jump_to_point                (high_jump_to_point        ),
    .low_jump_to_point                 (low_jump_to_point         ),
    .jump_flag_for_rd                  (jump_flag_for_rd          ) 
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
    .rr_ack                            (rr_ack                    ),
    .jump_point                        (jump_point                ),
    .high_jump_to_point                (high_jump_to_point        ),
    .low_jump_to_point                 (low_jump_to_point         ),
    .jump_flag_for_rd                  (jump_flag_for_rd          ) 
);

RF_MEM#(
    .ADDR_WIDTH                        (11                        ),
    .DATA_WIDTH                        (11                        ),
    .DEPTH                             (1144                      ) 
)u_RF_MEM(
    .clk                               (clk                       ),
    .rst_n                             (rst_n                     ),
    .wr_en                             (ram_wen_mux               ),
    .addr_a                            (ram_waddr_mux             ),
    .data_a                            (ram_wdata_mux             ),
    .re_en                             (ram_ren_mux               ),
    .addr_b                            (ram_raddr_mux             ),
    .data_b                            (ram_rdata_mux             ) 
);


    
endmodule




