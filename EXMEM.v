module EXMEM(

input					clk, rst_n,
input			[31:0]	result,ID_EX_rs1_data, ID_EX_rs2_data, forward_b, ID_EX_pcPlus4, ID_EX_pc, ID_EX_imm,
input			[4:0] 	ID_EX_rs1, ID_EX_rs2, ID_EX_rd,
input			[1:0]	ID_EX_ResultSrc,
input					ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_JAL, ID_EX_JALR,ID_EX_LUI, ID_EX_AUIPC, ID_EX_branch,
input			[2:0]	ID_EX_funct3,


output	reg		[31:0]	EX_MEM_ALU_result,EX_MEM_rs1_data, EX_MEM_rs2_data, EX_MEM_WriteData, EX_MEM_pcPlus4, EX_MEM_pc, EX_MEM_imm,
output	reg		[4:0] 	EX_MEM_rs1, EX_MEM_rs2,EX_MEM_rd,
output	reg		[1:0]	EX_MEM_ResultSrc,
output	reg				EX_MEM_RegWrite,  EX_MEM_MemRead,EX_MEM_JAL, EX_MEM_JALR, EX_MEM_LUI, EX_MEM_AUIPC, EX_MEM_branch,
output 	reg				EX_MEM_MemWrite, EX_MEM_MemtoReg,
output	reg		[2:0]	EX_MEM_funct3




);





always @(posedge clk) // EX/MEM 레지스터
	begin
		if (!rst_n)
			begin
				EX_MEM_MemtoReg <= 0;
				EX_MEM_ALU_result <= 0;
				EX_MEM_rs2_data <= 0;
				EX_MEM_rd <= 0;
				EX_MEM_MemWrite <= 0;
				EX_MEM_MemRead <= 0;
				EX_MEM_RegWrite <= 0;
				EX_MEM_WriteData <= 0;
				EX_MEM_ResultSrc <= 0; 
				EX_MEM_funct3 <= 0; 
				EX_MEM_pcPlus4 <= 0;
				EX_MEM_pc <= 0;				
				EX_MEM_imm <= 0;
				EX_MEM_rs1 <= 0;
				EX_MEM_rs2 <= 0;
				EX_MEM_branch <= 0;
				EX_MEM_rs1_data <= 0;
			end
		else
			begin
				EX_MEM_MemtoReg <= ID_EX_MemtoReg;
				EX_MEM_ALU_result <= result;
				EX_MEM_rs2_data <= ID_EX_rs2_data;
				EX_MEM_rd <= ID_EX_rd;
				EX_MEM_MemWrite <= ID_EX_MemWrite;
				EX_MEM_MemRead <= ID_EX_MemRead;
				EX_MEM_RegWrite <= ID_EX_RegWrite;
				EX_MEM_WriteData <= forward_b;
				EX_MEM_ResultSrc <= ID_EX_ResultSrc;  
				EX_MEM_funct3 <= ID_EX_funct3;  
				EX_MEM_pc <= ID_EX_pc;
				EX_MEM_pcPlus4 <= ID_EX_pcPlus4; //PC+4 값 저장하는거
				EX_MEM_imm <= ID_EX_imm;
				EX_MEM_rs1 <= ID_EX_rs1;
				EX_MEM_rs2 <= ID_EX_rs2;
				EX_MEM_JAL <= ID_EX_JAL;
				EX_MEM_JALR <= ID_EX_JALR;
				EX_MEM_LUI <= ID_EX_LUI;
				EX_MEM_AUIPC<= ID_EX_AUIPC;
				EX_MEM_branch <= ID_EX_branch;
				EX_MEM_rs1_data <= ID_EX_rs1_data;
			end
	end
	
	

endmodule