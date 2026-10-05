# VeriRisc CPU (SystemVerilog)

A small 8-bit accumulator-based CPU implemented in SystemVerilog. The design follows the VeriRisc CPU used in the Cadence SystemVerilog training labs. Its 32-byte memory holds both instructions and data, and a multi-cycle controller sequences instruction fetch, decode, execution, and memory access.

## Features

- 8-bit accumulator and data path
- 5-bit program counter and memory address, supporting 32 byte-wide locations
- Three-bit opcode and five-bit operand instruction format
- Multi-state control sequencer and synchronous memory
- Testbench with two instruction-set diagnostics and a Fibonacci program

## Instruction Set

Each instruction is one byte: the upper three bits select the operation and the lower five bits hold an address operand where applicable.

| Opcode | Mnemonic | Operation |
| --- | --- | --- |
| `000` | `HLT` | Halt execution |
| `001` | `SKZ` | Skip the next instruction when the accumulator is zero |
| `010` | `ADD` | Add the addressed byte to the accumulator |
| `011` | `AND` | Bitwise AND the addressed byte with the accumulator |
| `100` | `XOR` | Bitwise XOR the addressed byte with the accumulator |
| `101` | `LDA` | Load the addressed byte into the accumulator |
| `110` | `STO` | Store the accumulator at the addressed memory location |
| `111` | `JMP` | Jump to the addressed memory location |

Arithmetic results are 8 bits wide. The `SKZ` condition is based on whether the accumulator is zero.

## Repository Contents

| File | Description |
| --- | --- |
| `cpu.sv` | Top-level CPU wiring for datapath, memory, program counter, and controller |
| `control.sv` | Finite-state control sequencer and control-signal generation |
| `alu.sv` | Accumulator arithmetic and logic operations |
| `mem.sv` | 32 x 8 synchronous memory |
| `counter.sv` | Loadable, incrementable program counter |
| `register.sv` | Enabled register used for the accumulator and instruction register |
| `scale_mux.sv` | Address selection between program counter and instruction operand |
| `typedefs.sv` | Opcode and controller-state enumerations |
| `cpu_test.sv` | Clock generation, program loading, execution trace, and pass/fail checks |
| `CPUtest1.dat` | Basic CPU diagnostic; expected halt PC: `0x17` |
| `CPUtest2.dat` | Advanced instruction diagnostic; expected halt PC: `0x10` |
| `CPUtest3.dat` | Fibonacci program; expected halt PC: `0x0C` |

## Simulating with Cadence Xcelium

From the repository directory, compile and run the testbench with Xcelium (`xrun`):

```sh
xrun -sv -top cpu_test typedefs.sv alu.sv control.sv counter.sv cpu.sv mem.sv register.sv scale_mux.sv cpu_test.sv
```

Keep the `.dat` files in the working directory because the testbench loads them by relative filename. A successful run prints an instruction trace and a `CPU TEST 2 PASSED` message.

## Selecting a Test

The testbench currently assigns `test_number = 2` in `cpu_test.sv`. Change that assignment to `1`, `2`, or `3` to select the basic diagnostic, advanced diagnostic, or Fibonacci program, respectively. The testbench checks the expected halt PC shown above.

The testbench is wrapped in a `forever` loop and does not call `$finish` after a passing test, so the selected test starts again after reporting PASS. Stop the simulation after the pass message (for example, with Ctrl+C in the simulator terminal).