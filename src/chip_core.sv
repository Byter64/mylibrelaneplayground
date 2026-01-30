// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module chip_core #(
    parameter NUM_INPUT_PADS,
    parameter NUM_OUTPUT_PADS,
    parameter NUM_BIDIR_PADS
    )(
    input  logic clk,       // clock
    input  logic rst_n,     // reset (active low)
    
    input  logic [NUM_INPUT_PADS -1:0] input_in,   // Input value
    output logic [NUM_OUTPUT_PADS-1:0] output_out, // Output value`
    input  logic [NUM_BIDIR_PADS-1 :0] bidir_in,   // Input value
    output logic [NUM_BIDIR_PADS-1 :0] bidir_out,  // Output value
    output logic [NUM_BIDIR_PADS-1 :0] bidir_oe    // Output enable
);

    logic  clk_25mhz;
	//logic  rst_n; //already exists as input
    //Video output
    logic [3:0] gpdi_dp;
 
	logic        sdram_clk;
	logic        sdram_cke;
	logic        sdram_csn;
	logic        sdram_wen;
	logic        sdram_rasn;
	logic        sdram_casn;
	logic[12:0]  sdram_a;
	logic[1:0]   sdram_ba;
	logic[1:0]   sdram_dqm;
	logic[15:0]  sdram_d; 

    //SD Card
    logic        sd_clk;
    logic        sd_cmd;
    logic [3:0]  sd_d;

	//Controller
	logic		c1clock;
	logic		c1latch;
	logic		c1data;
	logic		c2clock;
	logic		c2latch;
	logic		c2data;

	//Buttons for options
	logic[6:0]	btn;

	logic audio_bclk;
	logic audio_lrclk;
	logic audio_dout;

    assign clk_25mhz = clk;
    assign output_out[35:32] = gpdi_dp;
    assign output_out[26] = sdram_clk;
    assign output_out[27] = sdram_cke;
    assign output_out[28] = sdram_csn;
    assign output_out[29] = sdram_wen;
    assign output_out[30] = sdram_rasn;
    assign output_out[31] = sdram_casn;

    assign output_out[21:9] = sdram_a;
    assign output_out[8:7] = sdram_ba;
    assign output_out[23:22] = sdram_dqm;
    
    int i, j;
    always_comb for(i = 0; i < 16; i = i + 1)
        bidir_out[i] = bidir_oe[i] ? sdram_d[i] : 1'bz;
    assign sdram_d = bidir_in[15:0];

    assign output_out[24] = sd_clk;
    assign output_out[25] = sd_cmd;

    always_comb for(j = 16; j < 20; j = j + 1)
        bidir_out[j] = bidir_oe[j] ? sd_d[j] : 1'bz;
    assign sd_d = bidir_in[19:16];

    assign output_out[0] = c1clock;
    assign output_out[1] = c1latch;
    assign c1data = input_in[7];
    assign output_out[2] = c2clock;
    assign output_out[3] = c2latch;
    assign c2data = input_in[8];
    assign btn = input_in[6:0];

    assign output_out[4] = audio_bclk;
    assign output_out[5] = audio_lrclk;
    assign output_out[6] = audio_dout;

    Top wueHans(
        .*
    );

    // Wann muss ich dieses signal ändern ?!?!??! ?!?
    assign bidir_oe = '1;
    
    /*
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            output_out <= '0;
        end else begin
            output_out <= {NUM_OUTPUT_PADS{^input_in}};
            bidir_out <= {NUM_BIDIR_PADS{^input_in}};
        end
    end
*/
endmodule

`default_nettype wire
