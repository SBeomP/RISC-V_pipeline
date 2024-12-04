module IFID(

input				clk,rst_n, 
input				StallD, FlushD,
input 		[31:0]	inst,pc,

output reg	[31:0]	IF_ID_inst,IF_ID_pc,IF_ID_pcPlus4



);





always @(posedge clk) // IF/ID 레지스터
	begin
		if (!rst_n) 
			begin
				IF_ID_inst <= 0;
				IF_ID_pc <= 0;
				IF_ID_pcPlus4 <= 0; //PC+4 값 저장하는거
			end
		else if (StallD)
			begin
				IF_ID_inst <= IF_ID_inst;
				IF_ID_pc <= IF_ID_pc;
				IF_ID_pcPlus4 <= IF_ID_pcPlus4; //PC+4 값 저장하는거
			end
		else if (FlushD) 
			begin
				IF_ID_inst <= 0;
				IF_ID_pc <= 0;
				IF_ID_pcPlus4 <= 0; 
			end
		else 
			begin
				IF_ID_inst <= inst;
				IF_ID_pc <= pc;
				IF_ID_pcPlus4 <= pc+4; //PC+4 값 저장하는거
			end
		
	end
	

endmodule