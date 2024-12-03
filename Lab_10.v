`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 02:03:22 PM
// Design Name: 
// Module Name: Lab_10
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab_10(input clk, reset, 
                input [2:0] addr1_ROM, addr2_ROM, addr_RAM, 
                output [7:0] result);
    
    //CU wires
    wire w_rf,w_ram;
    wire [2:0] rom_adr, st_out;
    wire DA, SA, SB;
    
    //ROM wires
    wire [3:0] data_ROM;
    
    //RF wires
    wire [3:0] A, B;
    
    //multiplier wires
    wire [7:0] product;
            
    cu uut0(clk, reset, addr1_ROM, addr2_ROM, w_rf, rom_adr, DA, SA, SB, st_out, w_ram);
    ROM uut1(rom_adr, data_ROM);
    RF uut2(A, B, SA, SB, data_ROM, DA, w_rf, reset, clk);
    comb_mult uut3(A, B, product);
    RAM uut4(clk, reset, w_ram, addr_RAM, product, result);
endmodule

module comb_mult(a,b,p);
    input [3:0] a,b;
    output [7:0] p;
    
    wire [3:0] m0;
    wire [4:0] m1;
    wire [5:0] m2;
    wire [6:0] m3;
    wire [7:0] s1,s2,s3;
    
    assign m0 = {4{a[0]}} & b[3:0];
    assign m1 = {4{a[1]}} & b[3:0];
    assign m2 = {4{a[2]}} & b[3:0];
    assign m3 = {4{a[3]}} & b[3:0];
    
    assign s1 = m0 + (m1 << 1);
    assign s2 = s1 + (m2 << 2);
    assign s3 = s2 + (m3 << 3);
    assign p = s3;
endmodule

module RAM(input clk, reset, w_en, 
            input [2:0] addr, 
            input [7:0] w_data,
            output reg [7:0] r_data);
    reg [7:0] mem[0:7];
    
    integer i;
    
    always @ (posedge clk) begin
        if (reset) begin
            for (i=0; i<8; i=i+1) begin
                mem[i] <= 8'b0;
            end
        end
        else begin
            if (w_en)
                mem[addr] <= w_data;
            else
                r_data <= mem[addr];
        end
    end
endmodule

module ROM(input [2:0] addr, output reg [3:0] data);
    always @(*) begin
        case (addr)
            3'd0: data = 4'b0000;
            3'd1: data = 4'b1100;
            3'd2: data = 4'b0110;
            3'd3: data = 4'b0111;
            3'd4: data = 4'b1000;
            3'd5: data = 4'b0001;
            3'd6: data = 4'b1101;
            3'd7: data = 4'b1110;
            default: data = 4'bXXXX;
        endcase
    end
endmodule