# DAY 011: Cross-vendor IEC 61131-3 ST Module Fingerprinting

This rule takes a step back from vendor-specific detection to answer a broader question:
**"Is this file IEC 61131-3 Structured Text, regardless of which vendor's toolchain produced it?"**

## Why a generic rule?

The vendor-specific rules (DAY 001–010) are precise but narrow.  If you encounter ST source
from an unfamiliar vendor, or a vendor-neutral export, those rules won't fire.  This rule
catches the common thread: the IEC 61131-3 standard itself.

## Detection strategy: threshold + mandatory markers

A single keyword like `VAR` or `END_IF` could appear in many languages.  The strategy is:

1. **Mandatory markers**: The `:=` assignment operator (Wirth-family, not C-family) AND at
   least one `END_*` flow control keyword (separates from C/C++/C# which use `}`)
2. **POU presence**: At least one Program Organization Unit declaration (`FUNCTION_BLOCK`,
   `FUNCTION`, or `PROGRAM`) or its closing counterpart
3. **Variable declarations**: Both `VAR` and `END_VAR` must be present
4. **Threshold**: At least 4 of the `$kw_*` variable declaration keywords must match

This layered approach minimizes false positives on:
- **C/C++/C#**: No `:=` operator, no `END_IF`/`END_VAR` keywords
- **Pascal/Delphi**: Has `:=` but not `END_VAR`, `VAR_INPUT`, or `FUNCTION_BLOCK`
- **SQL**: Has `END IF` but not `:=` in the ST pattern, no `VAR`/`END_VAR` blocks

## Complementary use with vendor rules

The recommended hunting workflow is:

1. **Sweep**: Run this generic rule first to find ALL Structured Text files
2. **Classify**: Run vendor-specific rules (DAY 001–010) against hits to identify the ecosystem
3. **Investigate**: Any file that matches the generic rule but NOT a vendor rule may be from
   an unusual or custom IEC 61131-3 implementation — worth deeper analysis

## IEC 61131-3 data types as indicators

The rule also checks for IEC-specific data type declarations (`:  BOOL`, `: INT`, `: DINT`,
`: REAL`, `: WORD`, `: TIME`).  These type names with the colon-space-TYPE pattern are highly
characteristic of ST variable declarations and help distinguish from general-purpose languages.

#### See Also
- DAY 001: [Generic ST detection](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/001) — simpler rule, fewer conditions
- DAY 005: [Siemens SCL](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/005) — Siemens-specific markers
