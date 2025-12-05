# fpga Digital Phase Shifted Clock Generator (VHDL)

This project contains the VHDL designs developed for **LAB07** of the course  
**Electronics Programmable Systems (EPS)**.  
The objective is to design a synchronous digital circuit that generates:

- `CLK_L`  → a clock signal with frequency **CLK ÷ 16**  
- `CLK_SF` → a **phase-shifted version** of `CLK_L`, where the shift is programmable over **0–360°** using a 4-bit input `DIG_DELAY`

Both designs are written for synthesis on a  
**Xilinx Spartan-3 XC3S200 (VQ100, –4)** FPGA device.

---

## Repository Structure

```text
fpga-phase-shifted-clock/
├── README.md
├── docs/
│   └── EPS_LAB07_20220510.pdf
└── src/
    ├── EPS07a.vhd     -- Part A implementation
    └── LAB07B.vhd     -- Part B implementation
```

---

## Documentation

The full lab specification is included in:

```text
docs/EPS_LAB07_20220510.pdf
```

It describes the assignment requirements, input/output behavior, timing, and FPGA target device.

---

## Part A – EPS07a.vhd

### Functional Description

`EPS07a` implements:

- A **clock divider** generating `CLK_L = CLK ÷ 16` from the system clock `CLK`
- A **programmable phase shifter** generating `CLK_SF`
- A `LOAD` mechanism that latches a new delay value (`DIG_DELAY`)  
  and keeps the phase constant until the next load pulse

Typical ports (names may differ slightly depending on your version):

- `CLK` — system clock  
- `RESET` — reset input  
- `DIG_DELAY(3 downto 0)` — 4-bit phase shift control  
- `LOAD` — strobe to update delay  
- `CLK_L` — divided clock output  
- `CLK_SF` — phase-shifted clock output  

### Internal Architecture (Conceptual)

- A synchronous counter divides `CLK` by 16 to generate `CLK_L`.  
- A delay/offset register defines the phase shift of `CLK_SF` relative to `CLK_L`.  
- The delay register is updated only when `LOAD` is asserted, so the phase relationship stays constant between load events.  
- All logic is synchronous to `CLK`, fully synthesizable and suitable for static timing analysis.

---

## Part B – LAB07B.vhd

### Purpose

`LAB07B.vhd` implements the **same external behavior** as Part A but using a **different internal design approach**.

It is used to:

- Demonstrate an alternative synchronous architecture for the same problem  
- Compare resource usage (LUTs, FFs, etc.)  
- Compare maximum clock frequency and timing margins between two valid solutions  

### Entity Behavior

Part B:

- Generates `CLK_L = CLK ÷ 16`  
- Generates `CLK_SF` with the same frequency and programmable phase shift  
- Uses the same `DIG_DELAY` and `LOAD` interface to control phase shift  
- Keeps the phase fixed until the next `LOAD`

---

## Waveform Diagrams (Conceptual)

The following ASCII timing diagrams illustrate the expected behavior of the design.

### 1. Clock Division: `CLK` → `CLK_L = CLK ÷ 16`

```text
CLK     : ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ...
          │ │   │ │   │ │   │ │   │ │   │ │   │ │   │ │   │ │   │ │
        ──┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └────

CLK_L   : ┌─────────┐           ┌─────────┐
          │         │           │         │
        ──┘         └───────────┘         └───────────  (period = 16 × T_CLK)
```

`CLK_L` toggles every 8 cycles of `CLK`, giving a full period of 16 `CLK` cycles.

---

### 2. Phase Shift with `DIG_DELAY`

Assume:

- `DIG_DELAY = 0` → `CLK_SF` is in phase with `CLK_L`  
- `DIG_DELAY = 4` → `CLK_SF` lags `CLK_L` by 4 counts (90° for a 16‑step delay)  

```text
DIG_DELAY = "0000" (0)
LOAD      : ____┌─┐_______________________________________________
              ^  value "0000" is loaded here

CLK_L     :    ┌───────┐       ┌───────┐       ┌───────┐
               │       │       │       │       │       │
        _______┘       └_______┘       └_______┘       └____

CLK_SF   :     ┌───────┐       ┌───────┐       ┌───────┐
               │       │       │       │       │       │
        _______┘       └_______┘       └_______┘       └____
             (in phase with CLK_L when DIG_DELAY = 0)
```

Now with a non‑zero delay:

```text
DIG_DELAY = "0100" (4)
LOAD      : _____________┌─┐_______________________________________
                          ^  value "0100" is loaded here

CLK_L    :         ┌───────┐       ┌───────┐       ┌───────┐
                   │       │       │       │       │       │
        ___________┘       └_______┘       └_______┘       └____

CLK_SF   :             ┌───────┐       ┌───────┐       ┌───────┐
                       │       │       │       │       │       │
        _______________┘       └_______┘       └_______┘       └
              <---- 4 internal delay steps ---->
                       (phase shift relative to CLK_L)
```

After `LOAD` is asserted, `CLK_SF` transitions are shifted by a number of internal counter steps proportional to `DIG_DELAY`.  
The phase relationship remains constant until the next `LOAD` pulse.

---

## How to Use

1. Create a new FPGA project (Xilinx ISE/Vivado) targeting  
   **Spartan-3 XC3S200, VQ100, –4**.
2. Add into the project:
   - `src/EPS07a.vhd` for the Part A implementation, or  
   - `src/LAB07B.vhd` for the Part B implementation.
3. Set the top‑level entity accordingly (`EPS07a` or `LAB07B`, depending on your code).  
4. Create a VHDL testbench to drive:
   - `CLK` (system clock)
   - `RESET`
   - `DIG_DELAY`
   - `LOAD`
5. Run behavioral simulation:
   - Verify division by 16 on `CLK_L`
   - Verify phase shift of `CLK_SF` when `DIG_DELAY` and `LOAD` change
6. Run synthesis, implementation, and timing analysis:
   - Check maximum clock frequency
   - Compare area and timing between Part A and Part B

---

## Learning Outcomes

- Synchronous digital design in VHDL  
- Clock division and clock‑like signal generation  
- Programmable digital phase shifting using counters and delay logic  
- FPGA synthesis and timing analysis on a Spartan‑3 device  
- Comparison of different architectures implementing the same specification

---

## Author

**Hamed Nahvi**
