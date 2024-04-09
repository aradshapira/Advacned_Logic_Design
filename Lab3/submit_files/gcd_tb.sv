/*
 * Authors: Arad Shapira, Tomer Hershku
 * Lab3 - ALD @ HUJI
 * Description: Implements the required gcd test bench module  
 */

`timescale 1ns/1ns
module gcd_tb();

logic resetb_tb;
logic clk_tb;
logic [7:0] u_tb;
logic [7:0] v_tb;
logic ld_tb; 
logic done_tb;
logic [7:0] res_tb; 

logic [7:0] u_tmp;
logic [7:0] v_tmp;

time start_time_check;   
//instatiation:
gcd DUT (
	.resetb(resetb_tb),
	.clk(clk_tb),
	.u(u_tb),
	.v(v_tb),
    .ld(ld_tb),
    .done(done_tb),
    .res(res_tb)
);

//randomize inputs
function void randomize_inputs(); 
    
    u_tb = $random();
    v_tb = $random();


endfunction 

//DRIVER
task automatic drive_inputs();
    
    @(posedge clk_tb)
        randomize_inputs();
        #1ns
        resetb_tb = 1'b1;
        ld_tb = 1'b1;
        #10ns;
        ld_tb = 1'b0;
        wait (done_tb);
        resetb_tb = 1'b0;

endtask //drive_inputs

initial
    begin
        {u_tb, v_tb, ld_tb, clk_tb, done_tb, res_tb, resetb_tb}=0;
        #5ns;
        repeat (100) 
            drive_inputs();
    end	



//generationg 100 Mhz clock
always
	begin
	#5ns;
	clk_tb = ~clk_tb ;
	end

//Checker
//calculate the exepted result
function logic [7:0] expected_res(input logic [7:0] u_tb, 
			     		  input logic [7:0] v_tb);
        u_tmp = u_tb;
        v_tmp = v_tb;
        while((u_tmp != 0) & (v_tmp != 0))
            begin
                if (u_tmp > v_tmp)
                    u_tmp = u_tmp % v_tmp;
                else // u_tmp <= v_tmp
                    v_tmp = v_tmp % u_tmp;
            end
            if (u_tmp == 0)
                expected_res = v_tmp;
            else // (tmp_v == 0)
                expected_res = u_tmp;
endfunction
//massege to display
	function void check_gcd(logic [7:0] u_tb, logic [7:0] v_tb, logic [7:0] res_tb);
		logic[7:0] software_expected_res;
		software_expected_res = expected_res(u_tb, v_tb);
		$display("u = %d v = %d result = %d", u_tb, v_tb, res_tb);
		if (software_expected_res != res_tb)
			$error("ERROR: expected result= %d", software_expected_res);

		


	endfunction //check_gcd

// Monitor
initial
	begin
		forever
			begin
				@(resetb_tb, clk_tb, u_tb, v_tb, ld_tb, done_tb, res_tb);
				#0;
				@(posedge done_tb) check_gcd(u_tb,v_tb,res_tb);
			end
	end
			
endmodule

