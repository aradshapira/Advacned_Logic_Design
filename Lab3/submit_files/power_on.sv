/*
 * Authors: Arad Shapira, Tomer Hershku
 * Lab3 - ALD @ HUJI
 * Description: Implements the required power_on module  
 */


module power_on (
    input logic resetb,         //rst
    input logic clk,            //clock
    input logic power_good,     //Power good indication
    output logic enable         //Enable signal ,The enable should be asserted 300ns (=30 clock cycles at 100Mhz freq.) after 
                                //power_good signal is asserted and stable 
);

logic [4:0] counter ;        //counter to count until 31

always_ff @(posedge clk or negedge resetb)
begin
    if (~resetb)
        counter <= 5'b0;            //reset counter
    else if (~power_good)
        counter <= 5'b0;           //reset counter
    else if (counter == 5'b11111)
        counter <= counter;       //keep current counter
    else if (counter != 5'b11111) 
        counter <= counter +5'b00001;  //if we haven't reached 31 cycle yet - need to add 1b'1    
end

assign enable = (counter == 5'b11111);            //if counter is 31 then we need to output enable as 1'b1

endmodule
