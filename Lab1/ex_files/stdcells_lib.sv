// **************************************************** 
// Project      : Advanced Logic Design Course   
// File         : stdcells_lib.sv
// Description  : Gate level mini library  Module. 
//              :   a simple two elements GATE Level with delay  library . 
//              : used for modelsim tutorial
// Rev          : 1.0 
// Last Updated : 15/Oct/2018
// *****************************************************

`timescale 1ps / 1ps 

module d04non031n0b0 (
                      input   a ,
                      input   b , 
					  input   c,
					  output o1 
					  );


 assign #10 o1 = ~( a || b || c ) ;
 
 
endmodule 

`timescale 1ps / 1ps 

module d04nan021n0a5 (
                      input   a ,
                      input   b , 
					 

					  output o1 
					  );


assign #10  o1 =   ~( a && b ) ;
 
 
endmodule 


//****************  End ******************************* 
//