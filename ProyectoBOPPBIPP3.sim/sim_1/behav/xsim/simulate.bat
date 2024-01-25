@echo off
REM ****************************************************************************
REM Vivado (TM) v2023.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Thu Jan 25 11:28:21 +0100 2024
REM SW Build 3865809 on Sun May  7 15:05:29 MDT 2023
REM
REM IP Build 3864474 on Sun May  7 20:36:21 MDT 2023
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim TB_CPU_CHIP_behav -key {Behavioral:sim_1:Functional:TB_CPU_CHIP} -tclbatch TB_CPU_CHIP.tcl -view C:/Users/gabri/Documents/Vivado Projects/ProyectoBOPPBIPP3/TB_CPU_CHIP_behav.wcfg -log simulate.log"
call xsim  TB_CPU_CHIP_behav -key {Behavioral:sim_1:Functional:TB_CPU_CHIP} -tclbatch TB_CPU_CHIP.tcl -view C:/Users/gabri/Documents/Vivado Projects/ProyectoBOPPBIPP3/TB_CPU_CHIP_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
