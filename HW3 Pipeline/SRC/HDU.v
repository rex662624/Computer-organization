// Hazard Detection Unit

module HDU ( // input
			 ID_Rs,
             ID_Rt,
			 EX_WR_out,
			 EX_MemtoReg,
			 EX_JumpOP,
			 // output
			 // write your code in here
			PCWrite, IFIDWrite,IDFlush,IFFlush
			 );
	
	parameter bit_size = 32;
	
	input [4:0] ID_Rs;
	input [4:0] ID_Rt;
	input [4:0] EX_WR_out;
	input EX_MemtoReg;
	input [1:0] EX_JumpOP;
	
	// write your code in here
	
	output PCWrite, IFIDWrite,IDFlush,IFFlush; 
	reg PCWrite, IFIDWrite,IDFlush,IFFlush; 
     
	always@(ID_Rs or ID_Rt or EX_WR_out or EX_MemtoReg) 
	begin
	if(EX_MemtoReg&&((EX_WR_out == ID_Rs)||(EX_WR_out == ID_Rt))) 
		begin//stall 
		PCWrite = 1; 
		IFIDWrite = 1; 
		IDFlush = 1; 
	end 

	else 
	begin//no stall 
		PCWrite = 0; 
        	IFIDWrite = 0; 
		IDFlush = 0;
       	end 
	
	end
	
	always@ (EX_JumpOP)
	begin

	if(EX_JumpOP ==2'b00)
		begin
		IDFlush = 0;
		IFFlush = 0;
		end
	else 
		begin
		IDFlush = 1;
		IFFlush = 1;
		end
	end

	
endmodule