onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_add_tb/CLK
add wave -noupdate /fpu_add_tb/RESET
add wave -noupdate /fpu_add_tb/EN
add wave -noupdate -divider IN
add wave -noupdate -radix hexadecimal /fpu_add_tb/A
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/abin
add wave -noupdate -radix hexadecimal /fpu_add_tb/B
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/bbin
add wave -noupdate -divider A
add wave -noupdate /fpu_add_tb/uut/a_sign
add wave -noupdate -radix unsigned /fpu_add_tb/uut/a_exp
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/a_sig
add wave -noupdate -divider B
add wave -noupdate /fpu_add_tb/uut/b_sign
add wave -noupdate -radix unsigned /fpu_add_tb/uut/b_exp
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/b_sig
add wave -noupdate -divider Expdiff
add wave -noupdate -radix decimal /fpu_add_tb/uut/exp_diff
add wave -noupdate /fpu_add_tb/uut/ae_or_be
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/to_shifter
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/to_concat
add wave -noupdate -divider Eshift
add wave -noupdate /fpu_add_tb/uut/the_shifter/EXP_DIFF
add wave -noupdate -radix binary /fpu_add_tb/uut/the_shifter/SIG_IN
add wave -noupdate /fpu_add_tb/uut/the_shifter/over_31
add wave -noupdate -radix unsigned /fpu_add_tb/uut/the_shifter/exp_abs
add wave -noupdate -radix binary /fpu_add_tb/uut/the_shifter/SIG_OUT
add wave -noupdate -divider ALU
add wave -noupdate -label negA /fpu_add_tb/uut/negate_a/EN
add wave -noupdate -label negB /fpu_add_tb/uut/negate_b/EN
add wave -noupdate -label negY /fpu_add_tb/uut/negate_y/EN
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/alu_a
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/alu_b
add wave -noupdate -radix hexadecimal -childformat {{{/fpu_add_tb/uut/aluout[32]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[31]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[30]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[29]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[28]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[27]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[26]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[25]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[24]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[23]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[22]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[21]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[20]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[19]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[18]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[17]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[16]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[15]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[14]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[13]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[12]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[11]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[10]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[9]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[8]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[7]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[6]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[5]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[4]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[3]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[2]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[1]} -radix hexadecimal} {{/fpu_add_tb/uut/aluout[0]} -radix hexadecimal}} -subitemconfig {{/fpu_add_tb/uut/aluout[32]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[31]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[30]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[29]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[28]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[27]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[26]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[25]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[24]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[23]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[22]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[21]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[20]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[19]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[18]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[17]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[16]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[15]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[14]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[13]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[12]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[11]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[10]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[9]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[8]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[7]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[6]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[5]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[4]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[3]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[2]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[1]} {-height 18 -radix hexadecimal} {/fpu_add_tb/uut/aluout[0]} {-height 18 -radix hexadecimal}} /fpu_add_tb/uut/aluout
add wave -noupdate -divider Normalize1
add wave -noupdate -radix unsigned /fpu_add_tb/uut/norm_exp
add wave -noupdate /fpu_add_tb/uut/norm_sig
add wave -noupdate -divider Round
add wave -noupdate -radix unsigned /fpu_add_tb/uut/round_exp
add wave -noupdate -radix binary /fpu_add_tb/uut/round_sig
add wave -noupdate -divider Normalize2
add wave -noupdate -radix unsigned /fpu_add_tb/uut/n2_exp
add wave -noupdate -radix binary /fpu_add_tb/uut/n2_sig
add wave -noupdate -divider OUT
add wave -noupdate -radix hexadecimal /fpu_add_tb/uut/Z
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4541 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {19069 ps}
