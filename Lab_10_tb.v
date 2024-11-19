`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 02:23:09 PM
// Design Name: 
// Module Name: Lab_10_tb
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


module Lab_10_tb( );
    reg clk, reset;
    reg [2:0] addr1_ROM, addr2_ROM, addr_RAM;
    wire [7:0] result;
    
    always #1 clk=~clk;
    Lab_10 uut( clk, reset, addr1_ROM, addr2_ROM, addr_RAM, result);
    
    initial begin
        reset = 1;
        clk = 0;
        #10
        addr1_ROM = 2;
        addr2_ROM = 3;
        addr_RAM = 1;
        #10 
        reset = 0;
    end
endmodule

module RF_tb();
    wire [3:0]A; // A bus
	wire [3:0]B; // B bus
	reg SA; // Select A - A Address
	reg SB; // Select B - B Address
	reg [3:0]D; // Data input
	reg DA; // Data destination address
	reg W; // write enable
	reg rst; // positive logic asynchronous reset
	reg clk;
	
	RF uut3(A, B, SA, SB, D, DA, W, rst, clk);
	
	always #1 clk=~clk;
	
	initial begin
	   clk=0;
	   rst=1;
	   SA=1;
	   SB=1;
	   DA=1;
	   D=10;
	   W=0;
	   #10
	   rst=0;
	   W=1;
	   #10
	   SA=0;
	   SB=1;
	   DA=0;
	   D=4;
	   
	end
endmodule

module CU_tb();
    reg clk, reset;
    reg [2:0] adr1;
    reg [2:0] adr2;
    wire  w_rf;
    wire [2:0] adr;
    wire DA,SA,SB;
    wire [2:0] st_out;
    wire [2:0] w_ram;
    
    cu uut2(clk, reset, adr1, adr2, w_rf, adr, DA, SA, SB, st_out, w_ram);
    
    always #1 clk = ~clk;
    
    initial begin
        reset = 1;
        clk = 0;
        #10
        adr1 = 2;
        adr2 = 3;
        #10 
        reset = 0;
        #30
        reset = 1;
    end
endmodule

module RAM_tb();
    reg clk, reset, w_en;
    reg [2:0] RAM_addr;
    reg [3:0] w_data;
    wire [3:0] r_data;
    
    RAM uut1(clk, reset, w_en, RAM_addr, w_data, r_data);
    
    always #1 clk = ~clk;
    
    integer i;
    
    initial begin
        clk = 0;
        reset = 1;
        w_en = 1;
        #10
        RAM_addr = 4;
        w_data = 2;
        #10
        reset = 0;
        //write loop
        for (i=0; i<8; i=i+1) begin
            #10; RAM_addr = i;
            w_data = i*2;
        end
        //read loop
        #10
        w_en = 0;
        for (i=0; i<8; i=i+1) begin
            #10; RAM_addr = i;
        end
        #10 $stop;
    end
endmodule

module ROM_tb();
    wire [3:0] ROM_data;
    reg [2:0] ROM_addr;
    
    ROM uut0(ROM_addr, ROM_data);
    
    integer i;
    
    initial begin
        for (i=0; i<8; i=i+1) begin
            #10; ROM_addr = i;
        end
    end
endmodule