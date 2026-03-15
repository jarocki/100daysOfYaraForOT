# DAY 010: Siemens TIA Portal Project Archives (.zap13–.zap19)

Siemens TIA Portal (Totally Integrated Automation Portal) is the unified engineering
framework for configuring Siemens PLCs (S7-1200, S7-1500), HMIs, drives, and network
infrastructure.  TIA Portal exports project archives with version-specific extensions:

| Extension | TIA Portal Version |
|-----------|--------------------|
| .zap13    | V13 (2014)         |
| .zap14    | V14 (2015)         |
| .zap15    | V15 (2018)         |
| .zap16    | V16 (2019)         |
| .zap17    | V17 (2021)         |
| .zap18    | V18 (2023)         |
| .zap19    | V19 (2024)         |

## File format

TIA Portal archives (.zap*) are **ZIP containers** with a well-defined internal structure:

```
archive.zap17
├── ProjectData/
│   ├── Project.xml          ← project metadata, device config
│   └── ...
├── HardwareConfiguration/   ← hardware topology
├── SoftwareConfiguration/   ← PLC programs (SCL, LAD, FBD, STL)
│   └── PLC_1/
│       └── ...
└── [metadata files with Siemens.Automation / Siemens.Engineering namespaces]
```

The Siemens namespace strings (`Siemens.Automation`, `Siemens.Engineering`, `Siemens.Simatic`)
appear in XML metadata files within the archive and are strong indicators.

## Hunting recommendations

- **Extension-based search is insufficient**: .zap files can be renamed.  This rule detects
  the internal content regardless of file extension.
- **Version identification**: The version markers (V13–V19) in the archive metadata help
  determine which TIA Portal version created the project, which informs:
  - Which vulnerabilities may be exploitable
  - What PLC firmware versions are likely in use
  - The approximate age of the project
- **Exfiltration detection**: TIA Portal archives contain the complete PLC program, hardware
  configuration, and network topology.  Finding these outside engineering workstations is
  a significant finding.
- **Pair with DAY 005**: SCL source within a TIA Portal archive will also match the Siemens
  SCL rule when extracted.

#### See Also
- DAY 005: [Siemens SCL Source](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/005) — detects the PLC program source inside extracted archives
