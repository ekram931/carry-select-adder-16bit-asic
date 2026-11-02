# 16-bit Carry Select Adder (CSLA) - ASIC Physical Design Flow

This repository contains the complete RTL-to-GDSII physical design flow for a **16-bit Carry Select Adder (CSLA)** implemented using **OpenROAD-flow-scripts (ORFS)** with the **Nangate45nm** open-source cell library.

## 📌 Project Overview
The Carry Select Adder (CSLA) is designed to compromise between the high speed of a Carry Lookahead Adder (CLA) and the area efficiency of a Ripple Carry Adder (RCA). 

- **Architecture:** 16-bit CSLA built using 4-bit CLA blocks and 2:1 Multiplexers for fast carry propagation.
- **Technology Node:** Nangate45nm Process Design Kit (PDK).
- **Target Area:** Defined explicit die area ($150 \times 150\,\mu\text{m}$) and core area ($140 \times 140\,\mu\text{m}$) to eliminate utilization conflicts and optimize floorplanning.
- **Physical Design Status:** Successfully generated DRC/LVS-clean GDSII layout.

---

## 🛠️ Toolchain & Environment
- **RTL Synthesis & Simulation:** Yosys, ModelSim / Questasim, Icarus Verilog
- **ASIC Flow Engine:** OpenROAD-flow-scripts (ORFS)
- **Place & Route (P&R):** OpenROAD
- **Layout Verification:** KLayout
- **Operating Environment:** RHEL / Ubuntu Linux on VMware Virtualization

---

## 📂 Repository Structure
