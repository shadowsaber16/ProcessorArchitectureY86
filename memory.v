// The module defines the memory block of the processor
module data_memory(mem_addr,M_valA,mem_read,mem_write,mem_data,dmem_error);

input [63:0] mem_addr;
input [63:0] M_valA;
input mem_read;
input mem_write;
output reg [63:0] mem_data;
output reg dmem_error;
reg [63:0] mem [8191:0];

initial begin
    dmem_error <= 0;
end

always @ (mem_addr,M_valA,mem_read,mem_write) begin 
    if (mem_write && !mem_read)
        mem[mem_addr] = M_valA;
    if (!mem_write && mem_read)
        mem_data = mem[mem_addr];
    end
endmodule
