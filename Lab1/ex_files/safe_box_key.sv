
// ****************************************************** 
// Project      : Advanced Logic Design Course   
// File         : safe_box_key.sv
// Description  : Safe Box Key Module. 
//              : Implement a simple key opening signal. 
//              : used for modelsim tutorial
// Author       : Refael Gantz
// Rev          : 1.0 
// Last Updated : 15/Oct/2018
//****************************************************** 


module safe_box_key (
                      input [3:0] key,
                      output   valid
);

assign valid = (key == 4'ha) ;

endmodule 


//****************************************************** 
//