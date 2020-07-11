onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /clock_divider/DISABLE_DFF
add wave -noupdate /clock_divider/LOAD_COUNT_10
add wave -noupdate /clock_divider/DATA_OUT
add wave -noupdate /clock_divider/MASTER_ENABLE
add wave -noupdate /clock_divider/CNT3_OUT
add wave -noupdate /clock_divider/CNT_PRESCALER_OUT
add wave -noupdate /clock_divider/PRESCALER
add wave -noupdate /clock_divider/RESET
add wave -noupdate /clock_divider/CLOCK
add wave -noupdate /clock_divider/ENABLE
add wave -noupdate /clock_divider/DISABLE
add wave -noupdate /clock_divider/PRESCALER_IN
add wave -noupdate /clock_divider/TERMINAL_COUNT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {308240 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
configure wave -valuecolwidth 100
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
WaveRestoreZoom {97072 ps} {582448 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern constant -value 1 -starttime 0ms -endtime 1ms sim:/clock_divider/RESET 
wave create -driver freeze -pattern clock -initialvalue 0 -period 20ns -dutycycle 50 -starttime 0ms -endtime 1ms sim:/clock_divider/CLOCK 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1ns sim:/clock_divider/ENABLE 
wave create -driver freeze -pattern constant -value 0 -starttime 0ms -endtime 1ms sim:/clock_divider/DISABLE 
wave create -driver freeze -pattern constant -value 0000 -range 3 0 -starttime 0ms -endtime 1ms sim:/clock_divider/PRESCALER_IN 
wave create -driver freeze -pattern constant -value 1 -starttime 0ms -endtime 1ms sim:/clock_divider/RESET 
wave create -driver freeze -pattern clock -initialvalue 0 -period 20ns -dutycycle 50 -starttime 0ms -endtime 1ms sim:/clock_divider/CLOCK 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1ns sim:/clock_divider/ENABLE 
wave create -driver freeze -pattern constant -value 0 -starttime 0ms -endtime 1ms sim:/clock_divider/DISABLE 
wave create -driver freeze -pattern constant -value 0000 -range 3 0 -starttime 0ms -endtime 1ms sim:/clock_divider/PRESCALER_IN 
wave create -driver freeze -pattern constant -value 1 -starttime 0ms -endtime 1ms sim:/clock_divider/RESET 
wave create -driver freeze -pattern clock -initialvalue 0 -period 20ns -dutycycle 50 -starttime 0ms -endtime 1ms sim:/clock_divider/CLOCK 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1ns sim:/clock_divider/ENABLE 
wave create -driver freeze -pattern constant -value 0 -starttime 0ms -endtime 1ms sim:/clock_divider/DISABLE 
wave create -driver freeze -pattern constant -value 0000 -range 3 0 -starttime 0ms -endtime 1ms sim:/clock_divider/PRESCALER_IN 
WaveExpandAll -1
wave modify -driver freeze -pattern clock -initialvalue 0 -period 20ns -dutycycle 50 -starttime 0ms -endtime 1ms Edit:/clock_divider/CLOCK 
wave modify -driver freeze -pattern constant -value 0 -starttime 0ms -endtime 1ms Edit:/clock_divider/ENABLE 
wave edit invert -start 344ps -end 72686ps Edit:/clock_divider/RESET 
wave edit invert -start 106445ps -end 136760ps Edit:/clock_divider/ENABLE 
wave edit invert -start 308240ps -end 335798ps Edit:/clock_divider/DISABLE 
WaveCollapseAll -1
wave clipboard restore
