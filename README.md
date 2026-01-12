# AAD---Bit-field-extract-instruction

# VHDL Bit-Field Extract (BFE) Implementation
## Arquiteturas de Alto Desempenho 2025/2026 - Assignment 2

This repository contains the VHDL implementation of a combinational logic circuit for the **Bit-Field Extract (BFE)** instruction, developed for the High-Performance Architectures course at the University of Aveiro.

### 📋 Project Overview

The main goal is to design the architecture for a `bfe` instruction on a 16-bit processor. The instruction format is `bfe.[us] dst, src, size, start`.

**Functionality:**
It extracts a bit-field from a source register (`src`) starting at a specific bit position (`start`) with a specific length (`size`), and deposits it into a destination register (`dst`), either zero-extended (`.u`) or sign-extended (`.s`).

### 🛠 Architecture & Logic

The solution is implemented in `bfe.vhd` using a structural approach:
1.  **Barrel Shifter:** Utilizes `barrel_shift_right` to align the LSB of the desired bit-field to bit position 0.
2.  **Mask Generation:** Uses `comparator_n` instances to dynamically generate masks based on the `size` input, isolating the valid bits.
3.  **Output Logic:** Combines the shifted data with the generated masks and handles the sign extension logic based on the `variant` input bit.

### 🚀 Extra Features

This implementation includes the suggested extra credits:
* **Bit-Serial Comparator:** The `comparator_n.vhd` was optimized using a bit-serial architecture.
* **Advanced Missing Bits Rule:** Handles the edge case where `size + start > 15` effectively:
    * In `.u` mode: Missing bits are set to 0.
    * In `.s` mode: Missing bits follow the MSB of the `src` (simulating a signed right shift).

### 📂 File Structure

* `src/bfe.vhd`: Main entity/architecture for the bit-field extract logic.
* `src/comparator_n.vhd`: Unsigned comparator (optimized).
* `src/barrel_shift_right.vhd`: Provided barrel shifter entity.
* `tb/bfe_tb.c`: C code to generate the VHDL testbench.
* `makefile`: Build automation.

### ⚡ How to Run

Requirements: `GHDL` and `GTKWave`.

1.  **Generate Testbench:**
    ```bash
    gcc -o bfe_tb_gen bfe_tb.c
    ./bfe_tb_gen > bfe_tb.vhd
    ```
2.  **Compile and Simulate:**
    ```bash
    make
    ```
3.  **View Waveforms:**
    Open the generated `.vcd` file in GTKWave to analyze timing and signals.

### 👥 Authors
* [Your Name/Student ID]
* [Teammate Name/Student ID] (if applicable)

---
*University of Aveiro - DETI*
