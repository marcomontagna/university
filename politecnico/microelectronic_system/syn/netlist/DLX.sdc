###################################################################

# Created by write_sdc on Wed Jul  4 22:13:18 2018

###################################################################
set sdc_version 1.7

set_wire_load_model -name 5K_hvratio_1_4 -library NangateOpenCellLibrary
create_clock [get_ports Clk]  -period 5  -waveform {0 2.5}
set_max_delay 5  -from [list [get_ports Clk] [get_ports Rst] [get_ports {dram_DOUT[31]}]       \
[get_ports {dram_DOUT[30]}] [get_ports {dram_DOUT[29]}] [get_ports             \
{dram_DOUT[28]}] [get_ports {dram_DOUT[27]}] [get_ports {dram_DOUT[26]}]       \
[get_ports {dram_DOUT[25]}] [get_ports {dram_DOUT[24]}] [get_ports             \
{dram_DOUT[23]}] [get_ports {dram_DOUT[22]}] [get_ports {dram_DOUT[21]}]       \
[get_ports {dram_DOUT[20]}] [get_ports {dram_DOUT[19]}] [get_ports             \
{dram_DOUT[18]}] [get_ports {dram_DOUT[17]}] [get_ports {dram_DOUT[16]}]       \
[get_ports {dram_DOUT[15]}] [get_ports {dram_DOUT[14]}] [get_ports             \
{dram_DOUT[13]}] [get_ports {dram_DOUT[12]}] [get_ports {dram_DOUT[11]}]       \
[get_ports {dram_DOUT[10]}] [get_ports {dram_DOUT[9]}] [get_ports              \
{dram_DOUT[8]}] [get_ports {dram_DOUT[7]}] [get_ports {dram_DOUT[6]}]          \
[get_ports {dram_DOUT[5]}] [get_ports {dram_DOUT[4]}] [get_ports               \
{dram_DOUT[3]}] [get_ports {dram_DOUT[2]}] [get_ports {dram_DOUT[1]}]          \
[get_ports {dram_DOUT[0]}] [get_ports {iram_Dout[31]}] [get_ports              \
{iram_Dout[30]}] [get_ports {iram_Dout[29]}] [get_ports {iram_Dout[28]}]       \
[get_ports {iram_Dout[27]}] [get_ports {iram_Dout[26]}] [get_ports             \
{iram_Dout[25]}] [get_ports {iram_Dout[24]}] [get_ports {iram_Dout[23]}]       \
[get_ports {iram_Dout[22]}] [get_ports {iram_Dout[21]}] [get_ports             \
{iram_Dout[20]}] [get_ports {iram_Dout[19]}] [get_ports {iram_Dout[18]}]       \
[get_ports {iram_Dout[17]}] [get_ports {iram_Dout[16]}] [get_ports             \
{iram_Dout[15]}] [get_ports {iram_Dout[14]}] [get_ports {iram_Dout[13]}]       \
[get_ports {iram_Dout[12]}] [get_ports {iram_Dout[11]}] [get_ports             \
{iram_Dout[10]}] [get_ports {iram_Dout[9]}] [get_ports {iram_Dout[8]}]         \
[get_ports {iram_Dout[7]}] [get_ports {iram_Dout[6]}] [get_ports               \
{iram_Dout[5]}] [get_ports {iram_Dout[4]}] [get_ports {iram_Dout[3]}]          \
[get_ports {iram_Dout[2]}] [get_ports {iram_Dout[1]}] [get_ports               \
{iram_Dout[0]}]]  -to [list [get_ports dram_RD] [get_ports dram_WR] [get_ports {dram_ADD[31]}]  \
[get_ports {dram_ADD[30]}] [get_ports {dram_ADD[29]}] [get_ports               \
{dram_ADD[28]}] [get_ports {dram_ADD[27]}] [get_ports {dram_ADD[26]}]          \
[get_ports {dram_ADD[25]}] [get_ports {dram_ADD[24]}] [get_ports               \
{dram_ADD[23]}] [get_ports {dram_ADD[22]}] [get_ports {dram_ADD[21]}]          \
[get_ports {dram_ADD[20]}] [get_ports {dram_ADD[19]}] [get_ports               \
{dram_ADD[18]}] [get_ports {dram_ADD[17]}] [get_ports {dram_ADD[16]}]          \
[get_ports {dram_ADD[15]}] [get_ports {dram_ADD[14]}] [get_ports               \
{dram_ADD[13]}] [get_ports {dram_ADD[12]}] [get_ports {dram_ADD[11]}]          \
[get_ports {dram_ADD[10]}] [get_ports {dram_ADD[9]}] [get_ports {dram_ADD[8]}] \
[get_ports {dram_ADD[7]}] [get_ports {dram_ADD[6]}] [get_ports {dram_ADD[5]}]  \
[get_ports {dram_ADD[4]}] [get_ports {dram_ADD[3]}] [get_ports {dram_ADD[2]}]  \
[get_ports {dram_ADD[1]}] [get_ports {dram_ADD[0]}] [get_ports {dram_DIN[31]}] \
[get_ports {dram_DIN[30]}] [get_ports {dram_DIN[29]}] [get_ports               \
{dram_DIN[28]}] [get_ports {dram_DIN[27]}] [get_ports {dram_DIN[26]}]          \
[get_ports {dram_DIN[25]}] [get_ports {dram_DIN[24]}] [get_ports               \
{dram_DIN[23]}] [get_ports {dram_DIN[22]}] [get_ports {dram_DIN[21]}]          \
[get_ports {dram_DIN[20]}] [get_ports {dram_DIN[19]}] [get_ports               \
{dram_DIN[18]}] [get_ports {dram_DIN[17]}] [get_ports {dram_DIN[16]}]          \
[get_ports {dram_DIN[15]}] [get_ports {dram_DIN[14]}] [get_ports               \
{dram_DIN[13]}] [get_ports {dram_DIN[12]}] [get_ports {dram_DIN[11]}]          \
[get_ports {dram_DIN[10]}] [get_ports {dram_DIN[9]}] [get_ports {dram_DIN[8]}] \
[get_ports {dram_DIN[7]}] [get_ports {dram_DIN[6]}] [get_ports {dram_DIN[5]}]  \
[get_ports {dram_DIN[4]}] [get_ports {dram_DIN[3]}] [get_ports {dram_DIN[2]}]  \
[get_ports {dram_DIN[1]}] [get_ports {dram_DIN[0]}] [get_ports                 \
{iram_Addr[31]}] [get_ports {iram_Addr[30]}] [get_ports {iram_Addr[29]}]       \
[get_ports {iram_Addr[28]}] [get_ports {iram_Addr[27]}] [get_ports             \
{iram_Addr[26]}] [get_ports {iram_Addr[25]}] [get_ports {iram_Addr[24]}]       \
[get_ports {iram_Addr[23]}] [get_ports {iram_Addr[22]}] [get_ports             \
{iram_Addr[21]}] [get_ports {iram_Addr[20]}] [get_ports {iram_Addr[19]}]       \
[get_ports {iram_Addr[18]}] [get_ports {iram_Addr[17]}] [get_ports             \
{iram_Addr[16]}] [get_ports {iram_Addr[15]}] [get_ports {iram_Addr[14]}]       \
[get_ports {iram_Addr[13]}] [get_ports {iram_Addr[12]}] [get_ports             \
{iram_Addr[11]}] [get_ports {iram_Addr[10]}] [get_ports {iram_Addr[9]}]        \
[get_ports {iram_Addr[8]}] [get_ports {iram_Addr[7]}] [get_ports               \
{iram_Addr[6]}] [get_ports {iram_Addr[5]}] [get_ports {iram_Addr[4]}]          \
[get_ports {iram_Addr[3]}] [get_ports {iram_Addr[2]}] [get_ports               \
{iram_Addr[1]}] [get_ports {iram_Addr[0]}]]
