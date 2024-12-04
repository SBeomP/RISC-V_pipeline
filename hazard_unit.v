module hazard_unit (
    input  	       EX_MEM_RegWrite, MEM_WB_RegWrite, PCSrc, ID_EX_MemRead,
    input  	 [4:0] rs1, rs2, ID_EX_rs1, ID_EX_rs2, ID_EX_rd, EX_MEM_rd, MEM_WB_rd,
    input  	 [1:0] ID_EX_ResultSrc,

    output reg 	 [1:0] ForwardAE, ForwardBE,
    output reg	       StallF, StallD, FlushE, FlushD
);	


  reg lwStall;

  always@(*) begin
    if (((ID_EX_rs1 == EX_MEM_rd) && EX_MEM_RegWrite) && (EX_MEM_rd != 0) ) begin
      ForwardAE <= 2'b10;
    end
    else if ( ((ID_EX_rs1 == MEM_WB_rd) && MEM_WB_RegWrite) && (EX_MEM_RegWrite ==0) && (EX_MEM_rd != 0) && (MEM_WB_rd != 0) ) begin
      ForwardAE <= 2'b01;
    end
    else begin
      ForwardAE <= 2'b00;
    end

  end

  always@(*) begin
    if (((ID_EX_rs2 == EX_MEM_rd) && EX_MEM_RegWrite) && (EX_MEM_rd != 0) ) begin
      ForwardBE <= 2'b10;
    end
    else if ( ((ID_EX_rs2 == MEM_WB_rd) && MEM_WB_RegWrite)&& (EX_MEM_RegWrite ==0) && (EX_MEM_rd != 0) && (MEM_WB_rd != 0) ) begin
      ForwardBE <= 2'b01;
    end
    else begin
      ForwardBE <= 2'b00;
    end

  end

  always@(*) begin//Stall when a load hazard occur
 //   lwStall <= (ID_EX_ResultSrc[0] & ((rs1 == ID_EX_rd) | (rs2 == ID_EX_rd)));//Page 450 
	  lwStall <= (ID_EX_MemRead & ((rs1 == ID_EX_rd) | (rs2 == ID_EX_rd)));
    StallD <= lwStall;
    StallF <= lwStall;
    //Flush When a branch is taken or a load initroduces a bubble
    FlushE <= lwStall | PCSrc;
    FlushD <= PCSrc;
  end

endmodule
