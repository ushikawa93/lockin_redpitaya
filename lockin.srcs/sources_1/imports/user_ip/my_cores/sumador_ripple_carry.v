module ripple_carry_adder(
    input [n-1:0] A, B,
    output [n-1:0] Sum,
    output Carry
);

parameter n = 64; // Número de bits del sumador

// Variables internas
wire [n-1:0] sum_intermediate;
wire [n:0] carry_intermediate;

// Full Adder para la posición menos significativa
full_adder fa0(A[0], B[0], 1'b0, sum_intermediate[0], carry_intermediate[0]);

// Full Adder para las posiciones restantes
genvar i;
generate
    for (i = 1; i < n; i = i + 1) begin: adder_loop
        full_adder fa(
            A[i], B[i], carry_intermediate[i - 1],
            sum_intermediate[i], carry_intermediate[i]
        );
    end
endgenerate

assign Sum = sum_intermediate;
assign Carry = carry_intermediate[n-1];

endmodule

// Definición del Full Adder
module full_adder(
    input A, B, Cin,
    output Sum, Cout
);

assign Sum = A ^ B ^ Cin;
assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule