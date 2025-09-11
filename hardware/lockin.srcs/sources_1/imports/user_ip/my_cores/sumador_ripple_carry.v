///// ================================================================================= /////  
///// ======================= Módulo RIPPLE_CARRY_ADDER =========================== /////  
///// ================================================================================= /////  
//  
// Este módulo implementa un sumador de n bits con acarreo en serie (Ripple Carry Adder).  
// Permite sumar dos números de n bits generando un resultado de n bits y un bit de acarreo final.
//
// Funcionamiento:  
//   - El bit menos significativo se suma con un full adder inicial con carry de 0.  
//   - Cada bit siguiente utiliza el acarreo generado por el full adder anterior.  
//   - Se genera un vector de suma `Sum` y el bit de acarreo final `Carry`.  
//   - La estructura utiliza un bucle `generate` para instanciar n full adders.
//
// Parámetros:  
//   n : Número de bits de los operandos y del sumador (por defecto 64).  
//
// Puertos:  
//   Entradas:  
//     A    : Primer operando de n bits.  
//     B    : Segundo operando de n bits.  
//
//   Salidas:  
//     Sum  : Resultado de la suma de n bits.  
//     Carry: Bit de acarreo final.  
//
// Notas:  
//   - La latencia del sumador es lineal respecto al número de bits (O(n)) debido al efecto de ripple carry.  
//   - Se utiliza un módulo `full_adder` independiente para cada bit.  
//   - Este sumador es adecuado para FPGAs y ASICs donde la simplicidad es más importante que la velocidad.  
//  
///// ================================================================================= /////  


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