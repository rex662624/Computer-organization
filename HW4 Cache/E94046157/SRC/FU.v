 // Forwarding Unit

module FU ( // input 
			EX_Rs,
            EX_Rt,
			M_RegWrite,
			M_WR_out,//memRegRd
			WB_RegWrite,
			WB_WR_out,//wbRegRd
			// output
			// write your code in here
			ForwardA, ForwardB
			);

	input [4:0] EX_Rs;
    input [4:0] EX_Rt;
    input M_RegWrite;
    input [4:0] M_WR_out;
    input WB_RegWrite;
    input [4:0] WB_WR_out;

	// write your code in here
	output [1:0]ForwardA, ForwardB; 	
	reg[1:0]ForwardA, ForwardB; 
    
   //Forward A 
   always@(M_RegWrite or M_WR_out or EX_Rs or WB_RegWrite or WB_WR_out) 
   begin 
      	if((M_RegWrite)&&(M_WR_out != 0)&&(M_WR_out == EX_Rs)) 
         	ForwardA = 2'b10; 	
	else if((WB_RegWrite)&&(WB_WR_out != 0)&&(WB_WR_out == EX_Rs))//&&!(M_RegWrite&&(M_WR_out != 0)&&(M_WR_out!= EX_Rs))
         	ForwardA = 2'b01; 
      	else 
         	ForwardA = 2'b00; 
   end 
 
   //Forward B 
   always@(WB_RegWrite or WB_WR_out or EX_Rt or M_WR_out or M_RegWrite) 
   begin 

	if((M_RegWrite)&&(M_WR_out != 0)&&(M_WR_out == EX_Rt)) 
         	ForwardB = 2'b10; 
	else if((WB_RegWrite)&&(WB_WR_out != 0)&&(WB_WR_out == EX_Rt))//&&!(M_RegWrite&&(M_WR_out!=0)&&(M_WR_out != EX_Rt))
         	ForwardB = 2'b01; 
      	else  
         	ForwardB = 2'b00; 
   end 
 
	
endmodule



