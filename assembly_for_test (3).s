main :
	jal ra, test_1 
	auipc a0, 0x12345
	addi sp, sp, -20
	sh a0, 16(sp)
	sb a0, 20(sp)
	lw a1, 16(sp)
	lw a2, 20(sp)
	addi sp, sp, 20
	jal ra, test_3
sub :
	bge a0, a1, test_5
	

test_1:
	addi sp, sp, -12
	lui a0, 0x00008 
	addi a0, a0, 16 
	lui a1, 0x80000
	addi a1, a1, 24 
	sw a0, 12(sp) 
	sw a1, 8(sp) 
	lh a2, 12(sp) 
	lb a3, 8(sp)
	slti a2, a2, -1
	sltiu a3, a3, 0x7ff
	sw a2, 4(sp)
	sw a3, 0(sp)
	lui a0, 0xfffff
	addi a0, a0, 0x7ff
	lui a1, 0xfffff
	addi a1, a1, 0x7ff
	xori a0, a0, 0x010
	ori a1, a1, 0x010
	andi a2, a2, 0x010
	lui a0, 0x01234
	addi a0, a0, 0x567
	addi a1, zero, 1
	slli a0, a0, 3
	srli a0, a0, 4
	srai a0, a0, 2
	lw a0, 0(sp)
	addi sp, sp, 12
	beq a0, a1, test_2

test_2:
	addi a2, zero, 15
	addi a3, zero, -21
	add a0, a2, a3
	sub a1, a2, a3
	addi a2, zero, 2
	addi a3, zero, 3
	sll a0, a0, a2
	srl a1, a1, a3
	srl a0, a0, a3
	lui a2, 0x10101
	addi a2, a2, 0x010
	or a3, a0, a2
	and a4, a0, a2
	xor a5, a0, a2
	slt a0, a0, a2
	sltu a0, a0, a2
	jalr ra, ra, 0
	
	
test_3:
	addi a0, zero, 0
	addi a1, zero, -1
	bne a0, a1, test_4

test_4:
	blt a1, a0, sub

test_5:
	bltu a0, a1, test_6

test_6: 
	bgeu a1, a0, main
