module STRL(
input clk,
input rst_n,

input[DW-1:0] data_s,
input  vld_s
output reg ready_s,

output [DW-1:1] data_m,
output  vld_m
input ready_m,

output const_flag
);

wire sflag;
wire mflag;
reg has_pkt;
reg data_t;
reg [15:0] cnt;

assign sflag = vld_s & ready_s;
assign mflag = vld_m & ready_m;

assign vld_m = (has_pkt == 1) ? 1:(sflag);

always@(posedge clk or negedge rst_n) begin
    if(rst_n== 0)
        has_pkt <= 0;
    else if(sflag & mflag==0)
        has_pkt <= 1;
    else if(sflag & mflag & has_pkt)
        has_pkt <= 1;
    else if(sflag & mflag & has_pkt==0)
        has_pkt <= 0;  
    else ;  
end

always@(posedge clk or negedge rst_n) begin
    if(rst_n == 0)
        ready_s <= 0;
    else if(has_pkt == 0)
        ready_s <= 1;
    else if(sflag & mflag)
        ready_s <= 1;
    else 
        ready_s <= 0;
end

always@(*) begin
    data_m = data_t;
    if(has_pkt == 1)
        data_m = data_t;
    else if(sflag & mflag)
        data_m = data_s;
end

always@(posedge clk or negedge rst_n) begin
    if(rst_n== 0)
        data_t <= 0;
    else if(has_pkt == 0 & sflag & mflag)
        ;
    else if(has_pkt == 0 & sflag & mflag == 0)
        data_t <= data_s;
    else if(has_pkt == 1 & sflag)
        data_t <= data_s;
    else ;
end

always@(posedge clk or negedge rst_n) begin
    if(rst_n==0)
        cnt <= 0;
    else if( sflag )
        cnt <= cnt + 1;
    else 
        cnt <= 0;
end


const_flag = ( cnt > 0 & has_pkt ) | cnt > 0;
endmodule