// ID_EX

module ID_EX ( clk,  
               rst,
               // input 
			   ID_Flush,
			   // WB
			   ID_MemtoReg,
			   ID_RegWrite,
			   // M
			   ID_MemWrite,
			   // write your code in here
			   // EX
			   ID_Reg_imm,
			   // write your code in here	   
			   // pipe
			   ID_PC,
			   ID_ALUOp,
			   ID_shamt,
			   ID_Rs_data,
			   ID_Rt_data,
			   ID_se_imm,
			   ID_WR_out,
			   ID_Rs,
			   ID_Rt,
			   // output
			   // WB
			   EX_MemtoReg,
			   EX_RegWrite,
			   // M
			   EX_MemWrite,
			   // write your code in here
			   // EX
			   EX_Reg_imm,
			   // write your code in here			
			   // pipe
			   EX_PC,
			   EX_ALUOp,
			   EX_shamt,
			   EX_Rs_data,
			   EX_Rt_data,
			   EX_se_imm,
			   EX_WR_out,
			   EX_Rs,
			   EX_Rt,

ID_opcode,ID_funct,EX_opcode,EX_funct,//for jump_CTRL		 			   
	EX_SH,EX_LH,EX_to_reg31,ID_SH,ID_LH,ID_to_reg31

	,ID_Read_enable,EX_Read_enable
	,IDEXWrite
			   );
	
	parameter pc_size = 18;			   
	parameter data_size = 32;
	
	input clk, rst;
	input ID_Flush;
	
	// WB
	input ID_MemtoReg;
	input ID_RegWrite;
	// M
	input ID_MemWrite;
	// write your code in here
	// EX
	input ID_Reg_imm;
	// write your code in here
	// pipe
    input [pc_size-1:0] ID_PC;
    input [3:0] ID_ALUOp;
    input [4:0] ID_shamt;
    input [data_size-1:0] ID_Rs_data;
    input [data_size-1:0] ID_Rt_data;
    input [data_size-1:0] ID_se_imm;
    input [4:0] ID_WR_out;
    input [4:0] ID_Rs;
    input [4:0] ID_Rt;

	// WB
	output EX_MemtoReg;
	output EX_RegWrite;
	// M
	output EX_MemWrite;
	// write your code in here
	// EX
	output EX_Reg_imm;
	// write your code in here
	// pipe
	output [pc_size-1:0] EX_PC;
	output [3:0] EX_ALUOp;
	output [4:0] EX_shamt;
	output [data_size-1:0] EX_Rs_data;
	output [data_size-1:0] EX_Rt_data;
	output [data_size-1:0] EX_se_imm;
	output [4:0] EX_WR_out;
	output [4:0] EX_Rs;
	output [4:0] EX_Rt;
	
	// write your code in here

    	
	reg EX_MemtoReg;
	reg EX_RegWrite;
	// M
	reg EX_MemWrite;
	// write your code in here
	// EX
	reg EX_Reg_imm;
	// write your code in here
	// pipe
	reg [pc_size-1:0] EX_PC;
	reg [3:0] EX_ALUOp;
	reg [4:0] EX_shamt;
	reg [data_size-1:0] EX_Rs_data;
	reg [data_size-1:0] EX_Rt_data;
	reg [data_size-1:0] EX_se_imm;
	reg [4:0] EX_WR_out;
	reg [4:0] EX_Rs;
	reg [4:0] EX_Rt;
	
	// write your code in here
	input[5:0]ID_opcode,ID_funct;
	output[5:0]EX_opcode,EX_funct;
	
	reg[5:0]EX_opcode,EX_funct;  
	
	input ID_SH,ID_LH,ID_to_reg31;
	output EX_SH,EX_LH,EX_to_reg31;
	reg EX_SH,EX_LH,EX_to_reg31;

//-------------------------HW4
input ID_Read_enable;
output EX_Read_enable;
reg EX_Read_enable;
input IDEXWrite;
   
    always@(negedge clk or posedge rst) 
    begin 
	if(rst)
	begin
	EX_MemtoReg <= 0;
	EX_RegWrite <= 0;
	EX_MemWrite <= 0;
	EX_Reg_imm <= 0;
	EX_PC <= 0;
	EX_ALUOp <= 0;
	EX_shamt <= 0;
	EX_Rs_data <= 0;
	EX_Rt_data <= 0;
	EX_se_imm <=0;
	EX_WR_out <= 0;
	EX_Rs <= 0;
	EX_Rt <=  0;
	EX_opcode <= 0;
	EX_funct <= 0;
	EX_SH <= 0 ;
	EX_LH <= 0;
	EX_to_reg31 <= 0;
	EX_Read_enable<=0;
	end
	else if(IDEXWrite==1'b1)
	begin
	
	end

	else if(ID_Flush)
	begin
	EX_MemtoReg <= 0;
	EX_RegWrite <= 0;
	EX_MemWrite <= 0;
	EX_Reg_imm <= 0;
	EX_ALUOp <= 0;
	EX_shamt <= 0;
	EX_SH <= 0 ;
	EX_LH <= 0;
	EX_to_reg31 <= 0;
	EX_PC <= ID_PC;
	EX_opcode <= 0;
	EX_funct <= 0;
	EX_Read_enable<=0;
	EX_Read_enable <= 0;
	end

	

	else
	begin
        EX_MemtoReg <= ID_MemtoReg;
	EX_RegWrite <= ID_RegWrite;
	EX_MemWrite <= ID_MemWrite;
	EX_Reg_imm <= ID_Reg_imm;
	EX_PC <= ID_PC;
	EX_ALUOp <= ID_ALUOp;
	EX_shamt <= ID_shamt;
	EX_Rs_data <= ID_Rs_data;
	EX_Rt_data <= ID_Rt_data;
	EX_se_imm <= ID_se_imm;
	EX_WR_out <= ID_WR_out;
	EX_Rs <= ID_Rs;
	EX_Rt <=  ID_Rt;
	EX_opcode <= ID_opcode;
	EX_funct <= ID_funct;
	EX_SH <= ID_SH;
	EX_LH <= ID_LH;
	EX_to_reg31 <= ID_to_reg31;
	EX_Read_enable <= ID_Read_enable;
	end
    end 
	
	
endmodule










