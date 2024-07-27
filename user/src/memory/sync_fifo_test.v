`timescale 1 ns / 1 ns

module sync_fifo_test #(
        parameter WIDTH=32,
        parameter DEPTH=1<<9
    ) (
        input clock,
        input reset,
        input clear,

        input      [WIDTH-1:0]  i_tdata,
        input                   i_tvalid,
        output                  i_tready,

        output reg [WIDTH-1:0]  o_tdata,
        output reg              o_tvalid,
        input                   o_tready,

        output reg [15:0]       space,
        output reg [15:0]       occupied
    );

    wire [WIDTH-1:0]     int_tdata;
    wire 	             int_tready;

    wire full;
    wire empty;
    wire write      = i_tvalid & i_tready;
    // read_int will assert when either a read occurs or the output register is empty 
    // (and there is data in the shift register fifo)
    wire read_int   = ~empty & int_tready;
    // read will only assert when an actual 1read request occurs at the interface
    wire read       = o_tready & o_tvalid;

    assign i_tready = ~full;

    // Read side states
    localparam 	  ST_EMPTY = 0;
    localparam 	  PRE_READ = 1;
    localparam 	  READING  = 2;

    reg [$clog2(DEPTH)-1:0] wr_addr;
    reg [$clog2(DEPTH)-1:0] rd_addr;
    reg [1:0] 	            read_state;

    reg empty_reg;
    reg full_reg;
    always @(posedge clock or posedge reset) begin
        if(reset) begin
            wr_addr <= 0;
        end
        else if(clear) begin
            wr_addr <= 0;
        end
        else if(write) begin
            wr_addr <= wr_addr + 1;
        end
    end

    DPRAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH))
    u_ram (
        .clka(clock),
        .ena(1'b1),
        .wea(write),
        .addra(wr_addr),
        .dina(i_tdata),
        .douta(),

        .clkb(clock),
        .enb((read_state==PRE_READ)|read_int),
        .web(1'b0),
        .addrb(rd_addr),
        .dinb({WIDTH{1'b1}}),
        .doutb(int_tdata)
    );

    always @(posedge clock or posedge reset) begin
        if(reset) begin
            read_state <= ST_EMPTY;
            rd_addr <= 0;
            empty_reg <= 1;
        end
        else begin
            if(clear) begin
                read_state <= ST_EMPTY;
                rd_addr <= 0;
                empty_reg <= 1;
            end
            else begin                
                case(read_state)
                    ST_EMPTY :
                        if(write) begin
                            //rd_addr <= wr_addr;
                            read_state <= PRE_READ;
                        end
                    PRE_READ : begin
                        read_state <= READING;
                        empty_reg <= 0;
                        rd_addr <= rd_addr + 1;
                    end

                    READING :
                        if(read_int) begin                            
                            if(rd_addr == wr_addr) begin
                                empty_reg <= 1;
                                if(write) begin
                                    read_state <= PRE_READ;
                                end
                                else begin
                                    read_state <= ST_EMPTY;
                                end
                            end
                            else begin
                                rd_addr <= rd_addr + 1;
                            end
                        end
                endcase // case(read_state)
            end
        end
    end

    wire [$clog2(DEPTH)-1:0] dont_write_past_me = rd_addr - 2;
    wire 	                 becoming_full = (wr_addr == dont_write_past_me);

    always @(posedge clock or posedge reset) begin
        if(reset) begin
            full_reg <= 0;
        end
        else if(clear) begin
            full_reg <= 0;
        end
        else if(read_int & ~write) begin
            full_reg <= 0;
        end
        else if(write & ~read_int & becoming_full) begin
            full_reg <= 1;
        end
    end

    //assign empty = (read_state != READING);
    assign empty = empty_reg;

    // assign full = ((rd_addr - 1) == wr_addr);
    assign full = full_reg;

    // Output registered stage
    always @(posedge clock or posedge reset) begin
        // Valid flag
        if (reset | clear) begin
            o_tdata <= 0;
            o_tvalid <= 1'b0;
        end
        else begin            
            if (int_tready) begin
                o_tvalid <= ~empty;
            end

            // Data
            if (int_tready) begin
                o_tdata <= int_tdata;
            end
        end
    end

    assign int_tready = o_tready | ~o_tvalid;

    //////////////////////////////////////////////
    // space and occupied are for diagnostics only
    // not guaranteed exact

    always @(posedge clock or posedge reset) begin
        if(reset) begin
            space <= DEPTH;
        end
        else if(clear) begin
            space <= DEPTH;
        end
        else if(read & ~write) begin
            space <= space + 16'b1;
        end
        else if(write & ~read) begin
            space <= space - 16'b1;
        end
    end

    always @(posedge clock or posedge reset) begin
        if(reset) begin
            occupied <= 16'b0;
        end
        else if(clear) begin
            occupied <= 16'b0;
        end
        else if(read & ~write) begin
            occupied <= occupied - 16'b1;
        end
        else if(write & ~read) begin
            occupied <= occupied + 16'b1;
        end
    end

endmodule // fifo_long
