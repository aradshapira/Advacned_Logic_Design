// ****************************************************** 
// Project      : Advanced Logic Design Course   
// File         : safe_box_key_gl.sv
// Description  : Safe Box Key Module. 
//             :   a simple key opening signal - After Synthesis. 
//             : used for modelsim tutorial
// Rev          : 1.0 
// Last Updated : 15/Oct/2018
// ****************************************************** 

module safe_box_key (
                      input [3:0] key,
                      output   valid
);


 wire n3 ;

 d04non031n0b0   U3 (.a(n3) , .b(key[2]), .c(key[0]), .o1(valid) );
 d04nan021n0a5   U4 (.a(key[3]) , .b(key[1]),   .o1(n3) );
 
endmodule 


//****************************************************** 
//