# Synchronous Automotive Signaling Controller (VHDL & FPGA)

## Overview
A digital control system designed in VHDL to simulate complex automotive signaling patterns. The system was synthesized for a **Xilinx Artix-7 FPGA** and deployed on a **Basys 3 board** to demonstrate real-time hardware-software synchronization.

## System Architecture
* **13-State FSM:** A robust Finite State Machine (FSM) managing sequential logic for turn signals, hazards, and brake light priorities.
* **Frequency Divider:** Downsamples the internal **100 MHz clock** to a **4 Hz signal** (0.25s) for realistic visual timing.
* **I/O Mapping:** Custom constraint mapping (.xdc) for 16-bit LED outputs and physical switch inputs in **Vivado 2024.1**.

## Performance Summary
| Metric | Specification | Result |
| :--- | :--- | :--- |
| **Clock Frequency** | 100 MHz Input | Synthesized Successfully |
| **Output Rate** | 4 Hz Signaling | Validated Real-time |
| **State Count** | 13-State FSM | Zero-Error Logic Flow |

## Technical Skills Demonstrated
* **VHDL Design:** RTL coding, structural modeling, and FSM synthesis.
* **FPGA Tools:** Xilinx Vivado 2024.1, Bitstream generation, and hardware debugging.
* **Logic Analysis:** Verifying timing constraints and signal synchronization.
