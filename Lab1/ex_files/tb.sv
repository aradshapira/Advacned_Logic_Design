
// **************************************************** 
// Project      : Advanced Logic Design Course   
// File         : tb.sv
// Description  : Safe Box Key - test bench  Module. 
//              : Implement a simple test bench for the key opening module. 
//              : used for modelsim tutorial
// Author       : Refael Gantz
// Rev          : 1.0 
// Last Updated : 15/Oct/2018
// ****************************************************** 

`timescale 1ps / 1ps 

module tb () ;
  
  logic [3:0] key ;
  logic       valid ;
  
  // DUT Instance 

 safe_box_key DUT (
                     .key(key),
                     .valid(valid)
                  );
                  
 // Test Flow
 initial
   begin
    repeat (100)
      begin
        key = $urandom();
        #200ps;
   end

end

endmodule // tb                  
 


//****************************************************** 
//