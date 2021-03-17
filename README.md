# ProcessorArchitectureY86

## Instructions to run the code in ubuntu -

1. Extract all the files to your system
1. Open the folder where your files are in the terminal
1. Run the command iverilog y86processor_tb.v Y86Processor.v
1. Run the command ./a.out
1. Run the command gtkwave y86processor.vcd to get the desired gtkwave output

## Other Instructions 

1. The instrtuction set takes in 10 bytes of input in one cycle 
1. The instruction set can be changed by modyfing the contents 
of __instructions.mem__
1. The desired output can be seen in eValE register. 