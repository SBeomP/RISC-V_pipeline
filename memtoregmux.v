module memtoregmux(clk, MEM_WB_MemtoReg, MEM_WB_ALU_result, ReadData, rd_data, MEM_WB_JAL, MEM_WB_pc, MEM_WB_JALR, MEM_WB_LUI, MEM_WB_AUIPC, MEM_WB_imm, MEM_WB_ResultSrc, MEM_WB_ReadData);

input clk, MEM_WB_MemtoReg, MEM_WB_JAL, MEM_WB_JALR, MEM_WB_LUI, MEM_WB_AUIPC;
input [31:0] MEM_WB_ALU_result, ReadData, MEM_WB_ReadData, MEM_WB_pc, MEM_WB_imm;
input [1:0]	MEM_WB_ResultSrc;
output reg [31:0] rd_data;

always @(*)
begin
	if(MEM_WB_MemtoReg) rd_data <= MEM_WB_ReadData;
	else
	begin
//	else if(MEM_WB_LUI) rd_data <= MEM_WB_imm;
//	else if(MEM_WB_AUIPC) rd_data <= MEM_WB_pc + MEM_WB_imm;
//	else if(MEM_WB_JAL) rd_data <= MEM_WB_pc +4 ;
//	else if(MEM_WB_JALR) rd_data <= MEM_WB_pc +4;
	
//	else rd_data <= MEM_WB_ALU_result;
	case(MEM_WB_ResultSrc)
		2'b00 : rd_data <= MEM_WB_ALU_result;
		2'b01 : rd_data <= MEM_WB_ReadData;
		2'b10 : rd_data <= MEM_WB_pc+4;
		
		default : rd_data <= MEM_WB_ReadData;
	endcase
	end
end

endmodule