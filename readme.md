|   Folder                   |  Description  |
| :---                       |:---           |       
| src                        | Implementation of the hardware in VHDL |
| test                       | Test benches for the entitites created |
| reports                    | Reports: synthesis report, map report, place and route report, timing report |
| docs                       | Final report |


## Description

This is the final project for the subject "Hardware Acceleration using FPGAs", taken during the semester 2020/2. It refers to the implementation of a stopwatch using VHDL, targeting an FPGA board.

### Tasks
* The goal is to design a digital stopwatch with two input buttons and four 8-bit outputs, connected to 7-segment displays to show minutes and seconds. 
* The functionality has to be synchronized with a 20 MHz clock.
* The stopwatch design has to be described using two separate components. Where one should be a 7-segment decoder and the other should be the actual controller of the stopwatch.
* The design for the controller should be implemented using a FSM based on key presses. All the used registers should be set to an initial value when button rst is pressed.
* This task is finished when you have successfully demonstrated the completely integrated design (stopwatch, input and output hardware) in a simulation environment. To accomplish this, you have to write an appropriate testbench with expressive test cases.
* Synthesize the whole design and validate it on the given FPGA platform.