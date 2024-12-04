module forward_mux1 (
  input        [31:0] rs1_data, ID_EX_rs1_data, rd_data, EX_MEM_ALU_result,
  input        [1:0]       ForwardAE,
  output reg   [31:0] forward_a

);

//assign a = ForwardAE[1] ? ALUResultM : (ForwardAE[0] ? ResultW : RD1E);
always @(*)
begin
case (ForwardAE)
 
 2'b00: forward_a = ID_EX_rs1_data;
 2'b01: forward_a = rd_data;
 2'b10: forward_a = EX_MEM_ALU_result;

 default: forward_a =ID_EX_rs1_data;

endcase

end
endmodule
