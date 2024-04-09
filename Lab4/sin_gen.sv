module sin_gen (
		   input logic 	      clk,              //512Mhz clock
		   input logic 	      resetb,           //Asynchronous active low reset
           input logic        en,               //Enable the sinus generation (active high)
		   input logic [7:0]  period_sel,       //Define the sinus frequency
		   output logic [8:0] sin_out           //Two?s complement value that represents a
                                                //fractional value between -1 to +1
		   );

//parametr delaration:
parameter logic [7:0] FINISH_COUNT = 8'b1111_1111;

//signals declaration
logic [7:0] address;                    //input to sin_lut
logic [7:0] dout;                       //output of sin_lut
logic [7:0] counter;                    //counter from 0 to 255 - for each quarter drawing of the sinus wave
logic [7:0] inside_counter;             //counter to how much do we need to sample each sinus point
logic [7:0] ff_period_sel;              //saves period_sel when in states Q1, INIT
logic finished_inside_counter;          // in order to recognize when to increase the outer counter     
logic up;                               // up=1 : count from 0 to 255 , up = 0 : count from 255 to 0
logic positive;                         // positive = 1 : in positive sinus part  

//inst
sin_lut inst (.address(address), .dout(dout));

//FSM Declaration
typedef enum logic [2:0] { 
    INIT = 3'h0,    // 000
    Q1 = 3'h1,      // 001
    Q2 = 3'h2,      // 010
    Q3 = 3'h3,      // 011
    Q4 = 3'h4       // 100
    } my_fsm_type;

my_fsm_type cs_fsm;
my_fsm_type ns_fsm;

// check even numbers
assign up = cs_fsm[0]; //  up = 1 only on quarters Q1 & Q3 
assign positive = ((cs_fsm == Q1) | (cs_fsm == Q2));   //positive = 1 only on quarters Q1 & Q2
assign finished_inside_counter = ff_period_sel ? (inside_counter == ff_period_sel) : 1'b1;  //if ff_period_sel =8'b0 than no need to inner counter , outputs 1 only when we finished inner counting
assign address = up ? counter : (~counter) ;                                                //choose how to read the addresses

// Counter
always_ff @(posedge clk or negedge resetb) begin
    if ((~resetb) | (FINISH_COUNT == counter))
        counter <= 8'b0;
    else if ((~(cs_fsm == INIT)) & (finished_inside_counter))
        counter <= counter + 1'b1;
end   

// Inside counter - the inner counter
always_ff @(posedge clk or negedge resetb) begin
    if ((~resetb) | (inside_counter == ff_period_sel))
        inside_counter <= 8'b0;
    else if ((~(cs_fsm == INIT)) & (ff_period_sel)) // need to check that while ff_period_sel is not 0 will run
        inside_counter <= inside_counter + 1'b1;  
    // else
    //     inside_counter <= inside_counter;            ///
end   

// for FSM
always_comb
begin
    case (cs_fsm)
        INIT : ns_fsm = en ? Q1 : INIT; 
        Q1 : ns_fsm = Q2; 
        Q2 : ns_fsm = Q3; 
        Q3 : ns_fsm = Q4; 
        Q4 : ns_fsm = en ? Q1 : INIT;
        default : ns_fsm = INIT; 
    endcase
end


//comb logic for output
always_comb
begin
    if (cs_fsm == INIT)
        sin_out = 9'b0;
    else if (positive)              
        sin_out = {1'b0, dout};
    else //if (~positive)
        sin_out = {1'b1, ~dout} + 1'b1;   //two's complement negative number output
end

//FSM FF
always_ff @(posedge clk or negedge resetb) 
begin
    if (~resetb)
        cs_fsm <= INIT;
    else if ((cs_fsm == INIT) & en)
            cs_fsm <= ns_fsm;   
    else if (FINISH_COUNT == counter)
        cs_fsm <= ns_fsm;   
end

always_ff @(posedge clk or negedge resetb) 
begin
    if (~resetb)
        ff_period_sel <= 8'b0; // we assuming this is good implemantation
    else if (((cs_fsm == Q4) & (FINISH_COUNT == counter)) | (cs_fsm == INIT))  //this is when we need to save input period_sel
        ff_period_sel <= period_sel;   
end

endmodule 
