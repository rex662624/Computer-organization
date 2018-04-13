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
			
			,IC_Stall,DC_Stall,IDEXWrite,EXMWrite,MWBWrite
			
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

	//-------------------------HW4
	input IC_Stall,DC_Stall;
	output IDEXWrite,EXMWrite,MWBWrite;
	reg IDEXWrite,EXMWrite,MWBWrite;
	
	
     
	always@(ID_Rs or ID_Rt or EX_WR_out or EX_MemtoReg or IC_Stall or DC_Stall) 
	begin
	
	if(IC_Stall==1'b1||DC_Stall==1'b1)
		begin
		PCWrite = 1;
		IFIDWrite = 1;
		IDEXWrite = 1;
		EXMWrite = 1;
		MWBWrite = 1;
		end

	else if(EX_MemtoReg&&((EX_WR_out == ID_Rs)||(EX_WR_out == ID_Rt))) 
		begin//stall 
		PCWrite = 1; 
		IFIDWrite = 1; 
		IDFlush = 1; 
		IDEXWrite = 0;
		EXMWrite = 0;
		MWBWrite = 0;
	end 

	else 
	begin//no stall 
		PCWrite = 0; 
        	IFIDWrite = 0; 
		IDFlush = 0;
		IDEXWrite = 0;
		EXMWrite = 0;
		MWBWrite = 0;
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