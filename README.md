# EPS Lab 07 – Digital Phase-Shifted Clock Generator (VHDL)

This project contains the VHDL designs developed for **LAB07** of the course  
**Electronics Programmable Systems (EPS)**. The lab focuses on generating a **clock divided by 16** and a **phase‑shifted version** of this clock using fully synchronous digital logic suitable for FPGA implementation.

The design is intended for synthesis on a **Xilinx Spartan‑3 XC3S200 (VQ100, –4)** device.

---

## Lab Objective

Design a synchronous digital circuit that, given a system clock `CLK`:

- Generates a slower clock `CLK_L` whose frequency is **`CLK / 16`**.  
- Generates a second output `CLK_SF` with:
  - The **same frequency** as `CLK_L`
  - A **programmable phase shift** in the range **0–360°**, controlled by a 4‑bit digital delay input `DIG_DELAY`
- Updates the phase relationship **only when a load signal is asserted**, keeping the phase difference fixed until the next load.

The repository contains two main VHDL source files corresponding to **part A** and **part B** of the lab.

---

## Repository Structure

```text
eps-lab07-phase-shifted-clock/
├── README.md
└── src/
    ├── EPS07a.vhd    -- Part A: base implementation
    └── LAB07B.vhd    -- Part B: extended/refined implementation
```

- `EPS07a.vhd` – first implementation of the LAB07.A entity (clock divider + programmable phase shift).  
- `LAB07B.vhd` – second implementation used for LAB07.B, which refines and extends the behavior specified in the lab sheet using an alternative internal structure.

---

## Part A – EPS07a.vhd (LAB07.A)

### Functional Description

`EPS07a` implements:

- A **÷16 clock divider** to obtain `CLK_L` from the system clock `CLK`  
- A **phase‑shift generator** that produces `CLK_SF`, a copy of `CLK_L` shifted in phase according to the value on `DIG_DELAY`  
- A **load mechanism** that latches a new delay value only when a `LOAD` signal is asserted

Typical ports (names may vary slightly depending on the exact file):

- `CLK`        – input system clock  
- `RESET`      – reset input  
- `DIG_DELAY`  – 4‑bit digital delay control  
- `LOAD`       – strobe to latch the new delay  
- `CLK_L`      – divided clock output (`CLK / 16`)  
- `CLK_SF`     – phase‑shifted clock output

### Internal Architecture (Conceptual)

- A counter implements division by 16 to generate `CLK_L`.  
- A digital delay line / counter offset, controlled by `DIG_DELAY`, determines when `CLK_SF` toggles relative to `CLK_L`.  
- The delay configuration is stored in a register updated on `LOAD`, ensuring that the phase shift remains constant until the next load event.

All logic is synchronous to `CLK`, making the design suitable for FPGA synthesis and timing analysis.

---

## Part B – LAB07B.vhd (LAB07.B)

### Purpose

`LAB07B.vhd` contains the **second implementation** for the same functional specification, as requested in part **B** of the lab:

- It still generates `CLK_L` and `CLK_SF` with the same frequency and programmable phase shift.  
- It uses a **different internal structure** (for example, a different way of handling counters, phase accumulation, or state machine) to achieve the same behavior.

This second version is useful for:

- Comparing resource usage (LUTs, FFs, etc.)  
- Comparing maximum achievable clock frequency  
- Evaluating different design trade‑offs while satisfying the same specification.

### Entity Overview

The entity typically includes:

- `CLK`        – input system clock  
- `RESET`      – reset input  
- `DIG_DELAY`  – 4‑bit digital delay control  
- `LOAD`       – strobe to latch the new delay  
- `CLK_L`      – divided clock output  
- `CLK_SF`     – phase‑shifted clock output

The architecture in `LAB07B.vhd` reorganizes the internal signals and counters but preserves the required external behavior.

---

## Usage

1. Create a new FPGA project (ISE/Vivado) targeting **Spartan‑3 XC3S200, VQ100, –4**.  
2. Add the desired source file(s) from the `src/` folder:
   - `EPS07a.vhd` for the LAB07.A version  
   - `LAB07B.vhd` for the LAB07.B version  
3. Set the top module accordingly (either `EPS07a` or `EPS07B`, depending on the entity name used in the file).  
4. Optionally create a VHDL testbench to drive:
   - `CLK` (system clock)  
   - `RESET`  
   - `DIG_DELAY` (various delay values)  
   - `LOAD` pulses  
5. Run behavioral simulation to verify:
   - Correct division by 16 for `CLK_L`  
   - Correct phase shift behavior for `CLK_SF`  
6. Run synthesis, implementation, and timing analysis to obtain:
   - Maximum operating frequency  
   - Resource usage for each version (A and B)

---

## Notes

- Both designs are written in synthesizable VHDL.  
- All logic is synchronous to the main clock `CLK`.  
- The phase‑shift resolution and range are determined by the 4‑bit `DIG_DELAY` input, which covers the full 0–360° range for the period of `CLK_L`.

---

## Author

- **Hamed Nahvi**
