module EX_WB_reg (
    input clk,
    input reset,
    input [31:0] alu_result_in,
    input [4:0]  write_reg_in,   // The destination register address (rd)
    input        reg_write_in,   // Control signal: Should we write?
    output reg [31:0] alu_result_out,
    output reg [4:0]  write_reg_out,
    output reg        reg_write_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            write_reg_out  <= 5'b0;
            reg_write_out  <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            write_reg_out  <= write_reg_in;
            reg_write_out  <= reg_write_in;
        end
    end
endmodule

