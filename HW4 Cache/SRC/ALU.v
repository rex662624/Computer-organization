// ALU

module ALU ( ALUOp,src1,src2,shamt,ALU_result,Zero);
	
	parameter bit_size = 32;
	
	input [3:0] ALUOp;
	input signed[bit_size-1:0] src1;
	input signed[bit_size-1:0] src2;
	input [4:0] shamt;
	
	output signed[bit_size-1:0] ALU_result;
	output Zero;
			
	// write your code in here
			
		
	assign ALU_result =(ALUOp == 4'b0011)?(((~src1)&src2)|(src1&(~src2)))://xor
			   (ALUOp == 4'b0000)?src1&src2://and
			   (ALUOp == 4'b0001)?src1|src2://or
			   (ALUOp == 4'b0010)?src1+src2://add				
			   (ALUOp == 4'b0110)?src1-src2://sub
         		   (ALUOp == 4'b1100)?(~(src1|src2))://nor					
         		   (ALUOp == 4'b0100)?(src2<<shamt)://sll					
         		   (ALUOp == 4'b0101)?(src2>>shamt)://srl										    
			   (ALUOp == 4'b0111&&src1<src2)?1:0;//slt
			  		
	assign Zero=(ALU_result==32'b0)?1:0;
							
endmodule





