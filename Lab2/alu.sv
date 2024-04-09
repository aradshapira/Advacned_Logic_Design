module alu (
    input logic [7:0] a,     		//signed operand   
    input logic [7:0] b,		//signed operand
    input logic [3:0] op,		//ALU operation
    output logic [7:0] result		//signed operation result  
);

always_comb
    case (op)
        4'b0001: result = a & b;  					//Bitwise AND
        4'b0010: result =  a | b; 					//Bitwise OR
        4'b0011: result =  a || b; 					//Logical OR
        4'b1001: result =  (~a)+8'b1;  					//Two?s complement of A
        4'b1011: result =  a>>1; 					//Logical shift 1-bit right of A
        4'b1100: result = a[7] ? ((a>>1)+8'b10000000) : (a>>1)  ; 	//Arithmetic shift 1-bit right of A
        4'b1101: result = b[7] ? ((b<<1)+8'b1) : (b<<1) ; 		//Rotate 1-bit left of B
        default: result = 8'b0;  					// else: put 0
    endcase

endmodule
