module forward_mux2 (
  input  	   [31:0] rs2_data,ID_EX_rs2_data, rd_data, EX_MEM_ALU_result,
  input        [1:0]       ForwardBE,
  output reg   [31:0] forward_b
);



always @(*)
begin
case (ForwardBE)
 
 2'b00: forward_b = ID_EX_rs2_data;
 2'b01: forward_b = rd_data;
 2'b10: forward_b = EX_MEM_ALU_result;

 default: forward_b = ID_EX_rs2_data;

endcase

end
endmodule

