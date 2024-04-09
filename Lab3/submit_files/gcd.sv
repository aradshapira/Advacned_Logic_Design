/*
 * Authors: Arad Shapira, Tomer Hershku
 * Lab3 - ALD @ HUJI
 * Description: Implements the required gcd module  
 */

module gcd (
			input logic resetb,
			input logic clk,
			input logic [7:0] u,
			input logic [7:0] v,
			input logic ld, //1 cycle pulse, refer to a new u & v
			output logic done,
			output logic [7:0] res // during calculation res=0 
);

parameter logic [2:0] EQUAL = 3'b001;
parameter logic [2:0] BOTH_SHIFT = 3'b010;
parameter logic [2:0] U_SHIFT = 3'b011;
parameter logic [2:0] V_SHIFT = 3'b100;
parameter logic [2:0] U_BIGGER = 3'b101;
parameter logic [2:0] V_BIGGER = 3'b110;

//signals declaration
logic [7:0] ff_u;
logic [7:0] ff_v;
logic [3:0] counter;
logic u_check_even, v_check_even;
logic [2:0] op;

// check even numbers
assign u_check_even = ~ff_u[0];
assign v_check_even = ~ff_v[0]; 

// Counter the number of times u and v were divided by 2
always @(posedge clk or negedge resetb) begin
    if (~resetb)
        counter <= 4'b0;
    else if (ld)
        counter <= 4'b0;        
    else if ((~done) & (op == BOTH_SHIFT))
        counter <= counter + 1'b1;
end 

// choose Which action to choose
always_comb
begin
    if (ff_u == ff_v)begin
        op = EQUAL;
        end
    else if (u_check_even & v_check_even) begin
        op = BOTH_SHIFT;
    end
    else if (u_check_even) begin
        op = U_SHIFT;
    end
    else if (v_check_even) begin
        op = V_SHIFT;
    end
    else if (ff_u>ff_v) begin
        op = U_BIGGER;
    end
    else  begin //if (ff_v>ff_u)
        op = V_BIGGER;
    end
end


assign res =  done ? (ff_u << counter) : 8'b0;

// if done is in the always_ff done will appear only in the next sacle
// because there is an <= that change him only 1 sacle after 
// the solution for that is to go with the assign:
// assign done = (op == EQUAL) & (~(ff_v == 8'b0)); and some more little changes
// We didn't write with the assign because it is more readable as a code to write done & EQUAL in the always_ff 

// do the GCD action 
always_ff @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        ff_u <= 8'b0;
        ff_v <= 8'b0;
        done <= 1'b0;
    end else if (ld) begin
        ff_u <= u;
        ff_v <= v;
        done <= 1'b0;
        end
        else begin
                case (op)
                    EQUAL:  done <= 1'b1;
                    BOTH_SHIFT: begin
                                    ff_u <= ff_u >> 1;
                                    ff_v <= ff_v >> 1;
                                end
                    U_SHIFT : ff_u <= ff_u >> 1;
                    V_SHIFT : ff_v <= ff_v >> 1;
                    U_BIGGER : ff_u <= ff_u - ff_v;
                    V_BIGGER :ff_v <= ff_v - ff_u;
                    default : ff_v <= ff_v - ff_u;
                endcase
        end
end

endmodule 
