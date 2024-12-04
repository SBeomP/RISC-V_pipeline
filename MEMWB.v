module MEMWB(

input					clk, rst_n,
input			[31:0]	ReadData,EX_MEM_ALU_result,EX_MEM_pcPlus4, EX_MEM_imm, EX_MEM_pc,
input			[4:0]	EX_MEM_rs1, EX_MEM_rs2, EX_MEM_rd,
input			[1:0]	EX_MEM_ResultSrc,
input					EX_MEM_RegWrite,
input					EX_MEM_MemtoReg,
input			[2:0]	EX_MEM_funct3,
input					EX_MEM_JAL, EX_MEM_JALR, EX_MEM_LUI, EX_MEM_AUIPC,

output	reg		[31:0]	MEM_WB_ReadData,MEM_WB_ALU_result,MEM_WB_pcPlus4, MEM_WB_imm, MEM_WB_pc,
output	reg		[4:0]	MEM_WB_rs1, MEM_WB_rs2,MEM_WB_rd,	
output	reg		[1:0]	MEM_WB_ResultSrc,
output	reg				MEM_WB_RegWrite, MEM_WB_MemtoReg,
output	reg		[2:0]	MEM_WB_funct3,
output	reg				MEM_WB_JAL, MEM_WB_JALR, MEM_WB_LUI, MEM_WB_AUIPC






);


always @(posedge clk) // MEM/WB 레지스터
	begin
		if (!rst_n)
			begin
				MEM_WB_ReadData <= 0;
				MEM_WB_MemtoReg <= 0;
				MEM_WB_ALU_result <= 0;
				MEM_WB_rd <= 0;
				MEM_WB_RegWrite <= 0;
				MEM_WB_ResultSrc <= 0;  
				MEM_WB_pcPlus4 <= 0;
				MEM_WB_pc <= 0;
				MEM_WB_funct3 <= 0;
				MEM_WB_imm <= 0;
				MEM_WB_rs1 <= 0;
				MEM_WB_rs2 <= 0;
				MEM_WB_JAL <= 0;
				MEM_WB_JALR <= 0;
				MEM_WB_LUI <= 0;
				MEM_WB_AUIPC<= 0;
			end
		else
			begin
				MEM_WB_ReadData <= ReadData;
				MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
				MEM_WB_ALU_result <= EX_MEM_ALU_result;
				MEM_WB_rd <= EX_MEM_rd;
				MEM_WB_RegWrite <= EX_MEM_RegWrite;
				MEM_WB_ResultSrc <= EX_MEM_ResultSrc;  
				MEM_WB_pcPlus4 <= EX_MEM_pcPlus4;
				MEM_WB_pc <= EX_MEM_pc;
				MEM_WB_funct3 <= EX_MEM_funct3;
				MEM_WB_imm <= EX_MEM_imm;
				MEM_WB_rs1 <= EX_MEM_rs1;
				MEM_WB_rs2 <= EX_MEM_rs2;
				MEM_WB_JAL <= EX_MEM_JAL;
				MEM_WB_JALR <= EX_MEM_JALR;
				MEM_WB_LUI <= EX_MEM_LUI;
				MEM_WB_AUIPC<= EX_MEM_AUIPC;
				
			end
	end
	
endmodule