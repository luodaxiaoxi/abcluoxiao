`timescale  1ns / 1ps

module tb_ABC_TOP;

// ABC_TOP Parameters
parameter PERIOD  = 10;


// ABC_TOP Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [   7:0]  ch0_data_in                = 0 ;
reg   ch0_sop_in                           = 0 ;
reg   ch0_eop_in                           = 0 ;
reg   ch0_qos_in                           = 0 ;
reg   [   2:0]  ch0_id_in                  = 0 ;
reg   [   7:0]  ch1_data_in                = 0 ;
reg   ch1_sop_in                           = 0 ;
reg   ch1_eop_in                           = 0 ;
reg   ch1_qos_in                           = 0 ;
reg   [   2:0]  ch1_id_in                  = 0 ;
reg   [   7:0]  ch2_data_in                = 0 ;
reg   ch2_sop_in                           = 0 ;
reg   ch2_eop_in                           = 0 ;
reg   ch2_qos_in                           = 0 ;
reg   [   2:0]  ch2_id_in                  = 0 ;
reg   [   7:0]  ch3_data_in                = 0 ;
reg   ch3_sop_in                           = 0 ;
reg   ch3_eop_in                           = 0 ;
reg   ch3_qos_in                           = 0 ;
reg   [   2:0]  ch3_id_in                  = 0 ;
reg   [   7:0]  ch4_data_in                = 0 ;
reg   ch4_sop_in                           = 0 ;
reg   ch4_eop_in                           = 0 ;
reg   ch4_qos_in                           = 0 ;
reg   [   2:0]  ch4_id_in                  = 0 ;
reg   [   7:0]  ch5_data_in                = 0 ;
reg   ch5_sop_in                           = 0 ;
reg   ch5_eop_in                           = 0 ;
reg   ch5_qos_in                           = 0 ;
reg   [   2:0]  ch5_id_in                  = 0 ;
reg   [   7:0]  ch6_data_in                = 0 ;
reg   ch6_sop_in                           = 0 ;
reg   ch6_eop_in                           = 0 ;
reg   ch6_qos_in                           = 0 ;
reg   [   2:0]  ch6_id_in                  = 0 ;
reg   [   7:0]  ch7_data_in                = 0 ;
reg   ch7_sop_in                           = 0 ;
reg   ch7_eop_in                           = 0 ;
reg   ch7_qos_in                           = 0 ;
reg   [   2:0]  ch7_id_in                  = 0 ;


// ABC_TOP Outputs
wire  [   7:0]  ch0_data_out               ;
wire  ch0_sop_out                          ;
wire  ch0_eop_out                          ;
wire  ch0_qos_out                          ;
wire  ch0_data_vld                         ;
wire  ch0_id_out                           ;
wire  [   7:0]  ch1_data_out               ;
wire  ch1_sop_out                          ;
wire  ch1_eop_out                          ;
wire  ch1_qos_out                          ;
wire  ch1_data_vld                         ;
wire  ch1_id_out                           ;
wire  [   7:0]  ch2_data_out               ;
wire  ch2_sop_out                          ;
wire  ch2_eop_out                          ;
wire  ch2_qos_out                          ;
wire  ch2_data_vld                         ;
wire  ch2_id_out                           ;
wire  [   7:0]  ch3_data_out               ;
wire  ch3_sop_out                          ;
wire  ch3_eop_out                          ;
wire  ch3_qos_out                          ;
wire  ch3_data_vld                         ;
wire  ch3_id_out                           ;
wire  [   7:0]  ch4_data_out               ;
wire  ch4_sop_out                          ;
wire  ch4_eop_out                          ;
wire  ch4_qos_out                          ;
wire  ch4_data_vld                         ;
wire  ch4_id_out                           ;
wire  [   7:0]  ch5_data_out               ;
wire  ch5_sop_out                          ;
wire  ch5_eop_out                          ;
wire  ch5_qos_out                          ;
wire  ch5_data_vld                         ;
wire  ch5_id_out                           ;
wire  [   7:0]  ch6_data_out               ;
wire  ch6_sop_out                          ;
wire  ch6_eop_out                          ;
wire  ch6_qos_out                          ;
wire  ch6_data_vld                         ;
wire  ch6_id_out                           ;
wire  [   7:0]  ch7_data_out               ;
wire  ch7_sop_out                          ;
wire  ch7_eop_out                          ;
wire  ch7_qos_out                          ;
wire  ch7_data_vld                         ;
wire  ch7_id_out                           ;
wire  ch0_out_incr                         ;
wire  ch1_out_incr                         ;
wire  ch2_out_incr                         ;
wire  ch3_out_incr                         ;
wire  ch4_out_incr                         ;
wire  ch5_out_incr                         ;
wire  ch6_out_incr                         ;
wire  ch7_out_incr                         ;
wire  pkg_cnt_incr0                        ;
wire  pkg_cnt_incr1                        ;
wire  pkg_cnt_incr2                        ;
wire  pkg_cnt_incr3                        ;
wire  pkg_cnt_incr4                        ;
wire  pkg_cnt_incr5                        ;
wire  pkg_cnt_incr6                        ;
wire  pkg_cnt_incr7                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

ABC_TOP u_ABC_TOP(
    .clk            ( clk            ),
    .rst_n          ( rst_n          ),
    .ch0_data_in    ( ch0_data_in    ),
    .ch0_sop_in     ( ch0_sop_in     ),
    .ch0_eop_in     ( ch0_eop_in     ),
    .ch0_qos_in     ( ch0_qos_in     ),
    .ch0_id_in      ( ch0_id_in      ),
    .ch1_data_in    ( ch1_data_in    ),
    .ch1_sop_in     ( ch1_sop_in     ),
    .ch1_eop_in     ( ch1_eop_in     ),
    .ch1_qos_in     ( ch1_qos_in     ),
    .ch1_id_in      ( ch1_id_in      ),
    .ch2_data_in    ( ch2_data_in    ),
    .ch2_sop_in     ( ch2_sop_in     ),
    .ch2_eop_in     ( ch2_eop_in     ),
    .ch2_qos_in     ( ch2_qos_in     ),
    .ch2_id_in      ( ch2_id_in      ),
    .ch3_data_in    ( ch3_data_in    ),
    .ch3_sop_in     ( ch3_sop_in     ),
    .ch3_eop_in     ( ch3_eop_in     ),
    .ch3_qos_in     ( ch3_qos_in     ),
    .ch3_id_in      ( ch3_id_in      ),
    .ch4_data_in    ( ch4_data_in    ),
    .ch4_sop_in     ( ch4_sop_in     ),
    .ch4_eop_in     ( ch4_eop_in     ),
    .ch4_qos_in     ( ch4_qos_in     ),
    .ch4_id_in      ( ch4_id_in      ),
    .ch5_data_in    ( ch5_data_in    ),
    .ch5_sop_in     ( ch5_sop_in     ),
    .ch5_eop_in     ( ch5_eop_in     ),
    .ch5_qos_in     ( ch5_qos_in     ),
    .ch5_id_in      ( ch5_id_in      ),
    .ch6_data_in    ( ch6_data_in    ),
    .ch6_sop_in     ( ch6_sop_in     ),
    .ch6_eop_in     ( ch6_eop_in     ),
    .ch6_qos_in     ( ch6_qos_in     ),
    .ch6_id_in      ( ch6_id_in      ),
    .ch7_data_in    ( ch7_data_in    ),
    .ch7_sop_in     ( ch7_sop_in     ),
    .ch7_eop_in     ( ch7_eop_in     ),
    .ch7_qos_in     ( ch7_qos_in     ),
    .ch7_id_in      ( ch7_id_in      ),
    .ch0_data_out   ( ch0_data_out   ),
    .ch0_sop_out    ( ch0_sop_out    ),
    .ch0_eop_out    ( ch0_eop_out    ),
    .ch0_qos_out    ( ch0_qos_out    ),
    .ch0_data_vld   ( ch0_data_vld   ),
    .ch0_id_out     ( ch0_id_out     ),
    .ch1_data_out   ( ch1_data_out   ),
    .ch1_sop_out    ( ch1_sop_out    ),
    .ch1_eop_out    ( ch1_eop_out    ),
    .ch1_qos_out    ( ch1_qos_out    ),
    .ch1_data_vld   ( ch1_data_vld   ),
    .ch1_id_out     ( ch1_id_out     ),
    .ch2_data_out   ( ch2_data_out   ),
    .ch2_sop_out    ( ch2_sop_out    ),
    .ch2_eop_out    ( ch2_eop_out    ),
    .ch2_qos_out    ( ch2_qos_out    ),
    .ch2_data_vld   ( ch2_data_vld   ),
    .ch2_id_out     ( ch2_id_out     ),
    .ch3_data_out   ( ch3_data_out   ),
    .ch3_sop_out    ( ch3_sop_out    ),
    .ch3_eop_out    ( ch3_eop_out    ),
    .ch3_qos_out    ( ch3_qos_out    ),
    .ch3_data_vld   ( ch3_data_vld   ),
    .ch3_id_out     ( ch3_id_out     ),
    .ch4_data_out   ( ch4_data_out   ),
    .ch4_sop_out    ( ch4_sop_out    ),
    .ch4_eop_out    ( ch4_eop_out    ),
    .ch4_qos_out    ( ch4_qos_out    ),
    .ch4_data_vld   ( ch4_data_vld   ),
    .ch4_id_out     ( ch4_id_out     ),
    .ch5_data_out   ( ch5_data_out   ),
    .ch5_sop_out    ( ch5_sop_out    ),
    .ch5_eop_out    ( ch5_eop_out    ),
    .ch5_qos_out    ( ch5_qos_out    ),
    .ch5_data_vld   ( ch5_data_vld   ),
    .ch5_id_out     ( ch5_id_out     ),
    .ch6_data_out   ( ch6_data_out   ),
    .ch6_sop_out    ( ch6_sop_out    ),
    .ch6_eop_out    ( ch6_eop_out    ),
    .ch6_qos_out    ( ch6_qos_out    ),
    .ch6_data_vld   ( ch6_data_vld   ),
    .ch6_id_out     ( ch6_id_out     ),
    .ch7_data_out   ( ch7_data_out   ),
    .ch7_sop_out    ( ch7_sop_out    ),
    .ch7_eop_out    ( ch7_eop_out    ),
    .ch7_qos_out    ( ch7_qos_out    ),
    .ch7_data_vld   ( ch7_data_vld   ),
    .ch7_id_out     ( ch7_id_out     ),
    .ch0_out_incr   ( ch0_out_incr   ),
    .ch1_out_incr   ( ch1_out_incr   ),
    .ch2_out_incr   ( ch2_out_incr   ),
    .ch3_out_incr   ( ch3_out_incr   ),
    .ch4_out_incr   ( ch4_out_incr   ),
    .ch5_out_incr   ( ch5_out_incr   ),
    .ch6_out_incr   ( ch6_out_incr   ),
    .ch7_out_incr   ( ch7_out_incr   ),
    .pkg_cnt_incr0  ( pkg_cnt_incr0  ),
    .pkg_cnt_incr1  ( pkg_cnt_incr1  ),
    .pkg_cnt_incr2  ( pkg_cnt_incr2  ),
    .pkg_cnt_incr3  ( pkg_cnt_incr3  ),
    .pkg_cnt_incr4  ( pkg_cnt_incr4  ),
    .pkg_cnt_incr5  ( pkg_cnt_incr5  ),
    .pkg_cnt_incr6  ( pkg_cnt_incr6  ),
    .pkg_cnt_incr7  ( pkg_cnt_incr7  )
);


initial
begin

    $finish;
end

endmodule