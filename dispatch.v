module DISPATCH(
         input        clk  ,
         input        rst_n,

         input [31:0] test_data ,
         input        test_data_vld,
         input [2:0]  key_index ,
         input [3:0]  order_id  ,
         input        target_id ,

         output       resend_en ,
         output [3:0] resend_id ,

         output       vld_o     ,
         output [31:0]data_o    ,
         input        tail_i

);

reg [31:0] test_data_dly [7:0];
reg [7:0]  test_data_vld_dly;
reg [3:0]  order_id_dly[7:0];
reg resend_data_vld ;
reg [3:0] resend_id_tail ;
reg [3:0] resend_id_hold;
reg [31:0] key; 

reg resend_req_flag;

always @(*) begin
    case(key_index)
        3'd0: key = 32'hffff;

        3'd1: key = 32'hffff;

        3'd2: key = 32'hffff;

        default: key = 32'd0;
endcase

end
genvar i;

generate 
    for(i=0;i<8;i=i+1) begin:dlu
        if(i==0) begin
            always @(posedge clk or negedge rst_n) begin
                test_data_dly[i] <= test_data;
                test_data_vld_dly[i] <= test_data_vld;
                order_id_dly[i] <= order_id;
            end
        end    
        else begin
         always @(posedge clk or negedge rst_n) begin
                test_data_dly[i] <= test_data_vld_dly[i-1];
                test_data_vld_dly[i] <= test_data_vld_dly[i-1];
                order_id_dly[i] <= order_id_dly[i-1];
            end
    
        end    
    end
endgenerate

assign data_o = test_data ^ key;
assign vld_o = (resend_req_flag == 1'b1) && (resend_id_hold != order_id) ? 1'b0 : test_data_vld;

assign resend_id = resend_id_tail; 
assign resend_en = resend_data_vld; 

always @(*) begin
    if(tail_i == 1'b1) begin
        if(test_data_vld_dly[7] == 1'b1) begin
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[7];
        end
        else if(test_data_vld_dly[6] == 1'b1) begin
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[6];
        end
        else if(test_data_vld_dly[5] == 1'b1) begin
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[5];
        end
        else if(test_data_vld_dly[4] == 1'b1) begin
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[4];
        end
        else if(test_data_vld_dly[3] == 1'b1) begin
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[3];
        end           
        else if(test_data_vld_dly[2] == 1'b1) begin
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[2];
        end
        else if(test_data_vld_dly[1] == 1'b1) begin
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[1];
        end  
        else  if(test_data_vld_dly[0] == 1'b1) begin           
           resend_data_vld = 1'b1; 
           resend_id_tail  = order_id_dly[0];
        end
        else begin
            resend_data_vld = 1'b0; 
            resend_id_tail  = 4'd0;
        end
    end  
    else begin
       resend_data_vld = 1'b0; 
       resend_id_tail  = 4'd0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        resend_req_flag <= 1'b0;
        resend_id_hold <= 4'd0;
    end    
    else if(tail_i == 1'b1) begin
        resend_req_flag <= 1'b1;        
        resend_id_hold <= resend_id_tail;
    end
    else if(resend_id_hold == order_id) begin
        resend_req_flag <= 1'b0;
        resend_id_hold <= 4'd0; 
    end    
end


endmodule
