module mux_alu(
  input  			   ID_EX_ALUSrc,
  input  		[31:0] forward_b, ID_EX_imm,
  output reg		[31:0] b
  );

always@(*)
begin
  b <= ID_EX_ALUSrc ?  ID_EX_imm:forward_b;
end


endmodule


// To call this module:
//  mux_alu #(32)   mux(RegisterData, ImmValue, ContSelector, OutB);
