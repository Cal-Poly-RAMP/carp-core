module MUL_M (
    input logic [31:0] opA,
    input logic [31:0] opB,
    input logic negate,
    input logic [63:0] E_product,
    output logic [63:0] M_product
);

always_comb begin
    // carry over the results from the previous stage
    M_product = E_product;

    // and continue as before:
    // repeated addition of (opB * each bit of opA)
    for (int i = 11; i < 22; i++) begin
        if (opA[i]) M_product += {32'b0, opB} << i;
    end
end

endmodule
