module mux_result (
  input  	   [31:0] MEM_WB_ALU_result, MEM_WB_ReadData, MEM_WB_pcPlus4,
  input        [1:0]  MEM_WB_ResultSrc,
  output reg   [31:0] rd_data
  );

 // assign rd_data = ResultSrcW[1] ? MEM_WB_PCPlus4 : (ResultSrcW[0] ? MEM_WB_ReadData : MEM_WB_ALU_Result);
always @(*) begin

  case(MEM_WB_ResultSrc)

  2'b00:  rd_data = MEM_WB_ALU_result;
  2'b01:  rd_data = MEM_WB_ReadData;
  2'b10:  rd_data = MEM_WB_pcPlus4;

  default: rd_data = MEM_WB_ReadData;
endcase
end

endmodule





