 // This module creates Pipeline register. 
 //Uses reset signal to inject bubble When bubbling, 
 //must specify value that will be loaded 
module pipreg1(out, in, stall,bubble, bubbleval, clock);

 parameter width = 8;
 output reg [width-1:0] out;
 input [width-1:0] in;
 input stall,bubble;
 input [width-1:0] bubbleval;
 input clock;

 initial begin 
     out <= bubbleval;
 end
 always @(posedge clock) begin
    if (!stall && !bubble)
        out <= in;
    else if (!stall && bubble)
        out <= bubbleval;
    end
 endmodule

module pipreg2(out, in, stall, bubbleval, clock);

 parameter width = 8;
 output reg [width-1:0] out;
 input [width-1:0] in;
 input stall;
 input [width-1:0] bubbleval;
 input clock;

 initial begin 
     out <= bubbleval;
 end
 always @(posedge clock) begin
    if (!stall)
        out <= in;
    end

 endmodule




// This module creates ALU used in our processor
module alu(aluA, aluB, alufun, valE, new_cc);
 // Data inputs, ALU function, Data Output
input [63:0] aluA, aluB;
input [ 3:0] alufun; 
output [63:0] valE; 
output [ 2:0] new_cc;

parameter ALUADD = 4'h0;
parameter ALUSUB = 4'h1;
parameter ALUAND = 4'h2;
parameter ALUXOR = 4'h3;


assign valE =
    alufun == ALUSUB ? aluB - aluA :
    alufun == ALUAND ? aluB & aluA :
    alufun == ALUXOR ? aluB ^ aluA :
    aluB + aluA;
assign new_cc[2] = (valE == 0); // ZF
assign new_cc[1] = valE[63]; // SF
assign new_cc[0] = // OF
    alufun == ALUADD ?
        (aluA[63] == aluB[63]) & (aluA[63] != valE[63]) :
    alufun == ALUSUB ?
        (~aluA[63] == aluB[63]) & (aluB[63] != valE[63]) :
    0;
endmodule

// Condition code register is defined here
module cc(cc, new_cc, set_cc, reset, clock);
output[2:0] cc;
input [2:0] new_cc;
input set_cc;
input reset;
input clock;

pipreg2 #(3) c(cc, new_cc, ~set_cc, 3'b100, clock);
endmodule

// branch condition logic is defined here
module cond(ifun, cc, Cnd);
input [3:0] ifun;
input [2:0] cc;
output Cnd;

wire zf = cc[2];
wire sf = cc[1];
wire of = cc[0];

// Jump & move conditions are defined here
parameter C_YES = 4'h0;
parameter C_LE = 4'h1;
parameter C_L = 4'h2;
parameter C_E = 4'h3;
parameter C_NE = 4'h4;
parameter C_GE = 4'h5;
parameter C_G = 4'h6;

assign Cnd =
(ifun == C_YES) | //
(ifun == C_LE & ((sf^of)|zf)) | // less than equal to condition
(ifun == C_L & (sf^of)) | // less than condition
(ifun == C_E & zf) | // equal to condition
(ifun == C_NE & ~zf) | // not equal to condition
(ifun == C_GE & (~sf^of)) | // greater than equal to condition
(ifun == C_G & (~sf^of)&~zf); // greater than condition

endmodule
