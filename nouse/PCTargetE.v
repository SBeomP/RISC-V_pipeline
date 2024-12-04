module	PCTargetE(
	input	[31:0] ID_EX_pc, ID_EX_imm,
	output	reg [31:0] PCTargetE
	);
	
always@ (*)
	PCTargetE = ID_EX_pc + ID_EX_imm;
	
	
endmodule