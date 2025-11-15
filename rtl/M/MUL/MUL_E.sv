
module MUL_E (
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [1:0] mul_op, // 00=MUL, 01
    output logic [63:0] E_product,
    output logic negate,
    output logic [31:0] opA,
    output logic [31:0] opB
);

always_comb begin
    // initialize sum to 0
    E_product = 64'b0;

    // slight variations in logic for different ops & 2's complement
    case (mul_op)
        2'b00: begin // MUL
            opA    = (rs1[31]) ? (~rs1 + 1) : rs1;  // abs
            opB    = (rs2[31]) ? (~rs2 + 1) : rs2;
            negate = rs1[31] ^ rs2[31];
        end
        2'b01: begin // MULH
            opA    = (rs1[31]) ? (~rs1 + 1) : rs1;
            opB    = (rs2[31]) ? (~rs2 + 1) : rs2;
            negate = rs1[31] ^ rs2[31];
        end
        2'b10: begin // MULHSU
            opA    = (rs1[31]) ? (~rs1 + 1) : rs1; // signed
            opB    = rs2;                           // unsigned
            negate = rs1[31];
        end
        2'b11: begin // MULHU
            opA    = rs1;
            opB    = rs2;
            negate = 1'b0;
        end
    endcase

    // repeated addition of (opB * each bit of opA)
    for (int i = 0; i < 11; i++) begin
        if (opA[i]) E_product += {32'b0, opB} << i;
    end
end


endmodule
