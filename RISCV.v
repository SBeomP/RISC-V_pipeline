module RISCV(clk, rst_n, start);

input clk, rst_n, start;
reg [31:0] pc;

wire RegWrite, MemWrite, MemRead, MemtoReg, ALUSrc, branch, LUI, AUIPC, JAL, JALR, N, Z, C, V;
wire [31:0] imm, b, ReadData, result, inst, rd_data, rs1_data, rs2_data;
wire [4:0] rs1, rs2,A1,A2, rd, ALUcontrol;
wire [2:0] immtype;
wire [2:0] funct3;
wire [1:0] ResultSrc;

wire [31:0] IF_ID_inst,IF_ID_pc,IF_ID_pcPlus4;

wire	[31:0]	ID_EX_pc, ID_EX_pcPlus4, ID_EX_rs1_data, ID_EX_rs2_data, ID_EX_imm;
wire	[4:0]	ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
wire 	[4:0]	ID_EX_ALUcontrol;
wire	[2:0]	ID_EX_funct3;
wire	[1:0]	ID_EX_ResultSrc;
wire			ID_EX_MemRead, ID_EX_MemWrite, ID_EX_RegWrite,  ID_EX_MemtoReg;
wire			ID_EX_JAL, ID_EX_JALR, ID_EX_branch, ID_EX_ALUSrc, ID_EX_AUIPC, ID_EX_LUI;
wire			StallD,FlushD;

wire		[31:0]	EX_MEM_ALU_result, EX_MEM_rs1_data, EX_MEM_rs2_data, EX_MEM_WriteData, EX_MEM_pcPlus4, EX_MEM_imm, EX_MEM_pc;
wire		[4:0] 	EX_MEM_rs1, EX_MEM_rs2, EX_MEM_rd;
wire		[1:0]	EX_MEM_ResultSrc;
wire		[2:0]	EX_MEM_funct3;
wire				EX_MEM_RegWrite,  EX_MEM_MemRead, EX_MEM_JAL, EX_MEM_JALR, EX_MEM_AUIPC, EX_MEM_LUI;
wire				EX_MEM_MemWrite, EX_MEM_MemtoReg;
wire				FlushE, StallF;

wire		[31:0]	MEM_WB_ReadData,MEM_WB_ALU_result,MEM_WB_pcPlus4, MEM_WB_imm, MEM_WB_pc;
wire		[4:0]	MEM_WB_rs1, MEM_WB_rs2, MEM_WB_rd;
wire		[1:0]	MEM_WB_ResultSrc;
wire		[2:0]	MEM_WB_funct3;
wire				MEM_WB_RegWrite, MEM_WB_MemtoReg;
wire				MEM_WB_JAL, MEM_WB_JALR, MEM_WB_AUIPC, MEM_WB_LUI;

wire				PCSrc;
wire		[1:0] 	ForwardAE, ForwardBE;


wire        [31:0] ResultW;
wire	    [31:0] forward_a;	

wire		[31:0] forward_b;

wire		[31:0]	PCTargetE;



wire beq, bne, blt, bge, bltu, bgeu;
wire beq_taken, bne_taken, blt_taken, bge_taken, bltu_taken, bgeu_taken, btaken;




assign beq  = (funct3 == 3'b000);
assign bne  = (funct3 == 3'b001);
assign blt  = (funct3 == 3'b100);
assign bge  = (funct3 == 3'b101);
assign bltu = (funct3 == 3'b110);
assign bgeu = (funct3 == 3'b111);

assign beq_taken  =  branch & beq & Z;
assign bne_taken  =  branch & bne & ~Z;
assign blt_taken  =  branch & blt & (N!=V);
assign bge_taken  =  branch & bge & (N==V);
assign bltu_taken =  branch & bltu & ~C;
assign bgeu_taken =  branch & bgeu & C;
assign btaken =  beq_taken  | bne_taken | blt_taken | bge_taken | bltu_taken | bgeu_taken;
assign rs1 = IF_ID_inst[19:15];
assign rs2 = IF_ID_inst[24:20];
assign A1 = IF_ID_inst[19:15];
assign A2 = IF_ID_inst[24:20];
assign rd = IF_ID_inst[11:7];
assign funct3  = IF_ID_inst[14:12];


//IF
inst_mem im (
.clk(clk), 
.rst_n(rst_n), 
.pc(pc), 
.inst(inst));



//******************************//
//IFIDFF//
IFID IFID (
.clk(clk), 
.rst_n(rst_n), 
.StallD(StallD), 
.FlushD(FlushD),  
.inst(inst), 
.pc(pc), 
.IF_ID_inst(IF_ID_inst), 
.IF_ID_pc(IF_ID_pc), 
.IF_ID_pcPlus4(IF_ID_pcPlus4));
//******************************//


//ID
regfile rf (
.clk(clk), 
.MEM_WB_RegWrite(MEM_WB_RegWrite), 
.A1(A1), //rs1
.A2(A2), //rs2
.MEM_WB_rd(MEM_WB_rd), 
.rd_data(rd_data), 
.rs1_data(rs1_data), 
.rs2_data(rs2_data), 
.rst_n(rst_n));


control ct (
.IF_ID_inst(IF_ID_inst), 
.ResultSrc(ResultSrc), 
.RegWrite(RegWrite), 
.MemWrite(MemWrite), 
.MemRead(MemRead), 
.MemtoReg(MemtoReg), 
.ALUSrc(ALUSrc), 
.branch(branch), 
.JAL(JAL), 
.AUIPC(AUIPC), 
.LUI(LUI), 
.JALR(JALR), 
.ALUcontrol(ALUcontrol), 
.immtype(immtype));

immgen ig (
.immtype(immtype), 
.IF_ID_inst(IF_ID_inst), 
.imm(imm));


//******************************//
//IDEXFF
IDEX IDEX (
.clk(clk), 
.rst_n(rst_n), 
.FlushE(FlushE), 
.ResultSrc(ResultSrc), 
.PCSrc(PCSrc), 
.btaken(btaken),
.ID_EX_ResultSrc(ID_EX_ResultSrc), 
.ALUSrc(ALUSrc), 
.MemtoReg(MemtoReg),
.LUI(LUI), 
.AUIPC(AUIPC),  
.IF_ID_pc(IF_ID_pc), 
.IF_ID_pcPlus4(IF_ID_pcPlus4), 
.rs1_data(rs1_data), 
.rs2_data(rs2_data), 
.imm(imm), 
.rs1(rs1), 
.rs2(rs2), 
.Z(Z),
.rd(rd), 
.ALUcontrol(ALUcontrol), 
.funct3(funct3), 
.MemRead(MemRead), 
.MemWrite(MemWrite), 
.RegWrite(RegWrite), 
.JAL(JAL), 
.JALR(JALR), 
.branch(branch), 
.ID_EX_pc(ID_EX_pc), 
.ID_EX_pcPlus4(ID_EX_pcPlus4),
.ID_EX_ALUSrc(ID_EX_ALUSrc), 
.ID_EX_rs1_data(ID_EX_rs1_data), 
.ID_EX_rs2_data(ID_EX_rs2_data), 
.ID_EX_imm(ID_EX_imm), 
.ID_EX_rs1(ID_EX_rs1), 
.ID_EX_rs2(ID_EX_rs2), 
.ID_EX_rd(ID_EX_rd), 
.ID_EX_funct3(ID_EX_funct3), 
.ID_EX_MemRead(ID_EX_MemRead), 
.ID_EX_MemWrite(ID_EX_MemWrite), 
.ID_EX_RegWrite(ID_EX_RegWrite), 
.ID_EX_MemtoReg(ID_EX_MemtoReg),
.ID_EX_JAL(ID_EX_JAL), 
.ID_EX_JALR(ID_EX_JALR), 
.ID_EX_branch(ID_EX_branch), 
.ID_EX_ALUcontrol(ID_EX_ALUcontrol), 
.ID_EX_AUIPC(ID_EX_AUIPC), 
.ID_EX_LUI(ID_EX_LUI)); 
//******************************//

//EX


alu au (
.ID_EX_ALUcontrol(ID_EX_ALUcontrol), 
.a(forward_a), 
.b(b), 
.result(result), 
.N(N), .Z(Z), .C(C), .V(V));


mux_alu  JJJ (
.ID_EX_ALUSrc(ID_EX_ALUSrc),
.forward_b(forward_b), 
.ID_EX_imm(ID_EX_imm),
.b(b));

forward_mux1  RRR (
.ID_EX_rs1_data(ID_EX_rs1_data), 
.rs1_data(rs1_data),
.rd_data(rd_data), 
.EX_MEM_ALU_result(EX_MEM_ALU_result),
.ForwardAE(ForwardAE),
.forward_a(forward_a));

forward_mux2  SSS (
.ID_EX_rs2_data(ID_EX_rs2_data), 
.rs2_data(rs2_data),
.rd_data(rd_data), 
.EX_MEM_ALU_result(EX_MEM_ALU_result),
.ForwardBE(ForwardBE),
.forward_b(forward_b));

hazard_unit har( 
.EX_MEM_RegWrite(EX_MEM_RegWrite), 
.MEM_WB_RegWrite(MEM_WB_RegWrite), 
.PCSrc(PCSrc), 
.rs1(rs1), 
.rs2(rs2), 
.ID_EX_rs1(ID_EX_rs1), 
.ID_EX_rs2(ID_EX_rs2), 
.ID_EX_rd(ID_EX_rd), 
.EX_MEM_rd(EX_MEM_rd), 
.MEM_WB_rd(MEM_WB_rd), 
.ID_EX_ResultSrc(ID_EX_ResultSrc), 
.ForwardAE(ForwardAE), 
.ForwardBE(ForwardBE), 
.StallF(StallF), 
.StallD(StallD), 
.FlushE(FlushE), 
.FlushD(FlushD),
.ID_EX_MemRead(ID_EX_MemRead));

//******************************//
//EXMEMFF
EXMEM EXMEM (
.clk(clk), 
.rst_n(rst_n), 
.result(result),  
.ID_EX_ResultSrc(ID_EX_ResultSrc), 
.EX_MEM_ResultSrc(EX_MEM_ResultSrc), 
.ID_EX_rs2_data(ID_EX_rs2_data), 
.forward_b(forward_b), 
.ID_EX_pcPlus4(ID_EX_pcPlus4), 
.ID_EX_rd(ID_EX_rd), 
.ID_EX_RegWrite(ID_EX_RegWrite), 
.ID_EX_MemWrite(ID_EX_MemWrite), 
.ID_EX_MemRead(ID_EX_MemRead),
.ID_EX_AUIPC(ID_EX_AUIPC), 
.ID_EX_LUI(ID_EX_LUI), 
.ID_EX_JAL(ID_EX_JAL), 
.ID_EX_JALR(ID_EX_JALR),
.ID_EX_branch(ID_EX_branch),
.ID_EX_funct3(ID_EX_funct3),
.ID_EX_rs1_data(ID_EX_rs1_data), 
.EX_MEM_funct3(EX_MEM_funct3), 
.EX_MEM_ALU_result(EX_MEM_ALU_result), 
.EX_MEM_rs2_data(EX_MEM_rs2_data), 
.EX_MEM_WriteData(EX_MEM_WriteData),
.EX_MEM_pc(EX_MEM_pc), 
.ID_EX_pc(ID_EX_pc), 
.EX_MEM_pcPlus4(EX_MEM_pcPlus4), 
.EX_MEM_rd(EX_MEM_rd), 
.EX_MEM_RegWrite(EX_MEM_RegWrite), 
.EX_MEM_MemWrite(EX_MEM_MemWrite), 
.ID_EX_imm(ID_EX_imm), 
.EX_MEM_rs1(EX_MEM_rs1), 
.EX_MEM_rs2(EX_MEM_rs2),
.ID_EX_rs1(ID_EX_rs1), 
.ID_EX_rs2(ID_EX_rs2), 
.EX_MEM_JAL(EX_MEM_JAL), 
.EX_MEM_JALR(EX_MEM_JALR), 
.EX_MEM_LUI(EX_MEM_LUI), 
.EX_MEM_AUIPC(EX_MEM_AUIPC), 
.EX_MEM_imm(EX_MEM_imm), 
.EX_MEM_MemRead(EX_MEM_MemRead), 
.ID_EX_MemtoReg(ID_EX_MemtoReg), 
.EX_MEM_MemtoReg(EX_MEM_MemtoReg),
.EX_MEM_branch(EX_MEM_branch),
.EX_MEM_rs1_data(EX_MEM_rs1_data));
//******************************//

//MEM

data_mem dm (
.clk(clk), 
.rst_n(rst_n), 
.EX_MEM_MemWrite(EX_MEM_MemWrite), 
.EX_MEM_ALU_result(EX_MEM_ALU_result), 
.EX_MEM_WriteData(EX_MEM_WriteData), 
.ReadData(ReadData), 
.EX_MEM_funct3(EX_MEM_funct3), 
.EX_MEM_MemRead(EX_MEM_MemRead));


//******************************//
//MEMWBFF//
MEMWB MEMWB (
.clk(clk), 
.rst_n(rst_n), 
.ReadData(ReadData),
.EX_MEM_ResultSrc(EX_MEM_ResultSrc), 
.MEM_WB_ResultSrc(MEM_WB_ResultSrc), 
.EX_MEM_ALU_result(EX_MEM_ALU_result), 
.EX_MEM_pcPlus4(EX_MEM_pcPlus4), 
.EX_MEM_rd(EX_MEM_rd), 
.EX_MEM_RegWrite(EX_MEM_RegWrite), 
.MEM_WB_ReadData(MEM_WB_ReadData), 
.MEM_WB_ALU_result(MEM_WB_ALU_result), 
.EX_MEM_funct3(EX_MEM_funct3), 
.MEM_WB_funct3(MEM_WB_funct3), 
.MEM_WB_pcPlus4(MEM_WB_pcPlus4), 
.MEM_WB_rd(MEM_WB_rd), 
.MEM_WB_RegWrite(MEM_WB_RegWrite),
.EX_MEM_pc(EX_MEM_pc), 
.MEM_WB_pc(MEM_WB_pc), 
.EX_MEM_MemtoReg(EX_MEM_MemtoReg), 
.MEM_WB_MemtoReg(MEM_WB_MemtoReg),
.EX_MEM_imm(EX_MEM_imm),
.MEM_WB_imm(MEM_WB_imm), 
.EX_MEM_rs1(EX_MEM_rs1), 
.EX_MEM_rs2(EX_MEM_rs2),
.MEM_WB_rs1(MEM_WB_rs1), 
.MEM_WB_rs2(MEM_WB_rs2), 
.EX_MEM_JAL(EX_MEM_JAL), 
.EX_MEM_JALR(EX_MEM_JALR), 
.EX_MEM_LUI(EX_MEM_LUI), 
.EX_MEM_AUIPC(EX_MEM_AUIPC), 
.MEM_WB_JAL(MEM_WB_JAL), 
.MEM_WB_JALR(MEM_WB_JALR), 
.MEM_WB_LUI(MEM_WB_LUI), 
.MEM_WB_AUIPC(MEM_WB_AUIPC));
//******************************//


//WB

memtoregmux mm(
.clk(clk),
.MEM_WB_MemtoReg(MEM_WB_MemtoReg), 
.MEM_WB_ResultSrc(MEM_WB_ResultSrc), 
.MEM_WB_ReadData(MEM_WB_ReadData), 
.MEM_WB_ALU_result(MEM_WB_ALU_result), 
.ReadData(ReadData), .rd_data(rd_data), 
.MEM_WB_JAL(MEM_WB_JAL), 
.MEM_WB_pc(MEM_WB_pc), 
.MEM_WB_JALR(MEM_WB_JALR), 
.MEM_WB_imm(MEM_WB_imm),
.MEM_WB_AUIPC(MEM_WB_AUIPC), 
.MEM_WB_LUI(MEM_WB_LUI));













always @(posedge clk) // branch, JAL, JALR , pc블록
begin
	if(!rst_n) pc <= 32'b0;

	else if(start)
		if(StallF)
			pc <= pc;
		else 
//			pc <= PCbar;
			begin
				if(ID_EX_branch) pc <= ID_EX_pc + ID_EX_imm;
				else if(ID_EX_JAL) pc <= ID_EX_pc + ID_EX_imm;
				else if(ID_EX_JALR) pc <= ID_EX_rs1_data + ID_EX_imm ;
				else pc <= pc + 4;
			end
	
	else;
end

endmodule
