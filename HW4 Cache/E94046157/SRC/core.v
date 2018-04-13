// top

module core (
			  clk,
              rst,
			  // Instruction Cache
			  IC_stall,
			  IC_Address,
              		Instruction,
			  // Data Cache
			  DC_stall,
			  DC_Address,
			  DC_Read_enable,
			  DC_Write_enable,
			  DC_Write_Data,
			  DC_Read_Data
			  );

	parameter data_size = 32;
	parameter mem_size = 16;
	parameter pc_size = 18;
	
	input  clk, rst;
	
	// Instruction Cache
	input  IC_stall;
	output [mem_size-1:0] IC_Address;
	input  [data_size-1:0] Instruction;
	
	// Data Cache
	input  DC_stall;
	output [mem_size-1:0] DC_Address;
	output DC_Read_enable;
	output DC_Write_enable;
	output [data_size-1:0] DC_Write_Data;
    	input  [data_size-1:0] DC_Read_Data;
	
	// Write your code here




	//ProgramCounter
	wire[17:0]pc_in;
	wire[17:0]pc_out;
	
	//control unit
	wire RegWrite,ALUSrc,MemRead,RegDst,to_reg31,MemWrite,MemtoReg,SH,LH,Read_enable;
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
	
	wire [31:0]ALU_input1,ALU_input2;
	
	wire a = Instruction[15];//use for sign extention
	
	wire [31:0]dm_in_data;
	
	wire [31:0]dm_out_data;


	reg [15:0]IC_Address;

//---------------------------------------------HW3-------------
	wire [4:0] WB_WR_out;
	wire WB_RegWrite;
//------------------------------------------- NO1
	wire [31:0]WB_Mux_out;
	wire IDFlush,IFFlush;

	wire IF_IDWrite,PC_Write;
	wire [17:0]ID_PC;
	wire [31:0]ID_ir;
//-----------------------------------------------------------------------------
	
	PC pc1(.clk(clk),.rst(rst),.PCin(pc_in),.PCout(pc_out),.PCWrite(PC_Write));
		
	always@(pc_out)begin
	pc_in_im = (pc_out-4);
	end

	always @(pc_in_im)
	begin
	IC_Address=pc_in_im[17:2];
	end

	//IM im1(.clk(clk),.rst(rst),.IM_Address(pc_in_im[17:2]),.Instruction(Instruction));
	
	/*
	assign IM_Address = pc_in_im[17:2];*/
	
	IF_ID IF_ID1( .clk(clk),.rst(rst),.IF_IDWrite(IF_IDWrite),.IF_Flush(IFFlush),.IF_PC(pc_out),.IF_ir(Instruction),.ID_PC(ID_PC),.ID_ir(ID_ir));

//------------------------------------------------------------------------------------------no2

	wire EX_MemtoReg,EX_RegWrite,EX_MemWrite,EX_Reg_imm,EX_Read_enable,IDEXWrite;
	wire [17:0] EX_PC;
	wire [3:0] EX_ALUOp;
	wire [4:0] EX_shamt,EX_WR_out,EX_Rs,EX_Rt;
	wire [31:0] EX_Rs_data,EX_Rt_data,EX_se_imm;
	wire [5:0]EX_opcode,EX_funct;


	Regfile register1(.clk(clk),.rst(rst),.Read_addr_1(ID_ir[25:21]),
		.Read_addr_2(ID_ir[20:16]),
		.Read_data_1(readdata1),.Read_data_2(readdata2),
		.RegWrite(WB_RegWrite),.Write_addr(WB_WR_out),.Write_data(WB_Mux_out));
		

	Controller control1(.opcode(ID_ir[31:26]),.funct(ID_ir[5:0])
		,.RegWrite(RegWrite),.MemWrite(MemWrite)
		,.ALUOp(ALUOp),.ALUSrc(ALUSrc)
		,.MemRead(MemRead),.MemtoReg(MemtoReg)
		,.RegDst(RegDst),.to_reg31(to_reg31),.SH(SH),.LH(LH),.Read_enable(Read_enable));
	
	MUX_2_to_1 #(.size(5)) mux1 (ID_ir[15:11],ID_ir[20:16],RegDst,dest);//NO1 mux	assign	dest = (RegDst ==1)?Instruction[15:11]:Instruction[20:16];
	
	MUX_2_to_1 #(.size(5)) mux2 (5'b11111,dest,to_reg31,destfinal);//NO2 mux	assign  destfinal = (to_reg31==1)?5'b11111:dest; 
	
	wire [31:0]ID_se_imm;
	wire EX_SH,EX_LH,EX_to_reg31;
	assign a1 = ID_ir[15];
	assign ID_se_imm = {a1,a1,a1,a1,a1,a1,a1,a1,a1,a1,a1,a1,a1,a1,a1,a1,ID_ir[15:0]};

	ID_EX ID_EX1( .clk(clk),.rst(rst),.ID_Flush(IDFlush),.ID_MemtoReg(MemtoReg),.ID_RegWrite(RegWrite),.ID_MemWrite(MemWrite),.ID_Reg_imm(ALUSrc),.ID_PC(ID_PC),
		.ID_ALUOp(ALUOp),.ID_shamt(ID_ir[10:6]),.ID_Rs_data(readdata1),.ID_Rt_data(readdata2),.ID_se_imm(ID_se_imm),.ID_WR_out(destfinal),
		.ID_Rs(ID_ir[25:21]),.ID_Rt(ID_ir[20:16]),.ID_SH(SH),.ID_LH(LH),.ID_to_reg31(to_reg31),
		// output
		.EX_MemtoReg(EX_MemtoReg),.EX_RegWrite(EX_RegWrite),.EX_MemWrite(EX_MemWrite),.EX_Reg_imm(EX_Reg_imm),.EX_PC(EX_PC),.EX_ALUOp(EX_ALUOp),.EX_shamt(EX_shamt),
		.EX_Rs_data(EX_Rs_data),.EX_Rt_data(EX_Rt_data),.EX_se_imm(EX_se_imm),.EX_WR_out(EX_WR_out),.EX_Rs(EX_Rs),.EX_Rt(EX_Rt),
		.ID_opcode(ID_ir[31:26]),.ID_funct(ID_ir[5:0]),.EX_opcode(EX_opcode),.EX_funct(EX_funct)//for jump_CTRL
		,.EX_SH(EX_SH),.EX_LH(EX_LH),.EX_to_reg31(EX_to_reg31)
		
		,.ID_Read_enable(Read_enable),.EX_Read_enable(EX_Read_enable)
		,.IDEXWrite(IDEXWrite)
	   	);

//----------------------------------------------------------------------------------no3
	
	wire [17:0]PCplus8;
	wire M_MemtoReg;	
	wire M_RegWrite;	
	wire M_MemWrite;	
	wire [31:0] M_ALU_result;
	wire [31:0] M_Rt_data;
	wire [17:0] M_PCplus8;
	wire [4:0] M_WR_out;
	
	wire [31:0] ALU_input2_AfterM;
	
	wire M_SH,M_LH,M_to_reg31,M_Read_enable,EXMWrite;
	
	ALU alu1(.ALUOp(EX_ALUOp),.src1(ALU_input1),.src2(ALU_input2_AfterM)
		,.shamt(EX_shamt),.ALU_result(ALU_result),.Zero(Zero));

wire [1:0]JumpOP;
//wire [17:0]jumpSignExten ={Instruction[15],Instruction[15],Instruction[15:0]};
reg [17:0]pc_jump;
Jump_Ctrl Jctrl(.Zero(Zero),.JumpOP(JumpOP),.opcode(EX_opcode),.funct(EX_funct));

initial begin pc_jump = 0; end

always@(JumpOP or EX_PC or EX_se_imm or pc_out or ALU_input1)

begin
pc_jump <= (JumpOP==2'b00)?pc_out:
		(JumpOP==2'b01)?(EX_se_imm[17:0]<<2)+EX_PC:
		(JumpOP==2'b10)?ALU_input1[17:0]:(EX_se_imm[17:0]<<2);
end

assign pc_in = pc_jump;

assign PCplus8 = EX_PC+4;

EX_M EX_M1(.clk(clk),.rst(rst),.EX_MemtoReg(EX_MemtoReg),.EX_RegWrite(EX_RegWrite),
	.EX_MemWrite(EX_MemWrite),.EX_ALU_result(ALU_result),.EX_Rt_data(ALU_input2),.EX_PCplus8(PCplus8),.EX_WR_out(EX_WR_out),.EX_SH(EX_SH),.EX_LH(EX_LH),.EX_to_reg31(EX_to_reg31)
	// output
	,.M_MemtoReg(M_MemtoReg),.M_RegWrite(M_RegWrite),.M_MemWrite(M_MemWrite),.M_ALU_result(M_ALU_result),.M_Rt_data(M_Rt_data),.M_PCplus8(M_PCplus8),.M_WR_out(M_WR_out)			  		  			  
	,.M_SH(M_SH),.M_LH(M_LH),.M_to_reg31(M_to_reg31)
	,.EX_Read_enable(EX_Read_enable),.M_Read_enable(M_Read_enable)
	,.EXMWrite(EXMWrite)
	);

MUX_2_to_1 #(.size(32)) mux3(EX_se_imm,ALU_input2,EX_Reg_imm,ALU_input2_AfterM);//NO3 mux	assign ALU_input2 = (ALUSrc==0)?readdata2:{a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,Instruction[15:0]};
	


//-----------------------------------------------------------------------------------no4

	wire WB_MemtoReg;
    	wire [31:0] WB_DM_Read_Data;
    	wire [31:0] WB_WD_out;
   	

	//DM dm1(.clk(clk),.rst(rst),.DM_Address(ALU_result[17:2]),.DM_enable(MemWrite),.DM_Write_Data(dm_in_data),.DM_Read_Data(dm_readdata));
	assign DC_Write_enable = M_MemWrite;
	assign DC_Address = M_ALU_result[17:2];
	assign DC_Write_Data = dm_in_data;
	assign dm_readdata = DC_Read_Data;
	assign DC_Read_enable = M_Read_enable;

	wire b = M_Rt_data[15];
	wire c = dm_readdata[15];
MUX_2_to_1 #(.size(32)) mux4({b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,M_Rt_data[15:0]},M_Rt_data,M_SH,dm_in_data);//no4 	mux	assign dm_in_data=(SH==1)?{b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,readdata2[15:0]}:readdata2;
		
MUX_2_to_1 #(.size(32)) mux5({c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,dm_readdata[15:0]},dm_readdata,M_LH,dm_out_data);//no5 mux	assign dm_out_data =(LH==1)?{c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,dm_readdata[15:0]}:dm_readdata; 
		
MUX_2_to_1 #(.size(32)) mux7(M_PCplus8+0,M_ALU_result,M_to_reg31,write_to_reg_data);//no7mux	assign write_to_reg_data =(to_reg31==1)?(pc_out+4):dm_alu;

wire MWBWrite;

M_WB M_WB1(.clk(clk),.rst(rst),
	.M_MemtoReg(M_MemtoReg),.M_RegWrite(M_RegWrite),.M_DM_Read_Data(dm_out_data),.M_WD_out(write_to_reg_data),.M_WR_out(M_WR_out),
	// output
	.WB_MemtoReg(WB_MemtoReg),.WB_RegWrite(WB_RegWrite),.WB_DM_Read_Data(WB_DM_Read_Data),.WB_WD_out(WB_WD_out),.WB_WR_out(WB_WR_out)
	,.MWBWrite(MWBWrite)
	);

//----------------------------------------------------------------------------------no5
	
MUX_2_to_1 #(.size(32)) mux6(WB_DM_Read_Data,WB_WD_out,WB_MemtoReg,WB_Mux_out);//no6 mux	assign  dm_alu = (MemtoReg==1)?dm_out_data :ALU_result;

//----------------------------------------------------------------------------------forwarding and hazard
wire [1:0]ForwardA, ForwardB;
reg [31:0] Mux_alu_in1,Mux_alu_in2;


FU FU1( 	// input 
	.EX_Rs(EX_Rs),.EX_Rt(EX_Rt),.M_RegWrite(M_RegWrite),.M_WR_out(M_WR_out),.WB_RegWrite(WB_RegWrite),.WB_WR_out(WB_WR_out),
 	// output
	.ForwardA(ForwardA),.ForwardB(ForwardB));

always @(ForwardA or EX_Rs_data or WB_Mux_out or write_to_reg_data)
	begin
		if(ForwardA ==2'b10)
		Mux_alu_in1 = write_to_reg_data;
		else if(ForwardA ==2'b01)
		Mux_alu_in1 = WB_Mux_out;
		else
		Mux_alu_in1 = EX_Rs_data;
	end

	assign ALU_input1 = Mux_alu_in1;


always @(ForwardB or EX_Rt_data or WB_Mux_out or write_to_reg_data)
	begin
		if(ForwardB ==2'b10)
		Mux_alu_in2 = write_to_reg_data;
		else if(ForwardB ==2'b01)
		Mux_alu_in2 = WB_Mux_out;
		else
		Mux_alu_in2 = EX_Rt_data;
	end

	assign ALU_input2 = Mux_alu_in2;

 HDU  HDU1( // input
	.ID_Rs(ID_ir[25:21]),.ID_Rt(ID_ir[20:16]),.EX_WR_out(EX_WR_out),.EX_MemtoReg(EX_MemtoReg),.EX_JumpOP(JumpOP),
	// output
	.PCWrite(PC_Write), .IFIDWrite(IF_IDWrite),.IDFlush(IDFlush),.IFFlush(IFFlush),
	.IC_Stall(IC_stall),.DC_Stall(DC_stall),.IDEXWrite(IDEXWrite),.EXMWrite(EXMWrite),.MWBWrite(MWBWrite));


	
endmodule





























