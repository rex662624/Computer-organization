// Regfile

module Regfile ( clk, rst,
				 Read_addr_1, Read_addr_2,
				 Read_data_1,Read_data_2,
				 RegWrite,
				 Write_addr,Write_data);
	
	parameter bit_size = 32;
	
	input  clk, rst;
	input  [4:0] Read_addr_1;
	input  [4:0] Read_addr_2;
	
	output [bit_size-1:0] Read_data_1;
	output [bit_size-1:0] Read_data_2;
	
	input  RegWrite;
	input  [4:0] Write_addr;
	input  [bit_size-1:0] Write_data;

	
    // write your code in here
	
	reg signed [bit_size-1:0]Register[0:31];			
	
	assign Read_data_1 = Register[Read_addr_1];
	assign Read_data_2 = Register[Read_addr_2];
	

	always@(posedge clk or posedge rst)
	begin
	if(rst==1)
	begin
	Register[0]<=32'b0;Register[1]<=32'b0;Register[2]<=32'b0;Register[3]<=32'b0;Register[4]<=32'b0;Register[5]<=32'b0;Register[6]<=32'b0;Register[7]<=32'b0;
	Register[8]<=32'b0;Register[9]<=32'b0;Register[10]<=32'b0;Register[11]<=32'b0;Register[12]<=32'b0;Register[13]<=32'b0;Register[14]<=32'b0;Register[15]<=32'b0;
	Register[16]<=32'b0;Register[17]<=32'b0;Register[18]<=32'b0;Register[19]<=32'b0;Register[20]<=32'b0;Register[21]<=32'b0;Register[22]<=32'b0;Register[23]<=32'b0;
	Register[24]<=32'b0;Register[25]<=32'b0;Register[26]<=32'b0;Register[27]<=32'b0;Register[28]<=32'b0;Register[29]<=32'b0;Register[30]<=32'b0;Register[31]<=32'b0;		
	end	
	
	else if(Write_addr==5'b0)
		;//if $zero => do nothing 
	
	else if(RegWrite==1)
		Register[Write_addr]<= Write_data;
	
	else
		Register[Write_addr]<= Register[Write_addr];//do nothing
	end
endmodule


