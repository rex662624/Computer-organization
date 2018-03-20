// Program Counter

module PC ( clk, 
			rst,
			PCin, 
			PCout);
	
	parameter bit_size = 18;
	
	input  clk, rst;
	input  [bit_size-1:0] PCin;
	output [bit_size-1:0] PCout;	   
	
	// write your code in here

	reg [bit_size-1:0] PCout;

	initial begin
		PCout = 4;
	end	
	

	always@(posedge clk)
	begin
		if(rst==1)
			PCout <= 4;

		else 	
			PCout <= PCin+4;
	end 
		   
endmodule

