//=============================================================//
module ffd #( parameter WIDTH = 32)
            ( input                  CLK, 
              input                  RESET,
              input                  EN,
              input      [WIDTH-1:0] D,
              output reg [WIDTH-1:0] Q );
                 
always_ff @(posedge CLK)
  if (RESET)  Q <= 0;
  else if(EN) Q <= D;

endmodule
//=============================================================//
module mux2 #(parameter WIDTH = 32)
             ( input             S,
               input [WIDTH-1:0] D0,
               input [WIDTH-1:0] D1,
               output[WIDTH-1:0] Y);

assign Y = S ? D1 : D0;

endmodule
//=============================================================//
module mux4 #(parameter WIDTH = 32)
             ( input [1:0] S,
               input [WIDTH-1:0] D0, D1, D2, D3,
               output[WIDTH-1:0] Y);

assign Y = S[1] ? (S[0] ? D3 : D2)
                : (S[0] ? D1 : D0);
                
endmodule
//=============================================================//
module mux8 #(parameter WIDTH = 32)
             ( input [2:0]       S,
               input [WIDTH-1:0] D0, D1, D2, D3, D4, D5, D6, D7,
               output[WIDTH-1:0] Y);

assign Y = S[2] ? (S[1] ? (S[0] ? D7 : D6) :
                          (S[0] ? D5 : D4)):
                  (S[1] ? (S[0] ? D3 : D2) :
                          (S[0] ? D1 : D0));

endmodule
//=============================================================//
module signext( input  [15:0] a,
                output [31:0] y );
                
assign y = {{16{a[15]}}, a};

endmodule
//===============================================//
module counter #(parameter SIZE = 8) (  input             CLK,
                                        input             RESET,
                                        input             EN,
                                        output [SIZE-1:0] OUT );

logic [SIZE-1:0] cnt;
                                        
always_ff@ (posedge CLK)
  if(RESET)
    cnt <= '0;
  else if(EN) cnt <= cnt + 1'b1;
    
assign OUT = cnt;
                                        
endmodule
//===============================================//
module shift_reg_lf #(parameter SIZE = 8) ( input             CLK,
                                            input             RESET,
                                            input             IN,
                                            input             EN,
                                            output [SIZE-1:0] OUT );

//LSB-first shift register

logic [SIZE-1:0] sreg;

always_ff@ (posedge CLK)
  if(RESET)   sreg <= '0;
  else if(EN) sreg <= {IN, sreg[SIZE-1:1]}; 

assign OUT = sreg;
endmodule
//===============================================//