module tb_divider();

parameter DIVIDEND_WIDTH = 32;
parameter DIVISOR_WIDTH  = 24;

parameter MAIN_FRE   = 100; //unit MHz
reg                   sys_clk = 0;
reg                   sys_rst = 0;

always begin
    #(500/MAIN_FRE) sys_clk = ~sys_clk;
end

always begin
    #50 sys_rst = 1;
end

reg [DIVIDEND_WIDTH - 1 : 0] dividend;
reg [DIVISOR_WIDTH  - 1 : 0] divisor;
reg                          ivalid;

wire [DIVIDEND_WIDTH-1:0] 	quotient;
wire                      	ovalid;

task test;
    input [DIVIDEND_WIDTH - 1 : 0] ina;
    input [DIVISOR_WIDTH  - 1 : 0] inb;

    begin
        @(posedge sys_clk);
        dividend <= ina;
        divisor  <= inb;
    end
endtask

initial begin
    ivalid = 1'b0;
    test(32'd0,24'd0);
    #200
    ivalid = 1'b1;
    test(32'd123,24'd7);      //17
    test(32'd435,24'd25);     //17
    test(32'd537,24'd13);     //41
    test(32'd18,24'd6);       //3
    test(32'd63,24'd3);       //21
    test(32'd211,24'd11);     //19
    test(32'd35,24'd7);       //5
    test(32'd313,24'd5);      //62
    test(32'd207,24'd21);     //9
    test(32'd358,24'd6);      //59

    test(-32'd123,24'd7);    //-17
    test(-32'd252,24'd3);    //-84
    test(-32'd693,24'd15);   //-46
    test(-32'd742,24'd29);   //-25
    test(-32'd455,24'd9);    //-50
    test(-32'd633,24'd14);   //-45
    test(-32'd509,24'd19);   //-26
    test(-32'd871,24'd33);   //-26
    test(-32'd937,24'd46);   //-20
    test(-32'd756,24'd23);   //-32

    test(-32'd339,-24'd17);  //19
    test(-32'd842,-24'd8);   //105
    test(-32'd595,-24'd24);  //24
    test(-32'd852,-24'd36);  //23
    test(-32'd945,-24'd41);  //23
    test(-32'd321,-24'd28);  //11
    test(-32'd194,-24'd9);   //21
    test(-32'd546,-24'd12);  //45
    test(-32'd489,-24'd13);  //37
    test(-32'd973,-24'd18);  //54

    test(32'd457,24'd7);     //65
    test(32'd666,24'd9);     //74
    #10
    ivalid = 1'b0;
end

divider #(
	.DIVIDEND_WIDTH 	( DIVIDEND_WIDTH  ),
	.DIVISOR_WIDTH  	( DIVISOR_WIDTH  ))
u_divider(
	.sys_clk  	( sys_clk   ),
	.sys_rst  	( sys_rst   ),
	.dividend 	( dividend  ),
	.divisor  	( divisor   ),
	.ivalid   	( ivalid    ),
	.quotient 	( quotient  ),
	.ovalid   	( ovalid    )
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, tb_divider);    
    #50000 $finish;
end

endmodule  //TOP
