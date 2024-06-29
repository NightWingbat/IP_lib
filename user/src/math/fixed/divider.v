module divider #(
    parameter DIVIDEND_WIDTH = 32,
    parameter DIVISOR_WIDTH  = 24
) (
    input                               sys_clk,
    input                               sys_rst,

    input      [DIVIDEND_WIDTH - 1 : 0] dividend,
    input      [DIVISOR_WIDTH  - 1 : 0] divisor,
    input                               ivalid,

    output     [DIVIDEND_WIDTH - 1 : 0] quotient,
    output reg                          ovalid
);

reg                               sign[DIVIDEND_WIDTH : 0];
reg [DIVIDEND_WIDTH * 2 - 1 : 0]  remainder[DIVIDEND_WIDTH : 0];
reg [DIVIDEND_WIDTH * 2 - 1 : 0]  divisor_in[DIVIDEND_WIDTH : 0];
reg                               valid_in[DIVIDEND_WIDTH : 0];
reg [DIVIDEND_WIDTH - 1 : 0]      quotient_d1[DIVIDEND_WIDTH : 0];

wire [DIVIDEND_WIDTH - 1 : 0]     dividend_in;
wire [DIVIDEND_WIDTH * 2 - 1 : 0] remainder_shift[DIVIDEND_WIDTH - 1 : 0];

assign                            dividend_in = dividend[DIVIDEND_WIDTH - 1] ? ~(dividend - 1'b1) : dividend;

//capture input data and conversion
always @(posedge sys_clk or negedge sys_rst) begin
    if(sys_rst == 1'b0)begin
        sign[0] <= 1'b0;
    end
    else begin
        sign[0] <= dividend[DIVIDEND_WIDTH - 1] ^ divisor[DIVISOR_WIDTH  - 1];
    end
end

always @(posedge sys_clk or negedge sys_rst) begin
    if(sys_rst == 1'b0)begin
        remainder[0] <= 1'b0;
    end
    else begin
        remainder[0] <= {{(DIVIDEND_WIDTH){1'b0}},dividend_in};
    end
end

always @(posedge sys_clk or negedge sys_rst) begin
    if(sys_rst == 1'b0)begin
        divisor_in[0]                                                      <= 1'b0;
    end
    else if(divisor[DIVISOR_WIDTH - 1])begin
        divisor_in[0][DIVIDEND_WIDTH + DIVISOR_WIDTH - 1 : DIVIDEND_WIDTH] <= ~(divisor - 1'b1);
    end
    else begin
        divisor_in[0][DIVIDEND_WIDTH + DIVISOR_WIDTH - 1 : DIVIDEND_WIDTH] <= divisor;
    end
end

always @(posedge sys_clk or negedge sys_rst) begin
    if(sys_rst == 1'b0)begin
        quotient_d1[0] <= 1'b0;
    end
end

always @(posedge sys_clk or negedge sys_rst) begin
    if(sys_rst == 1'b0)begin
        valid_in[0] <= 1'b0;
    end
    else begin
        valid_in[0] <= ivalid;
    end
end

/*

                          dividend > divisor: remainder = dividend - dividor
shift_left + compare ----
                          dividend < dividor: remainder = dividend

*/

genvar i;

generate for(i = 0 ; i < DIVIDEND_WIDTH; i = i + 1) begin : recovery_remainder
    
    //sign
    always @(posedge sys_clk or negedge sys_rst) begin
        if(sys_rst == 1'b0)begin
            sign[i+1] <= 1'b0;
        end
        else begin
            sign[i+1] <= sign[i];
        end
    end

    //remainder
    assign remainder_shift[i] = remainder[i] << 1;

    always @(posedge sys_clk or negedge sys_rst) begin
        if(sys_rst == 1'b0)begin
            remainder[i+1] <= 1'b0;
        end
        else if(remainder_shift[i] >= divisor_in[i])begin
            remainder[i+1] <= remainder_shift[i] - divisor_in[i];
        end
        else begin
            remainder[i+1] <= remainder_shift[i];
        end
    end

    //quotient_d1
    always @(posedge sys_clk or negedge sys_rst) begin
        if(sys_rst == 1'b0)begin
            quotient_d1[i+1]        <= 1'b0;
        end
        else if(valid_in[i+1])begin
            if(remainder_shift[i] >= divisor_in[i])begin
                quotient_d1[i+1]    <= quotient_d1[i] << 1;
                quotient_d1[i+1][0] <= 1'b1;
            end
            else begin
                quotient_d1[i+1]    <= quotient_d1[i] << 1;
                quotient_d1[i+1][0] <= 1'b0;
            end
        end
        else begin
            quotient_d1[i+1]        <= quotient_d1[i+1];
        end
    end

    //divisor_in
    always @(posedge sys_clk or negedge sys_rst) begin
        if(sys_rst == 1'b0)begin
            divisor_in[i+1] <= 1'b0;
        end
        else begin
            divisor_in[i+1] <= divisor_in[i];
        end
    end

    //valid_in
    always @(posedge sys_clk or negedge sys_rst) begin
        if(sys_rst == 1'b0)begin
            valid_in[i+1] <= 1'b0;
        end
        else begin
            valid_in[i+1] <= valid_in[i];
        end
    end
end
endgenerate

//output
always @(posedge sys_clk or negedge sys_rst) begin
    if(sys_rst == 1'b0)begin
        ovalid <= 1'b0;
    end
    else begin
        ovalid <= valid_in[DIVIDEND_WIDTH];
    end
end

assign quotient = sign[DIVIDEND_WIDTH] ? ~quotient_d1[DIVIDEND_WIDTH] + 1'b1 : quotient_d1[DIVIDEND_WIDTH];

endmodule