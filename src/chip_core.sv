// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module chip_core #(
    parameter NUM_INPUT_PADS,
    parameter NUM_OUTPUT_PADS
    )(
    input  logic clk,       // clock
    input  logic rst_n,     // reset (active low)
    
    input  wire [NUM_INPUT_PADS -1:0] input_in,   // Input value
    output wire [NUM_OUTPUT_PADS-1:0] output_out // Output value
);
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            output_out <= '0;
        end else begin
            output_out <= {NUM_OUTPUT_PADS{^input_in}};
        end
    end
endmodule

`default_nettype wire
