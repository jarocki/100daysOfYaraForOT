# DAY 013: Mitsubishi Electric MELSEC Structured Text

Mitsubishi Electric is one of the largest industrial automation manufacturers, producing
the **MELSEC** line of PLCs (Q series, L series, iQ-R series, FX series).  Their
engineering environments — **GX Works2**, **GX Works3**, and the legacy **GX Developer** —
support IEC 61131-3 Structured Text with Mitsubishi-specific extensions.

## MELSEC ST Extensions

### Special _M() Functions

The most distinctive feature of MELSEC Structured Text is a set of special functions
that end with `_M()`.  These provide direct access to PLC-specific operations:

| Function | Purpose |
|----------|---------|
| `SET_M()` | Set a bit device ON |
| `RST_M()` | Reset a bit device OFF |
| `OUT_M()` | Output to a bit device |
| `PLS_M()` | Rising edge pulse |
| `PLF_M()` | Falling edge pulse |
| `DELTA_M()` | Delta (difference) calculation |
| `STOP_M()` | Stop the PLC program |

These can be matched with the regex pattern: `/[A-Z_]{2,10}_M\s?\(/`

### Device Memory Addressing

MELSEC uses single-letter prefixes for device memory types:
- `D` — Data registers (e.g., `D100`, `D200`)
- `M` — Internal relays (e.g., `M0`, `M100`)
- `X` — Input contacts (e.g., `X0`, `X1`)
- `Y` — Output coils (e.g., `Y0`, `Y1`)
- `W` — Link registers
- `R` — File registers

This addressing scheme is unique to Mitsubishi and rarely appears in other vendors' ST.

## Example MELSEC ST

```
VAR
    speed : INT;
    running : BOOL;
END_VAR

speed := D100;
IF speed > 1000 THEN
    SET_M(Y0);
    running := TRUE;
ELSE
    RST_M(Y0);
    running := FALSE;
END_IF;
OUT_M(M100);
```

## Detection Strategy

The rule uses three detection paths:
1. **Multiple _M() functions** — 2+ named MELSEC functions is a strong signal
2. **_M() regex + device addressing** — the pattern plus Mitsubishi-style device refs
3. **Product identifier + any indicator** — "MELSEC", "GX Works", etc. with supporting evidence

## DFIR Relevance

- Mitsubishi PLCs are extremely common in **manufacturing**, especially in Asia-Pacific
- MELSEC controllers have been targeted by ICS malware (notably INCONTROLLER/PIPEDREAM)
- Finding MELSEC ST source outside engineering workstations warrants investigation
- The device addressing (D, M, X, Y registers) reveals the I/O configuration of the PLC

#### See Also
- DAY 004: [CODESYS ST Extensions](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/004) — another vendor-specific ST variant
- DAY 011: [Cross-vendor ST](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/011) — generic ST detection
