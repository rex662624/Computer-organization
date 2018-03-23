// EX_M

module EX_M ( clk,
			  rst,
			  // input 
			  // WB
			  EX_MemtoReg,
			  EX_RegWrite,
			  // M
			  EX_MemWrite,
			  // write your code in here
			  // pipe
			  EX_ALU_result,
			  EX_Rt_data,
			  EX_PCplus8,
			  EX_WR_out,
			  // output
			  // WB
			  M_MemtoReg,
			  M_RegWrite,
			  // M
			  M_MemWrite,
			  // write your code in here
			  // pipe
			  M_ALU_result,
			  M_Rt_data,
			  M_PCplus8,
			  M_WR_out,
M_SH,M_LH,M_to_reg31,EX_SH,EX_LH,EX_to_reg31  
			  );
	
	parameter pc_size = 18;	
	parameter data_size = 32;
	
	input clk, rst;		  
			  
	// WB		  
	input EX_MemtoReg;
    input EX_RegWrite;
    // M
    input EX_MemWrite;
	// write your code in here
	// pipe		  
	input [data_size-1:0] EX_ALU_result;
    input [data_size-1:0] EX_Rt_data;
    input [pc_size-1:0] EX_PCplus8;
    input [4:0] EX_WR_out;
	
	// WB
	output M_MemtoReg;	
	output M_RegWrite;	
	// M	
	output M_MemWrite;	
	// write your code in here
	// pipe		  
	output [data_size-1:0] M_ALU_result;
	output [data_size-1:0] M_Rt_data;
	output [pc_size-1:0] M_PCplus8;
	output [4:0] M_WR_out;
	
	// write your code in here

	reg M_MemtoReg;	
	reg M_RegWrite;	
	// M	
	reg M_MemWrite;	
	// write your code in here
	// pipe		  
	reg [data_size-1:0] M_ALU_result;
	reg [data_size-1:0] M_Rt_data;
	reg [pc_size-1:0] M_PCplus8;
	reg [4:0] M_WR_out;

	input EX_SH,EX_LH,EX_to_reg31;
	output M_SH,M_LH,M_to_reg31;
	reg M_SH,M_LH,M_to_reg31;

	always@(negedge clk or posedge rst) 
    begin 
	if(rst)
	begin
	M_MemtoReg <=0 ;
	M_RegWrite <=0 ;
	M_MemWrite <=0 ;
	M_ALU_result <=0 ;
	M_Rt_data <=0 ;
	M_PCplus8 <=0 ;
	M_WR_out <=0 ;
	M_SH <=0;
	M_LH <=0;
	M_to_reg31 <= 0;
	
	end

	else
	begin
	M_MemtoReg <= EX_MemtoReg;
	M_RegWrite <= EX_RegWrite;
	M_MemWrite <= EX_MemWrite;
	M_ALU_result <= EX_ALU_result ;
	M_Rt_data <= EX_Rt_data;
	M_PCplus8 <= EX_PCplus8;
	M_WR_out <= EX_WR_out;
	M_SH <=EX_SH;
	M_LH <=EX_LH;
	M_to_reg31 <= EX_to_reg31;

	end
    end 
	
endmodule


























