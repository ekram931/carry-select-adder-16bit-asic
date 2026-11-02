# 16-bit Carry Select Adder (CSLA) — Complete ASIC Physical Design Flow

This repository details the end-to-end **RTL-to-GDSII Physical Design Implementation** of a **16-bit Carry Select Adder (CSLA)** using **OpenROAD-flow-scripts (ORFS)** on the **Nangate45nm** open-source Process Design Kit (PDK).

---

## 📌 Project Overview & Architecture

Adders are core building blocks in arithmetic logic units (ALUs) and digital signal processing (DSP) architectures. The **Carry Select Adder (CSLA)** offers an optimal trade-off between the high speed of a Carry Lookahead Adder (CLA) and the small area footprint of a Ripple Carry Adder (RCA).

### **Key Architectural Features:**
- **Hierarchy:** 16-bit Top Module built by cascading 4-bit Carry Lookahead Adder (CLA) blocks.
- **Speculative Execution:** Parallel evaluation of sum outputs for both possible incoming carry states ($C_{in} = 0$ and $C_{in} = 1$).
- **Selection Logic:** 2:1 Multiplexers (`mux_2_to_1`) driven by the actual carry-out of the preceding stage to select the true sum and carry result.
- **Technology Node:** `Nangate45nm` Open-Source Cell Library.

---

## 📐 Physical & Floorplanning Specifications

To ensure proper layout density, routing feasibility, and to prevent Power Distribution Network (PDN) initialization failures (`PDN-0185`), explicit boundary constraints were defined in `config.mk` instead of relying on default utilization estimates.

| Parameter | Value / Constraint | Description |
| :--- | :--- | :--- |
| **Technology PDK** | `Nangate45nm` | Open-source standard cell library |
| **Die Boundary** | $150\,\mu\text{m} \times 150\,\mu\text{m}$ | Fixed total physical die size |
| **Core Boundary** | $140\,\mu\text{m} \times 140\,\mu\text{m}$ | Active region allocated for standard cell placement |
| **Utilization Strategy** | Explicit Boundaries | Avoids mutually exclusive `CORE_UTILIZATION` conflicts |
| **Verification Tool** | KLayout | Layout viewer for DRC/GDSII geometry inspection |

---

## 📂 Repository Structure
carry-select-adder-16bit-asic/
├── designs/
│   ├── src/
│   │   └── carry_select_adder_16bit/
│   │       ├── carry_select_adder_16bit.v   # Top-level 16-bit CSLA design module
│   │       ├── CLA_adder.v                  # Sub-module: 4-bit Carry Lookahead Adder
│   │       ├── mux_2_to_1.v                 # Sub-module: 2:1 Multiplexer
│   │       └── constraint.sdc               # Synopsys Design Constraints (SDC)
│   └── nangate45/
│       └── carry_select_adder_16bit/
│           └── config.mk                    # OpenROAD flow configuration Makefile
└── README.md                                # Detailed project documentation

---

## 🛠️ Toolchain & Development Environment

- **OS / Platform:** VMware Workstation running Linux (Ubuntu / RHEL)
- **RTL Logic Synthesizer:** Yosys (integrated into OpenROAD flow)
- **Place & Route (P&R) Engine:** OpenROAD
- **GDSII Layout Viewer:** KLayout
- **Verification & Simulation:** ModelSim / Questasim, Icarus Verilog, GTKWave
- **Version Control:** Git & GitHub

---

## 🔄 Detailed Physical Design Flow (RTL-to-GDSII)

The execution follow the automated step-by-step physical implementation script in OpenROAD:

1. **Logic Synthesis (`Yosys`):**
   - Elaboration of `carry_select_adder_16bit.v` and hierarchy resolution of `CLA_adder` and `mux_2_to_1`.
   - Technology mapping of RTL constructs to Nangate45nm gate-level standard cells.
2. **Floorplanning (`OpenROAD`):**
   - Initialization of fixed die area ($150\times 150\,\mu\text{m}$) and core boundaries ($140\times 140\,\mu\text{m}$).
   - Insertion of I/O pins along the core perimeter based on timing constraints.
3. **Power Distribution Network (PDN):**
   - Generation of horizontal and vertical power/ground grids (`VDD` / `VSS`) on higher-level metal layers.
4. **Placement:**
   - **Global Placement:** Spreads standard cells evenly across the core area minimizing total wirelength.
   - **Tap & Tie Cell Insertion:** Inserts WELLTAP cells to prevent latch-up conditions.
   - **Detailed Placement:** Legalizes cell positions onto the standard cell rows.
5. **Clock Tree Synthesis (CTS):**
   - Builds balanced clock networks with buffer trees to minimize clock skew and latency.
6. **Global & Detailed Routing:**
   - Performs global path allocation followed by detailed track routing avoiding DRC violations.
7. **GDSII Stream Generation:**
   - Merges cell layouts and exports the final, tapeout-ready `.gds` file.

---

## ⚙️ How to Reproduce & Run

To execute this project locally in your OpenROAD-flow-scripts environment:

1. **Clone this repository into your OpenROAD flow directory:**
   ```bash
   cd ~/OpenROAD-flow-scripts/flow
   git clone [https://github.com/ekram931/carry-select-adder-16bit-asic.git](https://github.com/ekram931/carry-select-adder-16bit-asic.git)
