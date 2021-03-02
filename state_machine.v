// wojciech rosciszewski wojtanowski 140062 pdc project.
module state_machine(
input wire clk,
input wire rst,   
input wire input_stb,		   
input wire [31:0] input_dat,    
input wire input_operator,	   	   
input wire output_ack,	       	   
output  reg	[31:0] output_dat, 
output 	reg input_ack,		    
output  reg output_stb,		   
output 	reg output_stb2,	 
);	   
reg [2:0] state_machine; 
wire [2:0] pop_dat; 	
reg pop_stb;			 
reg push_stb; 					
reg input_stb2;  	
reg input_stb3;		

always @(posedge clk or posedge rst)
	if(rst) begin 			
		state_machine <= 0;	  			 		
	end		
else case(state_machine)					
		0: begin if(input_stb)	   		   
			begin if(input_operator == 1)
				begin if(input_dat === 4)
					state_machine <= 4;	  								
				else   				
					state_machine <= 2;					
				end								
				else begin					
					output_dat <= input_dat;										
					output_stb <= 1;	  					
					output_stb2 <= 0; 					
					state_machine <= 1;					
				end				
				end				
			end
		1: begin 			
			pop_stb <= 0;	    						
			if (output_ack)	begin								
				output_stb <= 0;	   									
				output_dat <= 0;				
				output_stb2 <= 0;  									
				if(input_stb3 === 1) begin																	
					input_stb3 <= 0; 																									
					state_machine <= 4; 											
				end									
			else if(input_stb2 === 1)	begin									
				input_stb2 <= 0;																							
				state_machine <= 2;								
			end							
			else begin															
				state_machine <= 3; 								
				input_ack <= 1;	  									
			end							
			end					
		end
		2: begin			
			if(input_dat[1] >= pop_dat[1]) begin																					
				output_dat <= pop_dat;											
				pop_stb <= 1;													
				state_machine <= 1;												
				input_stb2 <= 1;												
				output_stb2 <= 1;													
				output_stb <= 1;													
			end								
			else begin																				
				push_stb <= 1;											
				input_ack <= 1;											
				state_machine <= 3;								
				end								
		end						
		3: begin							
			input_ack <= 0;							
			push_stb <= 0;		
			state_machine <= 0;
		end	 
		4: begin					
			if(pop_dat === 3'bx) begin										
				output_stb <= 1;				 				
				state_machine <= 1;	 			 				
				output_dat <= input_dat; 			
				output_stb2 <= 1;	 				
			end
			else begin						
				output_stb <= 1;						
				output_dat <= pop_dat;								
				pop_stb <= 1;		 			
				state_machine <= 1;			
				input_stb3 <= 1;			
				output_stb2 <= 1;					
			end 			
	end 
endcase

stack mystack(
.clk(clk),
.rst(rst),
.push_stb(push_stb),
.push_dat(input_dat),
.pop_stb(pop_stb),
.pop_dat(pop_dat)
);	
endmodule