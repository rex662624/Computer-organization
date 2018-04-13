// Program Counter

module PC ( clk, 
			rst,
			PCin, 
			PCout,PCWrite);
	
	parameter bit_size = 18;
	
	input  clk, rst;
	input  [bit_size-1:0] PCin;
	output [bit_size-1:0] PCout;	   
	
	// write your code in here
	input PCWrite;

	reg [bit_size-1:0] PCout;



	always@(negedge clk or posedge rst)
	begin
		if(rst==1)
			PCout <= 4;

		else if(PCWrite == 1)
			;//PCout <= PCin;
		else
			PCout <= PCin+4;
	end 
		   
endmodule

