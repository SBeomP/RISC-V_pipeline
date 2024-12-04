module alumux(ALUSrc, rs2_data, ID_EX_imm, b);

input ALUSrc;
input [31:0] rs2_data, ID_EX_imm;
output [31:0] b;

assign b = ALUSrc ? ID_EX_imm : rs2_data;

endmodule