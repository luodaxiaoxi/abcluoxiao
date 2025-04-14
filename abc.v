`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.8.20240817
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2025/04/11 21:49:26
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/04/11 21:49:26
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              abc.v
// PATH:                   E:\Work_OR_Study\Code\abc.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ABC(
    input                               clk                        ,
    input                               rst_n                      ,
    input wrdata_en,
    input [255:0] wrdata_pld,
    input wrdata_lw,
    input rdata_en,

    output rdatardy,
    output arb_req,
    output arb_lw,
    output [255:0] arb_pld
    );
reg [7:0] cnt;
wire cnt_add_flag;
wire cnt_sub_flag;
wire wr_en;
wire rd_en;
wire [256:0] wr_data;
wire [256:0] rd_data;
wire fifo_data_rdy;
reg fifo_data_rdy_1ff;

assign cnt_add_flag = wrdata_lw & wr_en;
assign cnt_sub_flag = arb_lw & rd_en;
assign cnt_hold_flag = cnt_add_flag & cnt_sub_flag;
//fifo wr
assign wr_en = (wrdata_en == 1'b1) && (rdatardy == 1'b1);
assign wr_data = {wrdata_lw, wrdata_pld};
assign rdatardy = (full != 1);

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        cnt <= 8'd0;
    end
    else if(cnt_hold_flag == 1'b1) begin
        cnt <= cnt;
    end
    else if(cnt_add_flag == 1'b1) begin
        cnt <= cnt + 1'b1;
    end
    else if(cnt_sub_flag == 1'b1) begin
        cnt <= cnt - 1'b1;
    end
end
//fifo_rd

assign rd_en = (fifo_data_rdy == 1'b1) && (rdata_en == 1'b1) ;  
  
assign fifo_data_rdy = (cnt != 8'd0);    

assign arb_req = rd_en;         
assign arb_lw = rd_data[255];
assign arb_pld = rd_data[255:0];      
sync_fifo
U_SYNC (
    .clk(clk)        ,
    .rst_n(rst_n)    ,
    .rd_en(rd_en)    ,
    .rd_data(rd_data),
    .wr_en(wr_en)    ,
    .wr_data(wr_data),
    .empty(empty)    ,
    .full(full)
);                                                            
endmodule

module sync_fifo
#(parameter DATA_WIDTH = 256,
  parameter ADDR_WIDTH = 7,
  parameter FIFO_DEPTH = 16)(
    input   wire            clk,
    input   wire            rst_n,
    input   wire            wr_en,
    input   wire            rd_en,
    input   wire    [DATA_WIDTH - 1:0]   wr_data,
 
    output  wire            empty,
    output  wire            full,
    output          [DATA_WIDTH - 1:0]  rd_data

);

reg  [DATA_WIDTH - 1:0]  mem[FIFO_DEPTH - 1:0];
wire [ADDR_WIDTH - 1:0]  w_addr,r_addr;
reg  [ADDR_WIDTH:0]      r_addr_a, w_addr_a; 

assign r_addr = r_addr_a[ADDR_WIDTH - 1:0];
assign w_addr = w_addr_a[ADDR_WIDTH - 1:0];
assign rd_data = mem[r_addr];
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        r_addr_a <= {ADDR_WIDTH{1'b0}};
    else begin
        if(rd_en==1 && empty==0) begin
            r_addr_a <= r_addr_a + 1;
        end
    end
end
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
        w_addr_a <= {ADDR_WIDTH{1'b0}};
    else begin
        if(wr_en==1 && full==0) begin
            mem[w_addr] <= wr_data;
            w_addr_a <= w_addr_a + 1;
        end
    end

assign empty = (r_addr_a == w_addr_a) ? 1 : 0;
assign full  = (r_addr_a[ADDR_WIDTH] != w_addr_a[ADDR_WIDTH]  && r_addr_a[ADDR_WIDTH - 1:0] == w_addr_a[ADDR_WIDTH - 1:0]) ? 1 : 0; 

endmodule