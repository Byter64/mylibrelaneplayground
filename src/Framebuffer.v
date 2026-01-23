//This framebuffer is hardwired to contain 96k * 16-Bit words

module Framebuffer (
    input clkA,
    input[15:0] dataInA,
    input[16:0] addressA,
    input writeEnableA,
    output reg[15:0] dataOutA,

    (* keep *)input clkB,
    (* keep *)input[15:0] dataInB,
    (* keep *)input[16:0] addressB,
    (* keep *)input writeEnableB,
    (* keep *)output reg[15:0] dataOutB
);
 
//reg[15:0] memory[16];
//Ein cooler start-up screen ist glaub ich nicht im Rahmen der Möglichkeiten :(
//initial $readmemh("C:/Repos/Hans2/HardwareDesign/Graphicsystem/StartScreen.hex", memory);

assign dataOutB = dataOutA;

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