# DAY 005: Siemens SCL Structured Text Source Files (.scl)

Siemens SCL (Structured Control Language) is Siemens' implementation of IEC 61131-3 Structured Text,
used in both STEP 7 Classic and TIA Portal.  While SCL shares the same foundations as generic ST,
Siemens adds several proprietary extensions that make it identifiable:

## What makes SCL different from generic ST?

1. **Block declarations**: `ORGANIZATION_BLOCK`, `DATA_BLOCK` — these are Siemens-specific.
   Generic IEC 61131-3 has `FUNCTION_BLOCK` and `PROGRAM`, but not OBs or DBs.

2. **Pragmas**: Curly-brace pragmas like `{S7_Optimized_Access := 'TRUE'}` and
   `{InstructionName := 'CALL'}` are unique to the Siemens ecosystem.

3. **TITLE headers**: Siemens blocks begin with `TITLE = <description>` lines.

4. **BEGIN keyword**: Separates the variable declaration section from the code body.
   Generic ST doesn't use this — code follows directly after `END_VAR`.

5. **# prefix for temp variables**: In SCL, temporary variables are referenced with a
   `#` prefix (e.g., `#tempCounter`), which is not part of the IEC standard.

6. **NETWORK sections**: SCL code can be organized into numbered NETWORK blocks.

7. **REGION / END_REGION**: TIA Portal SCL supports code folding regions.

## Example SCL snippet

```
FUNCTION_BLOCK "Motor_Control"
{ S7_Optimized_Access := 'TRUE' }
TITLE = Motor Start/Stop Logic
VERSION : 0.1

VAR_INPUT
    Start : Bool;
    Stop  : Bool;
END_VAR

VAR
    #running : Bool;
END_VAR

BEGIN
    NETWORK
    IF #Start AND NOT #Stop THEN
        #running := TRUE;
    END_IF;
END_FUNCTION_BLOCK
```

## DFIR Relevance

SCL files are exported from engineering workstations running STEP 7 or TIA Portal.
Finding SCL source on a system can indicate:
- An engineer's workstation with PLC programming capability
- Exfiltrated PLC logic (if found outside expected locations)
- Backup or version-controlled PLC programs
- Evidence of PLC program modification during an incident

The Siemens-specific markers in this rule help distinguish SCL from generic ST files,
which is important when you need to identify the specific PLC ecosystem in use.

#### Next: DAY 006 — [Schneider Unity Pro .STU Project Files](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/006)
