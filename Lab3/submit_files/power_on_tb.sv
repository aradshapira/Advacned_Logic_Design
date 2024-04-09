/*
 * Authors: Arad Shapira, Tomer Hershku
 * Lab3 - ALD @ HUJI
 * Description: Implements the required power_on_tb module  
 */

`timescale 1ns/1ns
module power_on_tb();

logic resetb_tb;         //rst
logic clk_tb;            //clock
logic power_good_tb;     //Power good indication
logic enable_tb;         //Enable signal ,The enable should be asserted 300ns (=30 clock cycles at 100Mhz freq.) after 
                                //power_good signal is asserted and stable

time start_time_check;    //in order to save current time
// DUT (Device Under Test)
//instatiation:
power_on DUT (
	.resetb(resetb_tb),
	.clk(clk_tb),
	.power_good(power_good_tb),
	.enable(enable_tb)
);

function void time_delay_printing( time start_time , time end_time);

	$display("time delay between power_good and enable is %t", end_time - start_time);   //printing delay from 
																						//current time to relevant time 
endfunction

//here all the signals are given logic values
initial 
	begin
	clk_tb  = 1'b0;
	resetb_tb  = 1'b0;
	power_good_tb = 1'b0;
	#3ns;
	resetb_tb =1'b1;
	power_good_tb =  1'b1;
	#399ns;
	power_good_tb  = 1'b0;
	#10ns;
	power_good_tb  = 1'b1;
	#350ns;

	end
//generationg 100 Mhz clock
always
	begin
	#5ns;
	clk_tb = ~clk_tb ;
	end


//2 always blocks in order to check if enable is raised at the required time
always @(posedge power_good_tb)
	begin
		start_time_check = $time ; 
	end

always @(posedge enable_tb)
	begin
	time_delay_printing(start_time_check , $time);
	end


//Checker
initial forever
	begin
		@(posedge power_good_tb)
		fork : checker_fork_join
			//catching falsly raised enable
			begin
			@(posedge enable_tb) $error("enable is set earlier to reaching 300 ns");
			end

			//check if power_good was put down before 300 ns
			begin
			@(negedge power_good_tb); 
			end

			//check if 300 ns were passed
			begin
			#300ns   ;
			end

		join_any
		disable checker_fork_join ;
	end


endmodule







