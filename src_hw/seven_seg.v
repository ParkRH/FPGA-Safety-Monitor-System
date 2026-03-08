`default_nettype none

module seven_seg(
    input  wire clk,
    input  wire reset,
    input  wire [15:0] number, 
    output reg  [6:0] seg,
    output reg  [3:0] an
    );

   
    localparam integer TIMER_LIMIT = 100000;
    reg [16:0] timer_cnt = 0;
    reg [1:0]  digit_select = 0;

    always @(posedge clk) begin
        if (reset) begin
            timer_cnt <= 0;
            digit_select <= 0;
        end else begin
            if (timer_cnt == TIMER_LIMIT - 1) begin
                timer_cnt <= 0;
                digit_select <= digit_select + 1;
            end else begin
                timer_cnt <= timer_cnt + 1;
            end
        end
    end


    reg [6:0] char_pattern; 
    always @(*) begin

        if (number <= 5000) begin

            case (digit_select)
                2'b00: char_pattern = 7'b000_0110; 
                2'b01: char_pattern = 7'b000_1110; 
                2'b10: char_pattern = 7'b000_1000; 
                2'b11: char_pattern = 7'b001_0010; 
            endcase
        end
        else if (number <= 8000) begin
            case (digit_select)
                2'b00: char_pattern = 7'b010_1011; 
                2'b01: char_pattern = 7'b010_1011; 
                2'b10: char_pattern = 7'b010_1111; 
                2'b11: char_pattern = 7'b100_0001; 
            endcase
        end
        else begin
            case (digit_select)
                2'b00: char_pattern = 7'b111_1111; 
                2'b01: char_pattern = 7'b010_1111; 
                2'b10: char_pattern = 7'b010_1111; 
                2'b11: char_pattern = 7'b000_0110; 
            endcase
        end
    end


    always @(*) begin
        seg = char_pattern; 
    end


    always @(*) begin
        case (digit_select)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
        endcase
    end

endmodule
