// Jump_Ctrl


module Jump_Ctrl( Zero,
                  JumpOP
		// write your code in here
				,opcode,funct);

	input Zero;
	input[5:0]opcode,funct;
	output [1:0] JumpOP;
	reg [1:0] JumpOP;		
	// write your code in here
	
	
always@(opcode or funct or Zero)
	begin
	
	JumpOP =((opcode==6'b000000&&funct==6'b001001)||(opcode==6'b000000&&funct==6'b001000))?2'b10://jr jalr
		((opcode==6'b000100&&Zero==1'b1)||(opcode==6'b000101&&Zero==1'b0))?2'b01://bne bnq	
		(opcode==6'b000010||opcode==6'b000011)?2'b11:2'b00;//j jal:others

	end

	
endmodule





