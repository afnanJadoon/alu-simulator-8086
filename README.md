# ALU Simulator — 8086 Assembly Language

![Language](https://img.shields.io/badge/Language-8086%20Assembly-blue)
![Platform](https://img.shields.io/badge/Platform-DOSBox%20%7C%20emu8086-lightgrey)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Course](https://img.shields.io/badge/Course-Computer%20Organization%20%26%20Assembly%20Language-orange)

> A fully functional **Arithmetic Logic Unit (ALU) Simulator** written in 8086 Assembly Language.
> Simulates core CPU operations with real-time CPU flag display on a color text UI.

---

## Made By

**AHA** — Computer Organization & Assembly Language Project

---

## Supported Operations

| Key | Operation | Expression     | Operands |
|-----|-----------|----------------|----------|
| `1` | ADD       | AX + BX        | Two      |
| `2` | SUB       | AX - BX        | Two      |
| `3` | MUL       | AX × BX        | Two      |
| `4` | DIV       | AX ÷ BX        | Two      |
| `5` | AND       | AX & BX        | Two      |
| `6` | OR        | AX \| BX       | Two      |
| `7` | XOR       | AX ^ BX        | Two      |
| `8` | NOT       | ~AX            | One      |
| `9` | SHL       | AX << 1        | One      |
| `A` | SHR       | AX >> 1        | One      |
| `0` | EXIT      | Quit simulator | —        |

---

## CPU Flags Displayed

After every operation, the simulator extracts and displays these flags directly from the FLAGS register:

| Flag | Bit | Meaning                          |
|------|-----|----------------------------------|
| ZF   | 6   | Zero Flag — result is zero       |
| CF   | 0   | Carry Flag — unsigned overflow   |
| SF   | 7   | Sign Flag — result is negative   |
| OF   | 11  | Overflow Flag — signed overflow  |
| PF   | 2   | Parity Flag — even number of 1s  |

---

## Features

- Color-coded text UI (BIOS INT 10h) with blue background
- Menu-driven interface — no typing commands
- Real decimal input with backspace support
- Division by zero error handling
- Flags extracted via `pushf` / bit shifting
- Cursor show/hide control
- Single and dual operand support

---

## Project Files

```
alu-simulator-8086/
│
├── alu_simulator.asm       # Main source file (8086 Assembly)
├── README.md               # Project documentation
└── screenshots/
    └── ui_preview.png      # Screenshot of running simulator
```

---

## How to Run

### Using emu8086 (recommended)
1. Download and install [emu8086](https://emu8086-microprocessor-emulator.en.softonic.com/)
2. Open `alu_simulator.asm`
3. Click **Compile** then **Run**

### Using DOSBox + MASM/TASM
```bash
# Assemble
masm alu_simulator.asm;

# Link
link alu_simulator.obj;

# Run in DOSBox
alu_simulator.exe
```

---

## UI Preview

```
²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
        ALU SIMULATOR - 8086 ASSEMBLY
    Computer Organization & Assembly Language
                  Made by AHA
²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

  Choose Operation:
  [1] ADD    [2] SUB    [3] MUL    [4] DIV
  [5] AND    [6] OR     [7] XOR    [8] NOT
  [9] SHL    [A] SHR    [0] EXIT
```

---

## Technical Details

- **Architecture:** x86 (8086), `.model small`
- **Assembler:** MASM / TASM compatible
- **BIOS Interrupts used:** `INT 10h` (video), `INT 21h` (I/O)
- **Stack size:** 200h
- **Segments:** `.data`, `.code`, `.stack`

---

## License

MIT License — free to use for educational and reference purposes.