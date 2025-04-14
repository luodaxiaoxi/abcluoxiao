module DMUX_TB();
parameter DATA_WIDTH = 39;
reg                       clk_i;
reg                       clk_o;
reg                       reset_n;
reg                       data_in_vld;
wire                      data_out_vld;
    
reg    [DATA_WIDTH-1:0]  data_in;
wire   [DATA_WIDTH-1:0]  data_out;

initial begin
    clk_i = 1'b0;
    forever begin
        //#5 clk_i = ~clk_i;
        #5 clk_i = 1'bx;
    end
end 

initial begin
    clk_o = 1'b0;
    forever begin
        #10 clk_o = ~clk_o;
    end
end 

initial begin
    reset_n = 1'b1;
    data_in = 39'b0;
    data_in_vld = 1'b0;
    #30;
    reset_n = 1'b0;
    data_in = 39'b0;
    data_in_vld = 1'b0;
    #30;
    reset_n = 1'b1;
    data_in = 39'h3456;
    data_in_vld = 1'b0;
    #50;
    @(negedge clk_i)
    data_in_vld = 1'b1;
    @(negedge clk_i)
    data_in_vld = 1'b0;

    #200;
    $finish;
end

initial	begin
	    $fsdbDumpfile("tb.fsdb");//这个是产生名为tb.fsdb的文件
	    $fsdbDumpvars;
end


DMUX U_DMUX (
         .clk_i(clk_i),
         .clk_o(clk_o),
         .reset_n(reset_n),
         .data_in_vld(data_in_vld),
         .data_out_vld(data_out_vld),
         .data_in(data_in),
         .data_out(data_out)
);
endmodule
