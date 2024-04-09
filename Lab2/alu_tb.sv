module alu_tb();

logic [7:0] a;			//signed operand 
logic [7:0] b;			//signed operand 
logic [3:0] op;			//ALU operation	
logic [7:0] result;		//signed operation result

// DUT (Device Under Test)
//instatiation:
alu alu_inst (
	.a(a),
	.b(b),
	.op(op),
	.result(result)
);
`define RANDOM  //feature for help
			 
// Generator
function void randomize_inputs();
	op = $random();
	a = $random();
	b = $random();
endfunction

//in case we wanted to check all op options by incrementing
//function void inc_inputs();
	//a = $random();
	//b = $random();
	//op = op + 1;
//endfunction

// Driver
task automatic drive_inputs();
`ifdef RANDOM
	randomize_inputs();
//`else
	//inc_inputs();  //no need for that in our exercise
`endif
	#1ns; //dealy given
endtask

initial
	begin
		{a,b,op} = 0;  //reset all relevant values to 0
		#1ns;	       //delay
		//now generating numbers 100 times
		repeat(100)
			drive_inputs();
	end

// Golden model
function logic [7:0] golden_model(input logic [7:0] a, input logic [7:0] b, input logic [3:0] op);

	case (op) 							//trying to do the calculation little different
            4'b0001: golden_model = a & b; 				 //Bitwise AND
            4'b0010: golden_model =  a | b; 				//Bitwise OR
            4'b0011: golden_model =  (|a) | (|b); 			//Logical OR
            4'b1001: golden_model =  -a;    				//2's complement of A
            4'b1011: golden_model =  {1'b0 , a[7:1]};			 //Logical shift 1-bit right of A
            4'b1100: golden_model = {a[7] , a[7:1]} ; 			//Arithmetic shift 1-bit right of A
            4'b1101: golden_model = {b[6:0] , b[7]}  ; 			//Rotate 1-bit left of B
            default: golden_model = 8'b0	; 			 // else: put 0	
	endcase

endfunction 
	
// Checker
function void check_ALU(input logic [7:0] a, input logic [7:0] b, logic [3:0] op);
	logic [7:0] exp_result;
	 
	exp_result = golden_model(a, b, op);  //using the golden model function
	
	$display("a_check=%b  b_check=%b op=%b result=%b \n", a, b, op, result);

	if (exp_result != result)
		$error("checker failed: exp_result=%b (%d)", exp_result, exp_result);
endfunction
	
// Monitor
initial
	begin
		forever
			begin
				@(a, b, result);
				#0;
				check_ALU(a,b,op);
			end
	end
				

endmodule







