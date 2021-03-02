// wojciech rosciszewski wojtanowski 140062 pdc project
module testbench();
reg clk;	  
initial clk <= 0;
always #50 clk <= ~clk;
reg rst;
initial begin
	rst <= 0;
	rst <= #50 1;
	rst <= #500 0;
end	 
reg input_operator;  
wire in_conv_ack;
wire out_conv_stb;	 
wire [31:0] out_conv_dat;
wire out_conv_op_check; 
wire out_conv_ack;		  
reg check_num;		
wire [31:0] out_calc_dat;
integer calculate;	  
reg input_stb;		
reg [31:0] input_dat;
integer calculation;
integer calculated;
wire output_stb;
	
always@(posedge clk or posedge rst) begin 	
	if(in_conv_ack) begin	
		input_stb <= 0;		
		input_dat <= 0;	
	end			 
end	
	
always@(posedge clk or posedge rst)		
	if(rst) begin		
		calculate <= $fopen("equation.txt" , "r"); 			
		calculated <= $fopen("result.txt" , "w"); 		
		input_stb <= 0;			
		input_operator <= 0;		
		input_dat <= 0;	 		
		check_num <= 0;					
	end
	else if(!input_stb) begin 				
		if(!check_num) begin				
			calculation = $fscanf(calculate, "%d", input_dat);
			if(calculation) begin
				input_stb <= 1;
				check_num <= 1;
				input_operator <= 0;
			end
		end
	else begin				
		calculation = $fscanf(calculate, "%s", input_dat);
		if(calculation) begin 
			input_stb <= 1;
			input_operator <= 1;
			check_num <= 0;
			if(input_dat === 42 ) //* is 42 and set to 001
				input_dat <= 1;
			else if(input_dat === 43) //+ is 43 and set to 010
				input_dat <= 2;
			else if(input_dat === 45) //- is 45 and set to 011
				input_dat <= 3;
			else if(input_dat === 61)  //= is 61 and set to 100
				input_dat <= 4;
			else begin	  
				$finish;
			end
			end 
		end
	end		
always@(posedge clk or posedge rst) begin
	if(output_stb) begin
		$fwrite(calculated , "%s%d\n" , "result: " , $signed(out_calc_dat));
		$finish;
	end	
end
	
state_machine mystates(	
.clk(clk),
.rst(rst),	   
.input_stb(input_stb),
.input_dat(input_dat),
.input_operator(input_operator),
.input_ack(in_conv_ack),	
.output_stb(out_conv_stb),
.output_dat(out_conv_dat),
.output_stb2(out_conv_op_check),
.output_ack(out_conv_ack)
);
rpncalc mycalculator(
.clk(clk),
.rst(rst),	   
.input_stb(out_conv_stb),
.input_dat(out_conv_dat),
.input_operator(out_conv_op_check),
.input_ack(out_conv_ack),	
.output_stb(output_stb),
.output_dat(out_calc_dat),
.output_ack(out_calc_ack)
);	
endmodule		 	

