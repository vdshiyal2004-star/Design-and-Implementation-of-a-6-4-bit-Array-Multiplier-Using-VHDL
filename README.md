# 6x4-bit Array Multiplier in VHDL

This is a small digital design project where I built a 6-bit × 4-bit unsigned array multiplier using structural VHDL. Instead of using the `*` operator, I built it from scratch using half adders and full adders, arranged in the classic array (Braun) multiplier layout. The idea was to actually understand how multiplication happens at the gate level instead of just letting the synthesis tool handle it.

## Repo structure

```
array-multiplier-vhdl/
├── src/
│   ├── ha.vhd              # half adder
│   ├── fa.vhd               # full adder
│   └── bit_mul_46.vhd       # top-level 6x4 array multiplier
├── sim/
│   └── array_mul46_tb.vhd   # testbench
├── docs/
│   └── project-report.docx  # full write-up with theory, results, and power analysis
└── README.md
```

## Documentation

Full report with theory, VHDL walkthrough, simulation results, and synthesis/power analysis: [docs/project-report.docx](docs/project-report1.docx)

## How it works

The multiplier takes a 6-bit number `a` and a 4-bit number `b`, and outputs a 10-bit product `p`.

First stage generates all the partial products using simple AND gates (24 of them, since it's a 6x4 grid). After that, three rows of half adders and full adders reduce everything down to the final product bits. No clock, no reset — it's fully combinational, so the output just settles after some propagation delay.

## Tools used

- Xilinx Vivado 2025.1
- xsim (built into Vivado) for simulation
- Target FPGA: Spartan-7 (XC7A35TICPG236-1L)

## Testing

I ran 7 test vectors through the testbench, including the zero case and the max value case (63 x 15 = 945). All of them matched the expected output, no mismatches.

| a (dec) | b (dec) | Expected | Got | Result |
|---|---|---|---|---|
| 0 | 1 | 0 | 0 | PASS |
| 1 | 1 | 1 | 1 | PASS |
| 1 | 3 | 3 | 3 | PASS |
| 3 | 3 | 9 | 9 | PASS |
| 63 | 15 | 945 | 945 | PASS |
| 31 | 9 | 279 | 279 | PASS |
| 30 | 13 | 390 | 390 | PASS |

## Synthesis results

After synthesizing on the Spartan-7:

- 54 total cells
- 20 I/O ports
- 64 nets
- No flip-flops used (makes sense, it's combinational)
- No DSP48E1 or BRAM blocks used — everything's built from LUTs

Power estimate came out to about 6 W total, but most of that (around 5.5 W) is from I/O switching, not the actual logic. Vivado flagged this as "low confidence" since there's no real switching activity file — it's just assuming worst-case toggling on the inputs.

## Why I did it this way

I wanted to actually see the adder network instead of hiding it behind the `*` operator. Building it structurally also made it easier to look at the RTL and synthesized schematics afterward and confirm the tool was inferring exactly what I intended.

## Possible improvements

- Could extend this to signed operands using Booth's algorithm
- Wallace tree reduction would cut down the critical path since it doesn't wait row by row
- Adding a SAIF file for more realistic power numbers instead of Vivado's default estimate
