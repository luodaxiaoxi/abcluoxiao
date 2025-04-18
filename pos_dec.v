module pos_dec(
    input clk,
    input rst_n,
    input [15:0] adc_code0,
    input [15:0] adc_code1,
    input [15:0] adc_code2,
    input [15:0] adc_code3,

    input [4:0]  pos_th,

    output reg[2:0] err_cnt,
    output reg err_vld
)

wire has_zero;
wire has_max;
reg zero_flag;
reg[4:0] cnt;

assign has_zero =(adc_code0==0) |(adc_code1==0)| (adc_code2==0) |(adc_code3==0);

assign has_max =(adc_code0==16'hffff) |(adc_code1==16'hffff)| (adc_code2==16'hffff) |(adc_code3==16'hffff);

assign err_cnt = (err_vld==1)?1:0;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)
        zero_flag <= 1'b0;
    else if(zero_flag==0)begin//当前没有起点
        if(has_zero)
            zero_flag <=1;
        else ;
    end
    else begin // zero_flag=1 当前有起点
        if(has_zero==0 & has_max=1)
            zero_flag<=0;
        else if(has_zero==1 && has_max==0)
            zero_flag<=1; //又出现0，刷新起点
        else begin//科目一，只可能出现f在前，零在后。 如果零在前，f在后就出现同排了。
            zero_flag<=1;
        end
    end
end

always@(posedge clk or negedge rst_n)begin//记录0到ffff前一拍持续时间，当ffff出现时用ffff位置+cnt去和th比较
    if(rst_n==1'b0)
        cnt <= 5'b0;
    else if(zero_flag==0)begin
        if(has_zero)
            if(adc_code3==0)//先判断最后一个,因为就算判断前面的，如果后面的为0也会刷
                cnt<=0;
            else if(adc_code2==0)
                cnt<=1;
            else if(adc_code1==0)
                cnt<=2;
            else
                cnt<=3;
        else ;
    end
    else begin // zero_flag=1
        if(has_zero==0 & has_max=1)
            cnt=0;
        else if(has_zero==1 && has_max==0)
            if(adc_code3==0)//先判断最后一个,因为就算判断前面的，如果后面的为0也会刷
                cnt<=0;
            else if(adc_code2==0)
                cnt<=1;
            else if(adc_code1==0)
                cnt<=2;
            else
                cnt<=3;
        else begin//科目一，只可能出现f在前，零在后。 如果零在前，f在后就出现同排了。
            if(adc_code3==0)//先判断最后一个,因为就算判断前面的，如果后面的为0也会刷
                cnt<=0;
            else if(adc_code2==0)
                cnt<=1;
            else if(adc_code1==0)
                cnt<=2;
            else ;//else进不去不可能在第一个
        end
    end
end

always@(*) begin
    err_vld=0;
    if(zero_flag==1)begin
        if(has_max) begin
            if(adc_code0==16'hffff)
                err_vld=(cnt+1<=pos_th)?1:0;
            else if(adc_code1==16'hffff)
                err_vld=(cnt+2<=pos_th)?1:0;
            else if(adc_code2==16'hffff)
                err_vld=(cnt+3<=pos_th)?1:0;
            else if(adc_code3==16'hffff)
                err_vld=(cnt+4<=pos_th)?1:0;
        end
    end
end
endmodule