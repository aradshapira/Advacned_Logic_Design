`timescale 1ns/1ns  //enough for resolution
module sin_gen_tb();
//inputs & outputs declarations
logic resetb_tb;
logic clk_tb;
logic [7:0] period_sel_tb;
logic en_tb; 
logic [8:0] sin_out_tb; 

// DUT (Device Under Test)
//instatiation:
sin_gen DUT (
	.resetb(resetb_tb),
	.clk(clk_tb),
	.period_sel(period_sel_tb),
	.en(en_tb),
    .sin_out(sin_out_tb)
);

//generationg 512 Mhz clock
// actually (1/512 Mhz) = ~1.95 , we chose 2 ns period time to make things simplier
always
	begin
	#1ns;
	clk_tb = ~clk_tb ;
	end

// Monitor
initial
	begin
            //reseting inputs
            resetb_tb =1'b0;
            clk_tb = 1'b0;
            period_sel_tb =  8'b0000_0000;
            en_tb = 1'b0;
            #4ns;

            resetb_tb = 1'b0;
            #4ns
            //first sinus - max frequency
            resetb_tb = 1'b1;
            en_tb = 1'b1 ;
            period_sel_tb = 8'b0000_0000;
            #4ns

            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0000;
            #1063ns

            //order to 2nd sinus , X2 slower than max , do not change until we finsh the first
            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0001;
            en_tb = 1'b1 ;         
            #1000ns
            
            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0001;
            en_tb = 1'b1 ;         
            #110ns

            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0001;
            en_tb = 1'b0 ;         
            #4350ns




            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0010;
            en_tb = 1'b1 ;         
            #4ns
            //3rd sinus X3 slower than max
            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0010;
            en_tb = 1'b0 ;         
            #4000ns

            //adding en pulse during sinus drawing doesn't stop current sinus - as expected

            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0010;
            en_tb = 1'b1 ;         
            #4ns

            resetb_tb = 1'b1;
            period_sel_tb = 8'b0000_0010;
            en_tb = 1'b0 ;         
            #2200ns;
       
	end
			
endmodule
