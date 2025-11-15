module MUL_W (
    input logic [31:0] opA,
    input logic [31:0] opB,
    input logic negate,
    input logic [1:0] mul_op, // 00=MUL, 01
    input logic [63:0] M_product,
    output logic [31:0] rd
);

logic [63:0] W_product;
logic [63:0] corrected;

always_comb begin
    // carry over the results from the previous stage
    W_product = M_product;

    // and continue as before:
    // repeated addition of (opB * each bit of opA)
    for (int i = 22; i < 32; i++) begin
        if (opA[i]) W_product += {32'b0, opB} << i;
    end

    // Apply negate if needed
    corrected = negate ? (~W_product + 1) : W_product;
end

// Output select
always_comb begin
    case (mul_op)
        2'b00: rd = corrected[31:0];   // MUL
        2'b01: rd = corrected[63:32];  // MULH
        2'b10: rd = corrected[63:32];  // MULHSU
        2'b11: rd = corrected[63:32];  // MULHU
    endcase
end


endmodule
