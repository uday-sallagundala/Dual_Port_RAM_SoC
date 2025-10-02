`timescale 1ns/1ps
module memory_decoder_tb;

    // Inputs
    reg mem_in1, mem_in0;

    // Outputs
    wire mem_out3, mem_out2, mem_out1, mem_out0;

    // Instantiate DUT
    memory_decoder dut (
        .mem_in1(mem_in1),
        .mem_in0(mem_in0),
        .mem_out3(mem_out3),
        .mem_out2(mem_out2),
        .mem_out1(mem_out1),
        .mem_out0(mem_out0)
    );

    // Test vectors
    initial begin
        $display("Starting memory_decoder Test...");

        // Test 00
        mem_in1 = 0; mem_in0 = 0; #5;
        if ({mem_out3, mem_out2, mem_out1, mem_out0} == 4'b0001)
            $display("Input 00: Passed");
        else
            $display("Input 00: Failed - %b", {mem_out3, mem_out2, mem_out1, mem_out0});

        // Test 01
        mem_in1 = 0; mem_in0 = 1; #5;
        if ({mem_out3, mem_out2, mem_out1, mem_out0} == 4'b0010)
            $display("Input 01: Passed");
        else
            $display("Input 01: Failed - %b", {mem_out3, mem_out2, mem_out1, mem_out0});

        // Test 10
        mem_in1 = 1; mem_in0 = 0; #5;
        if ({mem_out3, mem_out2, mem_out1, mem_out0} == 4'b0100)
            $display("Input 10: Passed");
        else
            $display("Input 10: Failed - %b", {mem_out3, mem_out2, mem_out1, mem_out0});

        // Test 11
        mem_in1 = 1; mem_in0 = 1; #5;
        if ({mem_out3, mem_out2, mem_out1, mem_out0} == 4'b1000)
            $display("Input 11: Passed");
        else
            $display("Input 11: Failed - %b", {mem_out3, mem_out2, mem_out1, mem_out0});

        $display("memory_decoder Test Complete!");
        $finish;
    end

endmodule
