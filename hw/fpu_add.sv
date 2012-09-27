module fpu_add( input         CLK,
                input         RESET,
                input         EN,
                input  [31:0] A,
                input  [31:0] B,
                output [31:0] Z );

//---------------Input stage-----------------//

wire        a_sign, b_sign;
wire  [7:0] a_exp, b_exp;
wire [22:0] a_sig_part, b_sig_part;

wire [31:0] abin = A; //simulation-only
wire [31:0] bbin = B; //simulation-only

ffd #(32) areg(CLK, RESET, EN, A, {a_sign, a_exp, a_sig_part});
ffd #(32) breg(CLK, RESET, EN, B, {b_sign, b_exp, b_sig_part});

wire [23:0] a_sig  = {1'b1, a_sig_part};               
wire [23:0] b_sig  = {1'b1, b_sig_part};               

//---------------Shifter stage---------------//

wire [8:0] exp_diff = a_exp - b_exp;
wire [8:0] exp_diff_sh;
wire [7:0] exp_used, exp_used_sh, exp_used_alu;
//A < B => if 1, use B, shift A; if 0 use A, shift B;
wire ae_or_be = exp_diff[8];

wire [23:0] to_concat, to_shifter;
wire [32:0] alu_a, alu_b, alu_a_sh, alu_b_sh;
wire [31:0] from_concat, from_shifter;
                 
mux2 #(24) plain_mux(ae_or_be, a_sig, b_sig, to_concat);
mux2 #(24) shift_mux(ae_or_be, b_sig, a_sig, to_shifter);

sig_concat the_concat(to_concat, from_concat);
sig_shifter the_shifter(exp_diff, to_shifter, from_shifter );

mux2 #(8) expt_mux(ae_or_be, a_exp, b_exp, exp_used);

negate negate_a(ae_or_be ? b_sign : a_sign, {1'b0, from_concat} , alu_a);
negate negate_b(ae_or_be ? a_sign : b_sign, {1'b0, from_shifter}, alu_b);

ffd #(74) sh_reg(CLK, RESET, 1'b1, { exp_used, // 8/ Expt to build the result
                                     alu_a,    //33/ Signed alu operand
                                     alu_b },  //33/ Signed alu operand
                                   { exp_used_sh,
                                     alu_a_sh,
                                     alu_b_sh } );
                        
//---------------ALU stage-------------------//
wire [32:0] aluout, aluout_abs;
wire [31:0] aluout_abs_alu;
wire        sign_alu;

adder sig_adder(alu_a_sh, alu_b_sh, aluout);
negate negate_y(aluout[32], aluout, aluout_abs);

wire sig_zero = (aluout_abs[31:0] == 32'd0);

ffd #(41) alu_reg(CLK, RESET, 1'b1, { exp_used_sh,        // 8/ Expt to build the result
                                      aluout[32],         // 1/ ALU result sign
                                      aluout_abs[31:0] }, //32/ ALU absolute result
                                    { exp_used_alu,
                                      sign_alu,
                                      aluout_abs_alu });
//------------1st Normalize stage------------//

//adequate normalize:
wire  [9:0] norm_exp, exp_norm;
wire [31:0] norm_sig, sig_norm;
wire        sign_norm;
normalize first_norm( exp_used_alu, aluout_abs_alu, norm_exp, norm_sig );

ffd #(43) norm_reg(CLK, RESET, 1'b1, { sign_alu,      // 1/ sign
                                       norm_exp,      //10/ expt
                                       norm_sig },    //32/ significand
                                     { sign_norm,
                                       exp_norm,
                                       sig_norm } );

//--------------Rounding stage---------------//
wire  [9:0] round_exp = exp_norm;
wire [24:0] round_sig;
round the_roundm( sig_norm, round_sig );

//------------2nd Normalize stage------------//

//simple addition-only normalize:
wire  [9:0] n2_exp = round_sig[24] ? ( round_exp + 1'b1) : round_exp;
wire [23:0] n2_sig = round_sig[24] ?   round_sig[24:1]   : round_sig[23:0]; 

//----------------Regout stage---------------//
wire [30:0] ret_val;         //result module
wire ret_sign = sign_norm;   //result sign

// sig_zero or n2_exp[9] => 0 (expt < 0; or significand == 0)
wire ret_zero = n2_exp[9] | sig_zero;

// n2_exp[9:8] == 2'b01 => inf (expt > +127)
wire ret_inf = (n2_exp[9:8] == 2'b01);

assign ret_val = ret_zero ? 31'd0          :
                  ret_inf ? {8'hFF, 23'h0} :
                            {n2_exp[7:0], n2_sig[22:0]};

ffd #(32) zreg(CLK, RESET, 1'b1, {ret_sign, ret_val}, Z);

endmodule





//===========================================//
module sig_shifter(  input   [8:0] EXP_DIFF,
                     input  [23:0] SIG_IN,
                     output [31:0] SIG_OUT );

wire [7:0] exp_abs = EXP_DIFF[8] ? (~EXP_DIFF[7:0] + 1'b1) : EXP_DIFF[7:0];
wire       over_31 = (exp_abs[7:5] != 0);

wire [4:0] shamt   = over_31 ? 5'b11111 : exp_abs[4:0];

assign SIG_OUT = {1'b0, SIG_IN, 7'd0} >> shamt;

endmodule
//===========================================//
module sig_concat(   input  [23:0] SIG_IN,
                     output [31:0] SIG_OUT );

assign SIG_OUT = {1'b0, SIG_IN, 7'd0};

endmodule
//===========================================//
module adder(  input  [32:0] A, 
               input  [32:0] B,
               output [32:0] Y );

assign Y = A + B;

endmodule
//===========================================//
module count_leading_zeros( input [30:0] IN,
                            output [4:0] OUT );

//Super-naive version
                            
logic [4:0] res;

always_comb
  casex(IN)
    31'b1XXXXXXX_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd0;
    31'b01XXXXXX_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd1;
    31'b001XXXXX_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd2;
    31'b0001XXXX_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd3;
    31'b00001XXX_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd4;
    31'b000001XX_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd5;
    31'b0000001X_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd6;
    31'b00000001_XXXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd7;
    31'b00000000_1XXXXXXX_XXXXXXXX_XXXXXXX: res = 5'd8;
    31'b00000000_01XXXXXX_XXXXXXXX_XXXXXXX: res = 5'd9;
    31'b00000000_001XXXXX_XXXXXXXX_XXXXXXX: res = 5'd10;
    31'b00000000_0001XXXX_XXXXXXXX_XXXXXXX: res = 5'd11;
    31'b00000000_00001XXX_XXXXXXXX_XXXXXXX: res = 5'd12;
    31'b00000000_000001XX_XXXXXXXX_XXXXXXX: res = 5'd13;
    31'b00000000_0000001X_XXXXXXXX_XXXXXXX: res = 5'd14;
    31'b00000000_00000001_XXXXXXXX_XXXXXXX: res = 5'd15;
    31'b00000000_00000000_1XXXXXXX_XXXXXXX: res = 5'd16;
    31'b00000000_00000000_01XXXXXX_XXXXXXX: res = 5'd17;
    31'b00000000_00000000_001XXXXX_XXXXXXX: res = 5'd18;
    31'b00000000_00000000_0001XXXX_XXXXXXX: res = 5'd19;
    31'b00000000_00000000_00001XXX_XXXXXXX: res = 5'd20;
    31'b00000000_00000000_000001XX_XXXXXXX: res = 5'd21;
    31'b00000000_00000000_0000001X_XXXXXXX: res = 5'd22;
    31'b00000000_00000000_00000001_XXXXXXX: res = 5'd23;
    31'b00000000_00000000_00000000_1XXXXXX: res = 5'd24;
    31'b00000000_00000000_00000000_01XXXXX: res = 5'd25;
    31'b00000000_00000000_00000000_001XXXX: res = 5'd26;
    31'b00000000_00000000_00000000_0001XXX: res = 5'd27;
    31'b00000000_00000000_00000000_00001XX: res = 5'd28;
    31'b00000000_00000000_00000000_000001X: res = 5'd29;
    31'b00000000_00000000_00000000_0000001: res = 5'd30;
    default:                                res = 5'd31;
  endcase

assign OUT = res;

endmodule
//===========================================//
module normalize( input   [7:0] E_IN,
                  input  [31:0] S_IN,
                  output  [9:0] E_OUT,
                  output [31:0] S_OUT );

logic [9:0] new_exp;
logic [30:0] new_sig;

wire [4:0] zeros;

count_leading_zeros cnt_lz(S_IN[30:0], zeros);

always_comb
  if(S_IN[31])
    begin
    new_exp = E_IN + 1'b1;
    new_sig = S_IN[31:1];
    end
  else 
    begin
    new_exp = E_IN - zeros;
    new_sig = S_IN[30:0] << zeros;
    end 

assign E_OUT = new_exp;
assign S_OUT = {1'b0, new_sig};

endmodule

//===========================================//
module negate(  input         EN,
                input  [32:0] IN,
                output [32:0] OUT );
                
assign OUT = EN ? ~IN + 1'b1 : IN;
                
endmodule
//===========================================//
module round( input  [31:0] S_IN,
              output [24:0] S_OUT );

wire [6:0] rndbits = S_IN[6:0];

logic [24:0] new_sig;

always_comb
  if(rndbits[6])
    begin
    if(rndbits[5:0] == '0)                      //in a halfway case
      begin
      if(S_IN[7]) new_sig = S_IN[31:7] + 1'b1;  //round to
      else        new_sig = S_IN[31:7];         //nearest even
      end
    else new_sig = S_IN[31:7] + 1'b1;           //round up
    end
  else new_sig = S_IN[31:7];                    //round down
              
assign S_OUT = new_sig;
endmodule
//===========================================//
