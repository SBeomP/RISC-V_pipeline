module IDEX(

input				clk, rst_n, ALUSrc, btaken, Z,
input				FlushE,
input		[31:0]	IF_ID_pc, IF_ID_pcPlus4, rs1_data, rs2_data, imm, 
input		[4:0]	rs1, rs2, rd, ALUcontrol,
input		[2:0]	funct3,
input		[1:0]	ResultSrc,
input				MemRead, MemWrite, RegWrite, JAL, JALR, branch, MemtoReg, LUI, AUIPC,


output	reg	[31:0]	ID_EX_pc, ID_EX_pcPlus4, ID_EX_rs1_data, ID_EX_rs2_data, ID_EX_imm,
output	reg	[4:0]	ID_EX_rs1, ID_EX_rs2, ID_EX_rd, 
output 	reg [4:0]	ID_EX_ALUcontrol,
output	reg	[2:0]	ID_EX_funct3,
output	reg	[1:0]	ID_EX_ResultSrc,
output	reg			ID_EX_MemRead, ID_EX_MemWrite, ID_EX_RegWrite,  ID_EX_MemtoReg,
output 	reg			ID_EX_JAL, ID_EX_JALR, ID_EX_branch, ID_EX_ALUSrc,ID_EX_LUI, ID_EX_AUIPC,
output	reg			PCSrc



);







always @(posedge clk) // ID/EX 레지스터
	begin 
		if(! rst_n)
			begin	
				ID_EX_MemtoReg <= 0;
				ID_EX_pc <= 0;
				ID_EX_rs1 <= 0;
				ID_EX_rs2 <= 0;
				ID_EX_funct3 <= 0;
				ID_EX_rd <= 5'b0;
				ID_EX_rs1_data <= 0;
				ID_EX_rs2_data <= 0;
				ID_EX_imm <= 0;
				ID_EX_MemRead <= 0;
				ID_EX_MemWrite <= 0;
				ID_EX_RegWrite <= 0;
				ID_EX_ALUSrc <= 0;
				ID_EX_JAL <= 0;
				ID_EX_JALR <= 0;
				ID_EX_branch <= 0;
				ID_EX_ALUcontrol <= 0;
				ID_EX_LUI <= 0;
				ID_EX_AUIPC<= 0;
				ID_EX_imm <= 0;
				//ID_EX_ALUop <= 0; 우리 aluop 안한거 같은데
				ID_EX_ResultSrc <= 0; 
				//ID_EX_mem_modeE <= 0; Word, halfword 이런거 저장하는건데 뭔지 모르겠음 2
				ID_EX_pcPlus4 <= 0; //PC+4 값 저장

			end
		else if(FlushE)
			begin	
				ID_EX_MemtoReg <= 0;
				ID_EX_pc <= 0;
				ID_EX_rs1 <= 0;
				ID_EX_rs2 <= 0;
				ID_EX_funct3 <= 0;
				ID_EX_rd <= 5'b0;
				ID_EX_rs1_data <= 0;
				ID_EX_rs2_data <= 0;
				ID_EX_imm <= 0;
				ID_EX_MemRead <= 0;
				ID_EX_MemWrite <= 0;
				ID_EX_RegWrite <= 0;
				ID_EX_ALUSrc <= 0;
				ID_EX_JAL <= 0;
				ID_EX_JALR <= 0;
				ID_EX_branch <= 0;
				ID_EX_LUI <= 0;
				ID_EX_AUIPC<= 0;
				ID_EX_imm <= 0;
				ID_EX_ALUcontrol <= 0;
		//		//ID_EX_ALUop <= 0; 우리 aluop 안한거 같은데
				ID_EX_ResultSrc <= 0; 
		//		//ID_EX_mem_modeE <= 0; Word, halfword 이런거 저장하는건데 뭔지 모르겠음 2
				ID_EX_pcPlus4 <= 0; //PC+4 값 저장

			end
		else
			begin	
				ID_EX_MemtoReg <= MemtoReg;
				ID_EX_pc <= IF_ID_pc;
				ID_EX_rs1 <= rs1;
				ID_EX_rs2 <= rs2;
				ID_EX_funct3 <= funct3;
				ID_EX_rd <= rd;
				ID_EX_rs1_data <= rs1_data;
				ID_EX_rs2_data <= rs2_data;
				ID_EX_imm <= imm;
				ID_EX_MemRead <= MemRead;
				ID_EX_MemWrite <= MemWrite;
				ID_EX_RegWrite <= RegWrite;
				ID_EX_branch <= branch;
				ID_EX_ALUSrc <= ALUSrc;
				ID_EX_JAL <= JAL;
				ID_EX_JALR <= JALR;
				ID_EX_LUI <= LUI;
				ID_EX_AUIPC<= AUIPC;
				ID_EX_imm <= imm;
				ID_EX_ALUcontrol <= ALUcontrol;
				//ID_EX_ALUop <= ALUop;
				ID_EX_ResultSrc <= ResultSrc; 
				//ID_EX_mem_modeE <= mem_modeE;
				ID_EX_pcPlus4 <= IF_ID_pcPlus4; // PC+4 값 저장
			end
	end
	
always @(*)
	begin
		PCSrc <= ((Z && ID_EX_branch) || ID_EX_JAL || ID_EX_JALR);
	
	end
endmodule