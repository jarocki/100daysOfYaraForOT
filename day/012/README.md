# DAY 012: Emerson PAC Machine Edition (formerly GE Proficy) Structured Text

GE Proficy Machine Edition was one of the most popular PLC programming environments in
the North American market.  In 2018, Emerson Electric acquired GE's Intelligent Platforms
division and rebranded the product as **Emerson PAC Machine Edition**.

## What makes Machine Edition ST unique?

### Apostrophe Comments

The most distinctive feature is the use of **apostrophe (`'`) for inline comments**,
instead of the IEC 61131-3 standard `(* *)` comment syntax:

```
'-------------------
'    Created: 2024-01-15
'    Author: J. Smith
'    Description: Motor control logic
'-------------------
VAR
    Motor_Speed : INT;
    Running     : BOOL;
END_VAR

Motor_Speed := 1500;   ' Set nominal speed
IF Motor_Speed > 0 THEN
    Running := TRUE;    ' Motor is active
END_IF;
```

This apostrophe comment style is inherited from GE's legacy programming conventions
and is unique among IEC 61131-3 implementations.

## PACSystems Hardware

Machine Edition programs target Emerson/GE PACSystems controllers:
- **RX3i** — the workhorse mid-range controller
- **RX7i** — high-performance controller for demanding applications
- **VersaMax** — compact/micro PLCs

## Detection Strategy

The rule uses three detection paths:
1. **Apostrophe comments + ST keywords** — the strongest signal; 3+ apostrophe comment
   patterns with standard ST keywords
2. **Product identifier + ST** — "Proficy", "Machine Edition", "PACSystems", or "Emerson"
   with ST flow control
3. **PLC family + apostrophe comments** — RX3i/RX7i/VersaMax references with the
   distinctive comment style

## DFIR Relevance

- PACSystems are common in **power generation**, **water treatment**, and **oil & gas**
- GE/Emerson PLCs have been targeted in ICS-focused attacks
- Finding Machine Edition ST exports outside engineering workstations may indicate
  unauthorized access to PLC programs
- The apostrophe comment style makes these files easy to identify visually in forensic
  triage

#### See Also
- DAY 004: [CODESYS ST Extensions](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/004) — another vendor-specific ST variant
- DAY 013: [Mitsubishi MELSEC ST](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/013) — Mitsubishi-specific ST
- DAY 011: [Cross-vendor ST](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/011) — generic ST detection
