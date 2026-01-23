//This framebuffer is hardwired to contain 96k * 16-Bit words

module Framebuffer (
    input clkA,
    input[15:0] dataInA,
    input[16:0] addressA,
    input writeEnableA,
    output reg[15:0] dataOutA,

    input clkB,
    input[15:0] dataInB,
    input[16:0] addressB,
    input writeEnableB,
    output reg[15:0] dataOutB
);
 
//reg[15:0] memory[16];
//Ein cooler start-up screen ist glaub ich nicht im Rahmen der Möglichkeiten :(
//initial $readmemh("C:/Repos/Hans2/HardwareDesign/Graphicsystem/StartScreen.hex", memory);

RM_IHPSG13_2P_1024x16_c2_bm_bist sram0 (
    .A_CLK  (clkA),
    .A_MEN  (1'b1),
    .A_WEN  (writeEnableA & (addressA[16:10] == 0)),
    .A_REN  (!writeEnableA & (addressA[16:10] == 0)),
    .A_ADDR (addressA[9:0]),
    .A_DIN  (dataInA),
    .A_DLY  (1'b1), // tie high!
    .A_DOUT (dataOutA),
    .A_BM   ({16{1'b1}}),

    .B_CLK  (clkB),
    .B_MEN  (1'b1),
    .B_WEN  (writeEnableB & (addressB[16:10] == 0)),
    .B_REN  (!writeEnableB & (addressB[16:10] == 0)),
    .B_ADDR (addressB[9:0]),
    .B_DIN  (dataInB),
    .B_DLY  (1'b1), // tie high!
    .B_DOUT (dataOutB),
    .B_BM   ({16{1'b1}}),

    // Built-in self test port
    .A_BIST_CLK   ('0),
    .A_BIST_EN    ('0),
    .A_BIST_MEN   ('0),
    .A_BIST_WEN   ('0),
    .A_BIST_REN   ('0),
    .A_BIST_ADDR  ('0),
    .A_BIST_DIN   ('0),
    .A_BIST_BM    ('0),

    .B_BIST_CLK   ('0),
    .B_BIST_EN    ('0),
    .B_BIST_MEN   ('0),
    .B_BIST_WEN   ('0),
    .B_BIST_REN   ('0),
    .B_BIST_ADDR  ('0),
    .B_BIST_DIN   ('0),
    .B_BIST_BM    ('0)
);

/* Fucking generate scheint nicht mit librelane zu funktionieren. Die [xx] Namensgebung macht Probleme.
genvar i;
localparam SRAM_COUNT = 1; //eigentlich 94
generate;
    for (i = 0; i < SRAM_COUNT; i = i + 1) begin : SRAM_Gen
        RM_IHPSG13_1P_1024x32_c2_bm_bist sram (
        .A_CLK  (clkA),
        .A_MEN  (1'b1),
        .A_WEN  (writeEnableA & (addressA[16:10] == i)),
        .A_REN  (!writeEnableA & (addressA[16:10] == i)),
        .A_ADDR (addressA[9:0]),
        .A_DIN  (dataInA),
        .A_DLY  (1'b1), // tie high!
        .A_DOUT (dataOutA),
        .A_BM   ({16{1'b1}}),
        
        // Built-in self test port
        .A_BIST_CLK   ('0),
        .A_BIST_EN    ('0),
        .A_BIST_MEN   ('0),
        .A_BIST_WEN   ('0),
        .A_BIST_REN   ('0),
        .A_BIST_ADDR  ('0),
        .A_BIST_DIN   ('0),
        .A_BIST_BM    ('0)
    );
    end
endgenerate
*/
/*
always @(posedge clkA) begin
    if(writeEnableA)
        memory[addressA] <= dataInA;
    else
        dataOutA <= memory[addressA];
end

always @(posedge clkB) begin
    if(writeEnableB)
        memory[addressB] <= dataInB;
    else
        dataOutB <= memory[addressB];
end
  */  
endmodule