module Multiplier #(
    parameter N = 4
) (
    input wire clk,
    input wire rst_n,

    input wire start,
    output reg ready,

    input wire   [N-1:0] multiplier, // B
    input wire   [N-1:0] multiplicand, // A
    output reg [2*N-1:0] product // Acumulador
);

// Registradores internos
reg [N-1:0] multiplier_reg;
reg [2*N-1:0] multiplicand_reg;
reg [2*N-1:0] product_reg;
reg executando;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // Lógica de reset
        multiplier_reg <= 0;
        multiplicand_reg <= 0;
        product_reg <= 0;
        product <= 0;
        ready <= 0;
        executando <= 0;
    end else begin
        if(start) begin
            multiplier_reg <= multiplier; // Adicionando valores aos registradores internos
            multiplicand_reg <= multiplicand;
            product_reg <= 0;
            ready <= 0;
            executando <= 1;
        end else if(executando) begin
            if(multiplier_reg != 0) begin // Enquanto o multiplicador não for zero
                if(multiplier_reg[0]) begin // Se o bit menos significativo do multiplicador for 1
                    // Adiciona o multiplicando ao produto
                    product_reg <= product_reg + multiplicand_reg;
                end
                multiplier_reg <= multiplier_reg >> 1; // Desloca o multiplicador para a direita
                multiplicand_reg <= multiplicand_reg << 1; // Desloca o multiplicando para a esquerda
            end else begin // Caso o multiplicador seja zero, ou seja, ele terminou
                product <= product_reg;
                ready <= 1;
                executando <= 0;
            end
        end else begin
            ready <= 0;
        end
    end
end

endmodule
