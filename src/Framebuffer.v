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
  
logic[15:0] dataOutA0; logic[15:0] dataOutB0;
logic[15:0] dataOutA1; logic[15:0] dataOutB1;
logic[15:0] dataOutA2; logic[15:0] dataOutB2;

assign dataOutA = 
				(addressA[16:10] == 0) ? dataOutA0 :
				(addressA[16:10] == 1) ? dataOutA1 :
				(addressA[16:10] == 2) ? dataOutA2 :
				16'h0000;

assign dataOutB = 
				(addressA[16:10] == 0) ? dataOutB0 :
				(addressA[16:10] == 1) ? dataOutB1 :
				(addressA[16:10] == 2) ? dataOutB2 :
				16'h0000;

RM_IHPSG13_2P_1024x16_c2_bm_bist sram0 (
    .A_CLK  (clkA),
    .A_MEN  (1'b1),
    .A_WEN  (writeEnableA & (addressA[16:10] == 0)),
    .A_REN  (!writeEnableA & (addressA[16:10] == 0)),
    .A_ADDR (addressA[9:0]),
    .A_DIN  (dataInA),
    .A_DLY  (1'b1), // tie high!
    .A_DOUT (dataOutA0),
    .A_BM   ({16{1'b1}}),

    .B_CLK  (clkB),
    .B_MEN  (1'b1),
    .B_WEN  (writeEnableB & (addressB[16:10] == 0)),
    .B_REN  (!writeEnableB & (addressB[16:10] == 0)),
    .B_ADDR (addressB[9:0]),
    .B_DIN  (dataInB),
    .B_DLY  (1'b1), // tie high!
    .B_DOUT (dataOutB0),
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

RM_IHPSG13_2P_1024x16_c2_bm_bist sram1 (
    .A_CLK  (clkA),
    .A_MEN  (1'b1),
    .A_WEN  (writeEnableA & (addressA[16:10] == 1)),
    .A_REN  (!writeEnableA & (addressA[16:10] == 1)),
    .A_ADDR (addressA[9:0]),
    .A_DIN  (dataInA),
    .A_DLY  (1'b1), // tie high!
    .A_DOUT (dataOutA1),
    .A_BM   ({16{1'b1}}),

    .B_CLK  (clkB),
    .B_MEN  (1'b1),
    .B_WEN  (writeEnableB & (addressB[16:10] == 1)),
    .B_REN  (!writeEnableB & (addressB[16:10] == 1)),
    .B_ADDR (addressB[9:0]),
    .B_DIN  (dataInB),
    .B_DLY  (1'b1), // tie high!
    .B_DOUT (dataOutB1),
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

RM_IHPSG13_2P_1024x16_c2_bm_bist sram2 (
    .A_CLK  (clkA),
    .A_MEN  (1'b1),
    .A_WEN  (writeEnableA & (addressA[16:10] == 2)),
    .A_REN  (!writeEnableA & (addressA[16:10] == 2)),
    .A_ADDR (addressA[9:0]),
    .A_DIN  (dataInA),
    .A_DLY  (1'b1), // tie high!
    .A_DOUT (dataOutA2),
    .A_BM   ({16{1'b1}}),

    .B_CLK  (clkB),
    .B_MEN  (1'b1),
    .B_WEN  (writeEnableB & (addressB[16:10] == 2)),
    .B_REN  (!writeEnableB & (addressB[16:10] == 2)),
    .B_ADDR (addressB[9:0]),
    .B_DIN  (dataInB),
    .B_DLY  (1'b1), // tie high!
    .B_DOUT (dataOutB2),
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

//reg[15:0] memory[16];
//Ein cooler start-up screen ist glaub ich nicht im Rahmen der Möglichkeiten :(
//initial $readmemh("C:/Repos/Hans2/HardwareDesign/Graphicsystem/StartScreen.hex", memory);


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