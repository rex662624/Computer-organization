// top


module top ( clk,
             rst,
			 // Instruction Memory
			 IM_Address,
             Instruction,
			 // Data Memory
			 DM_Address,
			 DM_enable,
			 DM_Write_Data,
			 DM_Read_Data);


	parameter data_size = 32;
	parameter mem_size = 16;	

	input  clk, rst;
	
	// Instruction Memory
	output [mem_size-1:0] IM_Address;	
	input  [data_size-1:0] Instruction;

	// Data Memory
	output [mem_size-1:0] DM_Address;
	output DM_enable;
	output [data_size-1:0] DM_Write_Data;	
    	input  [data_size-1:0] DM_Read_Data;
	
	// write your code here


	//ProgramCounter
	wire[17:0]pc_in;
	wire[17:0]pc_out;
	
	//control unit
	wire RegWrite,ALUSrc,MemRead,RegDst,to_reg31,MemWrite,MemtoReg,SH,LH;
	wire [3:0]ALUOp;
	
	//register
	wire [31:0]readdata1,readdata2;
	wire [31:0] write_to_reg_data;
	//ALU
	wire [31:0]ALU_result;
	wire Zero;
	//datamemory 
	wire [31:0]dm_readdata;
	
//-----------------------------------------------------
	reg [17:0]pc_in_im;
	
	wire [4:0]dest,destfinal;
	
	wire [31:0]ALU_input2;
	
	wire a = Instruction[15];//use for sign extention
	
	wire [31:0]dm_in_data;
	wire b = readdata2[15];

	wire [31:0]dm_out_data;
	wire c = dm_readdata[15];

	wire [31:0]dm_alu;

	PC pc1(.clk(clk),.rst(rst),.PCin(pc_in),.PCout(pc_out));

	always@(pc_out)begin
	
	 pc_in_im <= pc_out-4;

	end
	//IM im1(.clk(clk),.rst(rst),.IM_Address(pc_in_im[17:2]),.Instruction(Instruction));
	
	assign IM_Address = pc_in_im[17:2];
	
	
	//--------------------------------------


	Regfile register1(.clk(clk),.rst(rst),.Read_addr_1(Instruction[25:21]),
		.Read_addr_2(Instruction[20:16]),
		.Read_data_1(readdata1),.Read_data_2(readdata2),
		.RegWrite(RegWrite),.Write_addr(destfinal),.Write_data(write_to_reg_data));
		

	Controller control1(.opcode(Instruction[31:26]),.funct(Instruction[5:0])
		,.RegWrite(RegWrite),.MemWrite(MemWrite)
		,.ALUOp(ALUOp),.ALUSrc(ALUSrc)
		,.MemRead(MemRead),.MemtoReg(MemtoReg)
		,.RegDst(RegDst),.to_reg31(to_reg31),.SH(SH),.LH(LH));

	ALU alu1(.ALUOp(ALUOp),.src1(readdata1),.src2(ALU_input2)
		,.shamt(Instruction[10:6]),.ALU_result(ALU_result),.Zero(Zero));

	//DM dm1(.clk(clk),.rst(rst),.DM_Address(ALU_result[17:2]),.DM_enable(MemWrite),.DM_Write_Data(dm_in_data),.DM_Read_Data(dm_readdata));
	assign DM_enable = MemWrite;
	assign DM_Address = ALU_result[17:2];
	assign DM_Write_Data = dm_in_data;
	assign dm_readdata = DM_Read_Data;

	
MUX_2_to_1 #(.size(5)) mux1 (Instruction[15:11],Instruction[20:16],RegDst,dest);//NO1 mux	assign	dest = (RegDst ==1)?Instruction[15:11]:Instruction[20:16];
	
MUX_2_to_1 #(.size(5)) mux2 (5'b11111,dest,to_reg31,destfinal);//NO2 mux	assign  dest = (to_reg31==1)?5'b11111:dest; 
	
MUX_2_to_1 #(.size(32)) mux3({a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,Instruction[15:0]},readdata2,ALUSrc,ALU_input2);//NO3 mux	assign ALU_input2 = (ALUSrc==0)?readdata2:{a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,Instruction[15:0]};
	
MUX_2_to_1 #(.size(32)) mux4({b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,readdata2[15:0]},readdata2,SH,dm_in_data);//no4 mux	assign dm_in_data=(SH==1)?{b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,readdata2[15:0]}:readdata2;
		
MUX_2_to_1 #(.size(32)) mux5({c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,dm_readdata[15:0]},dm_readdata,LH,dm_out_data);//no5 mux	assign dm_out_data =(LH==1)?{c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,dm_readdata[15:0]}:dm_readdata; 
		
MUX_2_to_1 #(.size(32)) mux6(dm_out_data ,ALU_result,MemtoReg,dm_alu);//no6 mux	assign  dm_alu = (MemtoReg==1)?dm_out_data :ALU_result;
	
MUX_2_to_1 #(.size(32)) mux7(pc_out+4,dm_alu,to_reg31,write_to_reg_data);//no7mux	assign write_to_reg_data =(to_reg31==1)?(pc_out+4):dm_alu;


//-----------------------------program counter +Jump-ctrl------------------------------
wire [1:0]JumpOP;
wire [17:0]jumpSignExten ={Instruction[15],Instruction[15],Instruction[15:0]};
reg [17:0]pc_jump;

Jump_Ctrl Jctrl(.Zero(Zero),.JumpOP(JumpOP),.opcode(Instruction[31:26]),.funct(Instruction[5:0]));

always@(JumpOP or pc_out or Instruction)
begin
 pc_jump = (JumpOP==2'b00)?pc_out:
		(JumpOP==2'b01)?(jumpSignExten<<2)+pc_out:
		(JumpOP==2'b10)?readdata1[17:0]:(jumpSignExten<<2);
end

assign pc_in = pc_jump;
	
endmodule



