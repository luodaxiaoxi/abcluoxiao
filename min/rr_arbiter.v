/*
module RR_ARBITER #(
    parameter NUM_REQUESTS = 8  // Number of requesters
)(
    input clk,                 // Clock signal
    input rst_n,               // Reset signal
    input enable,              // Enable signal
    input [NUM_REQUESTS-1:0] request, // Request signals from requesters
    output reg [NUM_REQUESTS-1:0] grant // Grant signals to requesters
);

    reg [NUM_REQUESTS-1:0] next_grant;
    reg [NUM_REQUESTS-1:0] mask;

    always @(posedge clk or posedge rst_n) begin
        if (rst_n == 1'b0) begin
            grant <= 0;
            mask <= {NUM_REQUESTS{1'b1}};
        end else if (enable) begin
            grant <= next_grant;
            if (|next_grant) begin
                mask <= {next_grant[NUM_REQUESTS-2:0], next_grant[NUM_REQUESTS-1]};
            end
        end
    end

    always @(*) begin
        next_grant = 0;
        if (enable && |request) begin
            next_grant = (request & mask);
            if (~|next_grant) begin
                next_grant = request & ~mask;
            end
        end
    end

endmodule
*/

module RR_Arbiter #(
    parameter N = 4  // 参数化请求信号数量，默认值为4
)(
    input wire [N-1:0] req,   // 请求信号
    input wire enable,        // 使能信号
    input wire reset_n,       // 复位信号，低电平有效
    output reg [N-1:0] grant  // 仲裁结果
);
    reg [$clog2(N)-1:0] ptr;  // 轮询指针

    always @(*) begin
        if (!reset_n) begin
            // 复位状态
            grant = {N{1'b0}};
            ptr = 0;
        end else if (enable) begin
            // 使能时进行仲裁
            grant = {N{1'b0}};
            for (integer i = 0; i < N; i = i + 1) begin
                if (req[(ptr + i) % N]) begin
                    grant[(ptr + i) % N] = 1'b1;
                    ptr = (ptr + i + 1) % N;  // 更新轮询指针
                    break;
                end
            end
        end else begin
            // 未使能时保持当前状态
            grant = {N{1'b0}};
        end
    end
endmodule

