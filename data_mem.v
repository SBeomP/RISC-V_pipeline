module data_mem(ReadData, EX_MEM_ALU_result, EX_MEM_WriteData, clk, rst_n, EX_MEM_MemWrite, EX_MEM_funct3, EX_MEM_MemRead);

input [31:0] EX_MEM_ALU_result;
input [31:0] EX_MEM_WriteData;
input clk, rst_n, EX_MEM_MemWrite, EX_MEM_MemRead;
input [2:0] EX_MEM_funct3;
output reg [31:0] ReadData;

reg [7:0] Mem_Data [0:1000];
wire [7:0] address_set;
integer i;


assign address_set = EX_MEM_ALU_result +100;


always @ (posedge clk) 
begin
	if (EX_MEM_MemWrite) 
	begin
		case(EX_MEM_funct3)
			3'b000 : Mem_Data[address_set+0] <= EX_MEM_WriteData[7-:8]; //SB
					
			3'b001 : begin // SH
						Mem_Data[address_set+1] <= EX_MEM_WriteData[15-:8];
						Mem_Data[address_set+0] <= EX_MEM_WriteData[7-:8];
					 end
			3'b010 : begin // SW
						Mem_Data[address_set+3] <= EX_MEM_WriteData[31-:8];
						Mem_Data[address_set+2] <= EX_MEM_WriteData[23-:8];
						Mem_Data[address_set+1] <= EX_MEM_WriteData[15-:8];
						Mem_Data[address_set+0] <= EX_MEM_WriteData[7-:8];
					 end
			default : ;
		endcase
    end
	else;
end


always @(*) // LOAD 출력 결정
begin
	if(EX_MEM_MemRead)
	begin
		case(EX_MEM_funct3)
			3'b000 : ReadData = {{24{Mem_Data[address_set +0][7]}},Mem_Data[address_set +0]};
			3'b001 : ReadData = {{16{Mem_Data[address_set +1][7]}},Mem_Data[address_set +1],Mem_Data[address_set +0]};
			3'b010 : ReadData = {Mem_Data[address_set +3], Mem_Data[address_set+2], Mem_Data[address_set +1], Mem_Data[address_set +0]};
			3'b100 : ReadData = {24'b0,Mem_Data[address_set +0]};
			3'b101 : ReadData = {16'b0,Mem_Data[address_set +1],Mem_Data[address_set +0]};
			default : ;
		endcase
	end
	else
		ReadData = 32'bx;
end


endmodule
