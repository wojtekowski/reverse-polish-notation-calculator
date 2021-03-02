//wojciech rosciszewski wojtanowski 140062 pdc project
module stack	  
(                            
input  wire        clk,      
input  wire        rst,                      
input  wire        push_stb, 
input  wire [31:0] push_dat,                            
input  wire        pop_stb,  
output wire [31:0] pop_dat, 
);                           
reg    	[3:0] pp_ptr;
reg		[31:0] ram[0:15];

always@(posedge clk or posedge rst) begin
	if(rst) pp_ptr <= 4'd0;
	else if(push_stb)
		pp_ptr <= pp_ptr + 4'd1;  
	else if(pop_stb)
		pp_ptr <= pp_ptr - 4'd1;
	end
	always@(posedge clk or posedge rst)
	if(push_stb)
		ram[pp_ptr] <= push_dat;
		assign pop_dat = ram[pp_ptr-4'd1];
endmodule
