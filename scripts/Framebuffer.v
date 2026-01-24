//This framebuffer is hardwired to contain 96k * 16-Bit words
//I would need 94 x 2kB SRAMs to realise this
module Framebuffer (
    input clkA,
    input[15:0] dataInA,
    input[16:0] addressA,
    input writeEnableA,
    output [15:0] dataOutA,

    input clkB,
    input[15:0] dataInB,
    input[16:0] addressB,
    input writeEnableB,
    output [15:0] dataOutB
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