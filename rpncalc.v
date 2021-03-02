// wojciech rosciszewski wojtanowski 140062 pdc project
module rpncalc(	
input wire clk,
input wire rst,	   
input 	wire input_stb,
input 	wire [31:0] input_dat,
input 	wire input_operator,
output 	reg input_ack,	
output reg output_stb,
output reg	[31:0] output_dat,
input 	wire output_ack,
);	
reg [31:0] num_rhs;
reg [31:0] num_lhs;
reg push_stb;
wire [31:0] pop_dat;
reg pop_stb;
reg [31:0] push_dat;
reg [3:0] state_machine;	 
	
always@(posedge clk or posedge rst)
	if(rst)begin
		state_machine <= 0;
	end
	else case(state_machine)
		0: begin
			if(input_stb) begin
				if(input_operator === 1) 
					if(input_dat[2] === 1) 
						state_machine <= 1; 
					else 
						state_machine <= 2;
					else
					begin
						push_dat <= input_dat;
						push_stb <= 1;
						state_machine <= 7;
						input_ack <= 1;	
					end
				end	
		end	 
		1: begin
			output_dat <= pop_dat;
			pop_stb <= 1;
			push_stb <= 0;
			output_stb <= 1;
			state_machine <= 7;
			input_ack <= 1;
		end
		2: begin
			num_rhs <= pop_dat;
			pop_stb <= 1;
			state_machine <= 3;
		end
		3: begin
			if(num_rhs !== 0) begin 				
				pop_stb <= 0;
				state_machine <= 4;
			end
		end	
		4: begin 
			num_lhs <= pop_dat;
			pop_stb <= 1;
			state_machine <= 5;
		end
		5: begin
			if(num_lhs !== 0) begin
				pop_stb <= 0;
				state_machine <= 6;
				if(input_dat[1:0] == 2'b01)
					push_dat <= num_lhs*num_rhs;
				else if(input_dat[1:0] == 2'b10)
					push_dat <= num_lhs+num_rhs;
				else if (input_dat[1:0] == 2'b11)
					push_dat <= num_lhs-num_rhs;
				end
		end
		6: begin
			pop_stb <=0;
			if(push_dat !== 0) begin
				push_stb <= 1;
				input_ack <= 1;
				state_machine <= 7;
			end
		end
		7: begin	
			input_ack <= 0;
			output_stb <= 0;
			pop_stb <= 0;
			push_stb <= 0;
			state_machine <= 0;
			num_rhs <= 0;
			num_lhs <= 0;
			push_dat <= 0;
		end
endcase
stack mystack(
.clk(clk),
.rst(rst),
.push_stb(push_stb),
.push_dat(push_dat),
.pop_stb(pop_stb),
.pop_dat(pop_dat)
);
endmodule		 

