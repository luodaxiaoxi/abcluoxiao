
module PKG_WR_CTRL (
    input                               clk                        ,
    input                               rst_n                      ,

    input              [   7:0]         chx_data_in                ,
    input                               chx_sop_in                 ,
    input                               chx_eop_in                 ,
    input                               chx_qos_in                 ,
    input              [   2:0]         chx_id_in                  ,

    //output to ram 
    output reg                          hram_wen                   ,
    output reg         [  10:0]         hram_waddr                 ,
    output reg         [  10:0]         hram_wdata                 ,

    output reg                          lram_wen                   ,
    output reg         [  10:0]         lram_waddr                 ,
    output reg         [  10:0]         lram_wdata                 ,

    //To judge whether RAM is empty 
    output reg         [  10:0]         high_real_waddr            ,
    output reg         [  10:0]         low_real_waddr             ,

    //Interrupt
    output reg                          pkg_cnt_incr               ,
    //for jump
    input              [  10:0]         lram_raddr                 ,
    input              [  10:0]         hram_raddr                 ,
    output reg         [11-1:0]         jump_point                 ,
    output reg         [11-1:0]         high_jump_to_point         ,
    output reg         [11-1:0]         low_jump_to_point          ,
    output reg         [   1:0]         jump_flag_for_rd            
);

//PARAMETER
localparam                              RAM_DEPTH = 11'd1144       ;
localparam                              ADDR_WIDTH = 11            ;//{ADDR_WIDTH{1'b0}}

parameter                               ST_IDLE = 2'b00            ,
                                        ST_RCV  = 2'b01            ,
                                        ST_END  = 2'b10            ;    

//reg or wire 
reg                    [   7:0]         chx_data_in_ff1            ;
reg                                     chx_sop_in_ff1             ;
reg                                     chx_eop_in_ff1             ;
reg                                     chx_qos_in_ff1             ;
reg                    [   2:0]         chx_id_in_ff1              ;
reg                    [   1:0]         curr_state,next_state      ;

reg                                     chx_len_err                ;
reg                    [   6:0]         pkg_length                 ;
wire                                    jump_flag                  ;
reg                                     jump_vld                   ;

//MAIN CODE

assign jump_flag = (hram_waddr == (lram_waddr + 1'b1)) ? 1'b1 : 1'b0; //Pull high when a jump point occurs

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        jump_flag_for_rd <= 2'b0;
    end else begin
        if(jump_flag==1'b1)
            jump_flag_for_rd <= 2'b11;
        else if(hram_raddr == jump_point && (jump_flag_for_rd[1] == 1'b1))
            jump_flag_for_rd[1] <= 1'b0;
        else if(lram_raddr == jump_point -1'b1 && (jump_flag_for_rd[0] == 1'b1))
            jump_flag_for_rd[0] <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        jump_point <= {ADDR_WIDTH{1'b0}};
        jump_vld <= 1'b0;                    //Used to control another address jump enable
    end else if(jump_flag == 1'b1) begin
        jump_point <= hram_waddr;
        jump_vld <= 1'b1; 
    end if(jump_vld == 1'b1 && ((hram_waddr == jump_point) || (lram_waddr == jump_point - 1'b1)))begin
        jump_vld <= 1'b0; 
    end
end

always @(*) begin   //Calculate jump point
    high_jump_to_point = {ADDR_WIDTH{1'b0}};
    low_jump_to_point = {ADDR_WIDTH{1'b0}};
    if(jump_flag == 1'b1) begin
        if(hram_waddr <= RAM_DEPTH - 1'b1 -10'd512) begin
            high_jump_to_point = hram_waddr + 10'd512 - 1'b1;
            low_jump_to_point = hram_waddr + 10'd512;
        end else if(hram_waddr == RAM_DEPTH  -10'd512) begin
            high_jump_to_point = RAM_DEPTH - 1'b1;
            low_jump_to_point = {ADDR_WIDTH{1'b0}};
        end else begin
            high_jump_to_point = hram_waddr + 10'd512 - RAM_DEPTH -1'b1;
            low_jump_to_point = hram_waddr + 10'd512 - RAM_DEPTH;
        end
    end
end

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
            if( (chx_sop_in_ff1 == 1'b1) && (chx_eop_in_ff1 == 1'b0)) begin
                next_state = ST_RCV;
            end else begin
                next_state = ST_IDLE;
            end
        end
        ST_RCV: begin
            if((chx_len_err == 1'b1) || (chx_sop_in_ff1 == 1'b1)) begin
                next_state = ST_IDLE;
            end else if(chx_eop_in_ff1 == 1'b1) begin
                next_state = ST_END;
            end else begin
                next_state = ST_RCV;
            end
        end
        ST_END: begin
            if((chx_sop_in_ff1 == 1'b1) && (chx_eop_in_ff1 == 1'b0)) begin
                next_state = ST_RCV;
            end else begin
                next_state = ST_IDLE;
            end
        end
        default: next_state = ST_IDLE;
    endcase 
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        pkg_length <= 7'b0;
    end else begin
        if (next_state == ST_IDLE) begin
            pkg_length <= 7'b0;
        end else begin
            pkg_length <= pkg_length + 1'b1;
        end
    end
end

always @(*) begin
    chx_len_err = 1'b0;
    if(curr_state == ST_RCV && pkg_length == 7'd127)   //127 --->figure 0
        chx_len_err = 1'b1;
    else 
        chx_len_err = 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        high_real_waddr <= RAM_DEPTH - 1'b1;
    end else if(next_state==ST_END && hram_wen == 1'b1) begin
        if(jump_flag == 1'b1) begin
            high_real_waddr <= high_jump_to_point;
        end else if(jump_vld == 1'b1 && ((hram_waddr == jump_point) )) begin
            high_real_waddr <= high_jump_to_point;
        end else if(hram_waddr == {ADDR_WIDTH{1'b0}}) begin
            high_real_waddr <= (RAM_DEPTH - 1'b1);
        end else begin 
            high_real_waddr <= hram_waddr - 1'b1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        low_real_waddr  <= {ADDR_WIDTH{1'b0}};
    end else if(next_state==ST_END && lram_wen == 1'b1) begin
        if(jump_flag == 1'b1) begin
            low_real_waddr <= low_jump_to_point;
        end else if(jump_vld == 1'b1 && ((lram_waddr == jump_point -1'b1) )) begin
            low_real_waddr <= low_jump_to_point;
        end else if(lram_waddr == RAM_DEPTH - 1'b1) begin
            low_real_waddr <= {ADDR_WIDTH{1'b0}};
        end else begin
            low_real_waddr <= (lram_waddr == RAM_DEPTH - 1'b1) ? 11'b0 : (lram_waddr + 1'b1);
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        hram_waddr <= RAM_DEPTH - 1'b1 ;
    end else if((curr_state == ST_END) || (next_state == ST_IDLE))begin
        hram_waddr <= high_real_waddr;
    end if((next_state != ST_IDLE) && (chx_qos_in_ff1 == 1'b1)) begin //One logic is that the pointer is incremented, and the other logic is that the pointer jumps after the address meets
        if(jump_flag == 1'b1) begin
            hram_waddr <= high_jump_to_point;
        end else if(jump_vld == 1'b1 && ((hram_waddr == jump_point) )) begin
            hram_waddr <= high_jump_to_point;
        end else if(hram_waddr == {ADDR_WIDTH{1'b0}}) begin
            hram_waddr <= (RAM_DEPTH - 1'b1);
        end else begin 
            hram_waddr <= hram_waddr - 1'b1;
        end
    //end else begin
    //    hram_waddr <= hram_waddr;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        lram_waddr <= {ADDR_WIDTH{1'b0}};
    end else if((curr_state == ST_END) || (next_state == ST_IDLE))begin
        lram_waddr <= low_real_waddr;
    end if((next_state != ST_IDLE) && (chx_qos_in_ff1 == 1'b0)) begin //this condition enshare in END addr=addr + 1
        if(jump_flag == 1'b1) begin
            lram_waddr <= low_jump_to_point;
        end else if(jump_vld == 1'b1 && ((lram_waddr == jump_point -1'b1) )) begin
            hram_waddr <= low_jump_to_point;
        end else if(lram_waddr == RAM_DEPTH - 1'b1) begin
            lram_waddr <= {ADDR_WIDTH{1'b0}};
        end else begin
            lram_waddr <= (lram_waddr == RAM_DEPTH - 1'b1) ? 11'b0 : (lram_waddr + 1'b1);
        end
    //end else begin
    //    lram_waddr <= lram_waddr;
    end
end

always @(*) begin
    hram_wdata = 11'b0;
    lram_wdata = 11'b0;
    if(curr_state == ST_IDLE && (chx_sop_in_ff1 == 1'b1) && (chx_eop_in_ff1 == 1'b0)) begin
        if(chx_qos_in_ff1 == 1'b1) begin
            hram_wdata = {chx_id_in_ff1,chx_data_in_ff1};
            lram_wdata = 11'b0;
        end else begin
            lram_wdata = {chx_id_in_ff1,chx_data_in_ff1};
            hram_wdata = 11'b0;
        end 
    end else if(curr_state == ST_RCV) begin
        if(chx_len_err == 1'b1 || chx_sop_in_ff1 == 1'b1) begin
            hram_wdata = 11'b0;  
            lram_wdata = 11'b0;
        end else if(chx_eop_in_ff1 == 1'b1) begin
            if(chx_qos_in_ff1 == 1'b1) begin
                hram_wdata = {1'b1,chx_data_in_ff1};
                lram_wdata = 11'b0;
            end else begin
                hram_wdata = 11'b0;
                lram_wdata = {1'b1,chx_data_in_ff1};
            end 
        end
    end

end

always @(*) begin
    hram_wen = 1'b0;
    lram_wen = 1'b0;
    if((next_state == ST_RCV) || (next_state == ST_END)) begin //Confirm whether next_state can be used
        if(chx_qos_in_ff1 == 1'b1) begin
            hram_wen = 1'b1;
            lram_wen = 1'b0;
        end else begin
            hram_wen = 1'b0;
            lram_wen = 1'b1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        pkg_cnt_incr <= 1'b0;
    end else begin
        if(next_state == ST_END)
            pkg_cnt_incr <= 1'b1;
        else 
            pkg_cnt_incr <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        chx_data_in_ff1 <= 8'b0;
        chx_sop_in_ff1  <= 1'b0;
        chx_eop_in_ff1  <= 1'b0;
        chx_qos_in_ff1  <= 1'b0;
        chx_id_in_ff1   <= 3'b0;
    end else begin
        chx_data_in_ff1 <= chx_data_in;
        chx_sop_in_ff1  <= chx_sop_in ;
        chx_eop_in_ff1  <= chx_eop_in ;
        chx_qos_in_ff1  <= chx_qos_in ;
        chx_id_in_ff1   <= chx_id_in  ;
    end
end
 
endmodule