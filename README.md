# fifo_scd
A simple Single Clock Domain FIFO written in SystemVerilog

## Directories

* `rtl`: RTL source code. Written in SystemVerilog.
* `tb`: Testbenches.
  * `tb/cctb/`: [COCOTB](https://www.cocotb.org/) testbench.
    * `tb/cctb/src/`: Python modules for the testbench.
* `sim`: Simulation Makefiles and directories.
  * `sim/cctb`: [COCOTB](https://www.cocotb.org/) simulation directory.
 
## Simulating

### COCOTB
Pre-requisites : 
* Install [COCOTB](https://www.cocotb.org/).
Optional:
* Install [gtkwave](https://github.com/gtkwave/gtkwave#gtkwave).
```
cd sim/cctb && make
```
### Icarus Verilog
Pre-requisites : 
* Install [Icarus Verilog](https://github.com/steveicarus/iverilog?tab=readme-ov-file#the-icarus-verilog-compilation-system) simulator.
* Install [gtkwave](https://github.com/gtkwave/gtkwave#gtkwave).
```
cd sim/sv && make all gui
```
  

