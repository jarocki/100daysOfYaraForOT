# DAY 009: Omron CX-Programmer Project Files (.cxp / .cxt)

Omron is a major Japanese manufacturer of industrial automation equipment, including the
popular CP1, CJ2, CS1, NJ, and NX series PLCs.  Their engineering software,
**CX-Programmer** (part of the CX-One suite), produces two file formats:

## File formats

### .CXP — Binary Project File (NOT detectable by YARA)

CXP files use **proprietary compression** that produces no identifiable magic bytes or
embedded strings.  Hex analysis of real CXP samples shows completely opaque binary data
with no constant file header, no embedded text markers, and no recognizable structure.

**YARA cannot reliably detect CXP files.**  To hunt for CXP files, use:
- File extension matching (`.cxp`)
- Filesystem metadata and directory context (e.g., found alongside CX-Programmer installation)
- Network protocol analysis (FINS protocol traffic suggesting Omron device communication)

### .CXT — Text Export File (detectable)

CXT files are **text-based exports** of CX-Programmer projects.  They contain:
- Header information with "CX-Programmer" and PLC Name/Type metadata
- Program and section definitions with structured content
- PLC model references (CP1, CJ2, CS1, Sysmac)

The YARA rule for CXT detection requires:
1. CX-Programmer or OMRON identifier
2. Structured export markers (PLC Name/Type, Program Name, Section definitions, Rung data)
3. Omron PLC series reference

## Legacy OT Context

Omron PLCs are found in a wide range of industries:
- **Automotive manufacturing** (Omron has deep roots in factory automation)
- **Packaging and material handling**
- **Water/wastewater treatment**
- **Building automation**

Many Omron installations use older CJ2 and CS1 series hardware that may lack modern
security features.  CX-Programmer remains the primary tool for these legacy devices,
even as Omron transitions newer hardware to the Sysmac Studio platform.

## Exfiltration Detection

CXT files contain:
- Complete PLC program logic (ladder, ST, FBD)
- I/O configuration and addressing
- Symbol tables mapping physical I/O to program variables
- PLC model and communication settings

Finding these files outside engineering workstations — in email, cloud storage, USB
dumps, or network captures — should trigger investigation.

## Note on Sysmac Studio

Omron's newer Sysmac Studio (for NJ/NX series) uses different file formats (.smc2).
This rule focuses on CX-Programmer, which remains widely deployed for legacy equipment.

#### Next: DAY 010 — [Siemens TIA Portal Archives (.zap)](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/010)
