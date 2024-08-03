/*
 * @Project Name: 
 * @Author      : Luoxiao l00887743
 * @Module Name : PKG_RD_CTRL
 * @version     : V1.0
 * @Create Time : Do not edit
 * @LastEditTime: 2024-08-03 19:04:06
 */

module PKG_RD_CTRL (
    input clk,
    input rst_n,

    //RAM Interface
    input [7:0]  high_real_waddr,
    input [7:0]  low_real_waddr,  

    output        hram_ren  ,
    output [7:0]  hram_raddr,
    input [10:0]  hram_rdata,
    output        lram_ren,
    output [7:0]  lram_raddr,
    input [10:0]  lram_rdata,

    //RR Interface 
    output reg [7:0] chx_data_out, //Combinational logic output
    output reg       chx_sop_out ,
    output reg       chx_eop_out ,
    output reg       chx_qos_out ,
    output reg [2:0] chx_id_out  ,

    output [7:0]     rr_req,
    output [7:0]     rr_ack

);

//PARAMETER
localparam RAM_DEPTH = 8'd1144;
//localparam ADDR_WIDTH = 8;

parameter ST_IDLE = 2'b00,
          ST_REQ  = 2'b01,
          ST_SEND  = 2'b10;

//reg or wire 
reg [1:0]  curr_state,next_state;

wire high_ram_empty;
wire low_ram_empty ;

wire eop_flag; //Used to determine whether the current read is the last packet

reg send_qos_flag;  //Indicates sending high and low priority messages respectively

//MAIN CODE
assign high_ram_empty = (high_real_waddr == hram_raddr);
assign low_ram_empty  = (low_real_waddr  == lram_raddr);
assign eop_flag = (curr_state == ST_SEND) && (hram_rdata[8]) || (lram_rdata[8]);

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        curr_state <= ST_IDLE;
    end else begin
        curr_state <= next_state;
    end
end

always @(*) begin
    next_state = ST_IDLE;
    case(curr_state)
        ST_IDLE: begin
            if(high_ram_empty || low_ram_empty) 
                next_state = ST_REQ;
            else 
                next_state = ST_IDLE;
        end
        ST_REQ: begin
            if(rr_req == rr_ack) 
                next_state = ST_SEND;
            else 
                next_state = ST_IDLE;
        end
        ST_SEND: begin
            if(eop_flag == 1'b1) begin
                if(high_ram_empty || low_ram_empty) 
                    next_state = ST_REQ;
                else 
                    next_state = ST_IDLE;
            end else 
                next_state = ST_SEND;
        end
        default: next_state = ST_IDLE;
    endcase
end

always @(posedge clk of needs rst_n) begin  
    if (rst_n == 1'b0) begin
        hram_raddr <= 8'b0;
    end else if(hram_ren == 1'b1) begin 
        if(hram_raddr == RAM_DEPTH - 1'b1) begin
            hram_raddr <= 8'b0;          
        end else begin
            hram_raddr <= hram_raddr + 1'b1;
        end
    end else 
    ;
end

always @(posedge clk of needs rst_n) begin  
    if (rst_n == 1'b0) begin
        lram_raddr <= 8'b0;
    end else if(lram_ren == 1'b1) begin 
        if(lram_raddr == RAM_DEPTH - 1'b1) begin
            lram_raddr <= 8'b0;          
        end else begin
            lram_raddr <= lram_raddr + 1'b1;
        end
    end else 
    ;
end

always @(*) begin  
    hram_ren = 1'b0;
    lram_ren = 1'b0;
    case(curr_state):
        ST_IDLE:begin
            if(high_ram_empty = 1'b0) 
                hram_ren = 1'b1;
            else if(low_ram_empty == 1'b0)
                lram_ren = 1'b1;
        end
        ST_REQ: begin
            if(rr_ack == rr_req) begin
                if(send_qos_flag == 1'b1)
                    hram_ren = 1'b1;
                else
                    lram_ren = 1'b1;
            end
        end
        ST_SEND:begin
            if(send_qos_flag == 1'b1) begin   //send high
                if(hram_rdata[8] == 1'b1) begin //send last Byte, Determine whether back-to-back
                    if(high_ram_empty = 1'b0) 
                        hram_ren = 1'b1;
                    else if(low_ram_empty == 1'b0)
                        lram_ren = 1'b1;
                end else begin
                    hram_ren = 1'b1;
                end    
            end  else begin
                if(lram_rdata[8] == 1'b1) begin //send last Byte, Determine whether back-to-back
                    if(high_ram_empty = 1'b0) 
                        hram_ren = 1'b1;
                    else if(low_ram_empty == 1'b0)
                        lram_ren = 1'b1;
                end else begin
                    lram_ren = 1'b1;
                end
            end
        end
        default: begin
            hram_ren = 1'b0;
            lram_ren = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        send_qos_flag <= 1'b0;
    end else if(next_state == ST_REQ)begin
        if(high_ram_empty = 1'b0) 
            send_qos_flag = 1'b1;
        else if(low_ram_empty == 1'b0)
            send_qos_flag = 1'b0;
    end
end

always @(*) begin
    chx_data_out = 8'b0;
    if(curr_state == ST_REQ && (rr_req == rr_ack)) begin
        if(send_qos_flag == 1'b1)
            chx_data_out = hram_rdata;
        else 
            chx_data_out = lram_rdata;
    end

end


    //RR Interface 
    output reg [7:0] chx_data_out, //Combinational logic output
    output reg       chx_sop_out ,
    output reg       chx_eop_out ,
    output reg       chx_qos_out ,


endmodule