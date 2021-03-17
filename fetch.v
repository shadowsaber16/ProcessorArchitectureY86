// To give set of instructions to our processor as input
module InstructionMemory(f_pc,f_ibyte,f_ibytes,imem_error);
    input [63:0] f_pc;
    output reg[71:0] f_ibytes;
    output reg[7:0] f_ibyte;
    output reg imem_error;
    reg [7:0] instruction_mem [2047:0];

    initial 
        begin
            $readmemh("./instructions.mem", instruction_mem);
            $display("init");
        end
    always @(f_pc)
    begin
        $display(instruction_mem[f_pc]);
        f_ibyte <= instruction_mem[f_pc];
        f_ibytes[71:64] <= instruction_mem[f_pc+1];
        f_ibytes[63:56] <= instruction_mem[f_pc+2];
        f_ibytes[55:48] <= instruction_mem[f_pc+3];
        f_ibytes[47:40] <= instruction_mem[f_pc+4];
        f_ibytes[39:32] <= instruction_mem[f_pc+5];
        f_ibytes[31:24] <= instruction_mem[f_pc+6];
        f_ibytes[23:16] <= instruction_mem[f_pc+7];
        f_ibytes[15:8] <= instruction_mem[f_pc+8];
        f_ibytes[7:0] <= instruction_mem[f_pc+9];

        imem_error <= (f_pc < 64'd0 || f_pc > 64'd2047 ) ? 1'b1:1'b0;
    end

endmodule
// Splitting module to generate icode and ifun
module split(f_ibyte, f_icode, f_ifun);
input [7:0] f_ibyte;
output [3:0] f_icode;
output [3:0] f_ifun;
assign f_icode = f_ibyte[7:4];
assign f_ifun = f_ibyte[3:0];
endmodule

// This module helps to extract the required 9 bit word in order to proceed
module align(f_ibytes, need_regids, rA, rB, valC);
input [71:0] f_ibytes;
input need_regids;
output [ 3:0] rA;
output [ 3:0] rB;
output [63:0] valC;
assign rA = f_ibytes[71:68];
assign rB = f_ibytes[67:64];
assign valC = need_regids ? f_ibytes[63:0] : f_ibytes[71:8];
endmodule

// This module increments the count of PC as per our requirements
module pc_increment(pc, need_regids, need_valC, valP);
input [63:0] pc;
input need_regids;
input need_valC;
output [63:0] valP;
assign valP = pc + 1 + 8*need_valC + need_regids;
endmodule