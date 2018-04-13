// IF_ID

module IF_ID ( clk,
               rst,
			   // input
			   IF_IDWrite,
			   IF_Flush,
			   IF_PC,
			   IF_ir,
			   // output
			   ID_PC,
			   ID_ir);
	
	parameter pc_size = 18;
	parameter data_size = 32;
	
	input clk, rst;
	input IF_IDWrite, IF_Flush;
	input [pc_size-1:0]   IF_PC;
	input [data_size-1:0] IF_ir;
	
	output [pc_size-1:0]   ID_PC;
	output [data_size-1:0] ID_ir;

	// write your code in here
	reg  [pc_size-1:0]   ID_PC;
	reg  [data_size-1:0] ID_ir;

initial begin 
        ID_ir= 0; 
        ID_PC = 0;
    end 

    always@(negedge clk or posedge rst ) 
    begin 
	
	if(rst)
	begin
	ID_ir <= 0; 
        ID_PC <= 0;
	end

	else if(IF_IDWrite == 1) 
        begin 
             
        end 
	
	else if(IF_Flush == 1) 
        begin 
           ID_ir <= 0; 
           ID_PC <= IF_PC; 
        end 
	
	

        else //if(IF_IDWrite == 1) 
        begin 
           ID_ir <= IF_ir; 
           ID_PC <= IF_PC; 
        end 

	
    end


endmodule