
module MUX_2_to_1(data0_i,data1_i,select_i,data_o);
    parameter size ;	
    input   [size-1:0] data0_i;          
    input   [size-1:0] data1_i;
	 input              select_i;
    output  [size-1:0] data_o; 
	 reg [size-1:0] data_o;
	 
	    /* add your design */   
   always@(data0_i or data1_i or select_i) 
	
	begin
		data_o <= (select_i==1) ? data0_i : data1_i;
	end  
endmodule
