onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /trigger_generator/clock
add wave -noupdate /trigger_generator/load_pattern
add wave -noupdate /trigger_generator/rst_as_n
add wave -noupdate /trigger_generator/input
add wave -noupdate /trigger_generator/pattern
add wave -noupdate /trigger_generator/match_trigger
add wave -noupdate /trigger_generator/trigger_ack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1018896 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 290
configure wave -valuecolwidth 97
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1058930 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 20ns -dutycycle 50 -starttime 0ns -endtime 1000ns sim:/trigger_generator/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/trigger_generator/load_pattern 
wave create -driver freeze -pattern constant -value 1 -starttime 0ns -endtime 1000ns sim:/trigger_generator/rst_as_n 
wave create -driver freeze -pattern random -initialvalue 00000000 -period 100ns -random_type Uniform -seed 5 -range 7 0 -starttime 0ns -endtime 1000ns sim:/trigger_generator/input 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 11000100 -range 7 0 -starttime 0ns -endtime 1000ns sim:/trigger_generator/pattern 
WaveExpandAll -1
wave edit invert -start 0ps -end 37601ps Edit:/trigger_generator/rst_as_n 
wave edit invert -start 89654ps -end 109630ps Edit:/trigger_generator/load_pattern 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/trigger_generator/trigger_ack 
wave edit invert -start 569309ps -end 635926ps Edit:/trigger_generator/trigger_ack 
WaveCollapseAll -1
wave clipboard restore
