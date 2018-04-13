// Cache Control

module Cache_Control ( 
					   clk,
					   rst,
					   // input
					   en_R,
					   en_W,
					   hit,
					   // output
					   Read_mem,
					   Write_mem,
					   Valid_enable,
					   Tag_enable,
					   Data_enable,
					   sel_mem_core,
					   stall
					   );
	
	input clk, rst;
	input en_R;
	input en_W;
    	input hit;
	
	output Read_mem;
	output Write_mem;
	output Valid_enable;
	output Tag_enable;
	output Data_enable;
	output sel_mem_core;		// 0 data from mem, 1 data from core
	output stall;
	
	// write your code here

	//write rst for all out!!

//------------------------------------------------FSM 1
	parameter R_idle = 2'b00 , R_wait=2'b01, R_Read_data = 2'b10;//State
	reg [1:0]cur_state1;
	reg [1:0]nextstate1;

	reg Valid_enable;
	reg Tag_enable;
	reg Data_enable;
	reg Read_mem;
	reg stall;
	reg sel_mem_core;	
	reg Write_mem;

	always @(posedge clk or posedge rst)
	begin
		if(rst==1)	
		begin 
		Write_mem =0;
		stall=0;
		Valid_enable=0;
		Tag_enable=0;
		Data_enable=0;	
		cur_state1<=R_idle;
		end
		else		cur_state1 = nextstate1;
	end
	
	always@(cur_state1 or en_R or hit)
	begin
	case(cur_state1)
		R_idle:begin
			if( en_R==1'b1 && hit==1'b0 )//Read Miss
				begin
				nextstate1=R_wait;
				Read_mem=1;
				end
			else 
			begin 
			nextstate1 = R_idle;
			Read_mem=0;
			 end
		end

		R_wait:begin
			nextstate1 = R_Read_data;
			Read_mem=0;
		end
		
		R_Read_data:begin
			nextstate1 = R_idle;
			Read_mem=0;
		end
	endcase
	end

	always @(cur_state1)
	begin
	case(cur_state1)

		R_idle:begin
			Valid_enable=0;
			Tag_enable=0;
			Data_enable=0;	
			sel_mem_core=1;
		end
		R_wait:begin
			Valid_enable=0;
			Tag_enable=0;
			Data_enable=0;
			sel_mem_core=1;
			
		end
		
		R_Read_data:begin
			Valid_enable=1;
			Tag_enable=1;
		   	Data_enable=1;
			sel_mem_core=0;	
		end
	endcase

	end
//---------------------------------------------
	always @(en_R or hit)// or posedge rst		if(rst) stall = 0;	else 
	begin
	if(en_R==1'b1&&hit==1'b0)stall=1;
	else stall=0;	
	end
//--------------------------------------------

always @ (en_W or hit)
begin

if(en_W == 1'b1 && hit ==1'b0 )//write miss =>only write to memory
	begin	
	Write_mem=1;
	Valid_enable=0;
	Tag_enable=0;
	Data_enable=0;	
	sel_mem_core=1;		//data from core
	end
else if(en_W == 1'b1 && hit ==1'b1 )//write hit => write both cache and memory
	begin
	Write_mem=1;
	Valid_enable=1;
	Tag_enable=1;
	Data_enable=1;
	sel_mem_core=1;		//data from core
	end
else
begin 
Write_mem=0;

end

end

endmodule



















