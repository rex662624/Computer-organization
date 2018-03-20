// Controller


module Controller ( opcode,
					funct
					// write your code in here
					,RegWrite,MemWrite
					,ALUOp,ALUSrc
					,MemRead,MemtoReg,RegDst
					,to_reg31
					,SH,LH
					);

	input  [5:0] opcode;
	input  [5:0] funct;


	// write your code in here


	output RegWrite,MemWrite,ALUSrc,MemRead,RegDst,to_reg31,MemtoReg,SH,LH;
	reg RegWrite,MemWrite,ALUSrc,MemRead,RegDst,to_reg31,MemtoReg,SH,LH;
	output [3:0]ALUOp;
	reg	[3:0]ALUOp;
	always@(opcode or funct)begin
	 ALUOp <=(opcode==6'b000000&&funct==6'b100110)?4'b0011://XOR
	(opcode==6'b000000&&funct==6'b100000)?4'b0010://add
	(opcode==6'b000000&&funct==6'b100010)?4'b0110://sub
	(opcode==6'b000000&&funct==6'b100100)?4'b0000://and
	(opcode==6'b000000&&funct==6'b100101)?4'b0001://or
	(opcode==6'b000000&&funct==6'b100111)?4'b1100://nor
	(opcode==6'b000000&&funct==6'b101010)?4'b0111://slt
	(opcode==6'b000000&&funct==6'b000000)?4'b0100://sll
	(opcode==6'b000000&&funct==6'b000010)?4'b0101://srl
	(opcode==6'b001100)?4'b0000://andi
	(opcode==6'b001010)?4'b0111://slti	
	(opcode==6'b000100)?4'b0110://beq
	(opcode==6'b000101)?4'b0110://bne
	(funct==001000||funct==001001||opcode==000010||opcode==000011)?4'b1111://jr jalr jal j
	4'b0010;//lw,sw,lh,sh
	

	RegWrite <= (opcode==6'b000000&&funct!=001000)?1:
		 	  (opcode==6'b001000)?1:
		 	  (opcode==6'b001100)?1:
		 	  (opcode==6'b001010)?1:
		 	  (opcode==6'b100011)?1:
		 	  (opcode==6'b100001)?1:
   			  (opcode==6'b000011)?1:0;
			  

	MemWrite <= (opcode==6'b101011)?1:
		          (opcode==6'b101001)?1:0;
	
	ALUSrc <= (opcode==6'b000000)?0:
			(opcode==6'b000100)?0:
			(opcode==6'b000101)?0:1;

	/*assign Branch = (opcode==6'b000101)?1:
			(opcode==6'b000100)?1:0;*/

	MemRead <= (opcode==6'b100011)?1:
			 (opcode==6'b100001)?1:0;
	

 	MemtoReg <= (opcode==6'b100011)?1:
			  (opcode==6'b100001)?1:0;

	RegDst <= (opcode==6'b000000)?1:0;
	
	to_reg31 <= (funct==6'b001001||opcode==6'b000011)?1:0;
	
	SH <=(opcode==6'b101001)?1:0;

	LH <=(opcode==6'b100001)?1:0;
	
	end
endmodule




