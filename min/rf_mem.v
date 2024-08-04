
//深度为16、位宽为4的伪双端口RAM
module RF_MEM #(
    parameter 	ADDR_WIDTH=4,
    parameter 	DATA_WIDTH=4,
    parameter 	DEPTH=16
    )(    
    input             clk,
    input             rst_n,

    input      	      				   wr_en, //写使能
    input      	      [ADDR_WIDTH-1:0] addr_a, //a端写地址            
    input  	      	  [DATA_WIDTH-1:0] data_a,//a端写数据

    input                              re_en, //读使能  
    input      	      [ADDR_WIDTH-1:0] addr_b, //b端读地址         
    output   reg      [DATA_WIDTH-1:0] data_b//b端读数据
    );

//定义一个深度为16、位宽为4的伪双端口RAM
reg [DATA_WIDTH-1:0]    ram_data [DEPTH-1:0];  

    integer i;
    always@(posedge clk or posedge rst_n) begin
        if(rst_n) begin
            for(i = 0; i <= DEPTH - 1; i = i + 1) begin: initial_a
                ram_data[i] <= 'd0;
            end
        end
        else if (wr_en) begin   
             ram_data[addr_a] <= data_a;   
        end
    end

//b端读出数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin       
        data_b <= 0;
    end
    else if(re_en) begin 
        data_b <= ram_data[addr_b];  
    end
    else begin
        data_b <= data_b;
    end
end

endmodule
