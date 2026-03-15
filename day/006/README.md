# DAY 006: Schneider Unity Pro / EcoStruxure Control Expert Project Files (.STU)

Schneider Electric's Unity Pro — now rebranded as **EcoStruxure Control Expert** — is the
engineering environment for programming Schneider Modicon PLCs (M340, M580, Premium, Quantum).

## The .STU file format

STU files are **ZIP archives** containing the complete project data:

```
project.STU (ZIP archive)
├── STATION.CTX            ← station configuration (wide-char metadata)
├── props.xml              ← project properties (ProductVersion, CategoryPLC, Author)
├── BinAppli/
│   ├── Station.apd        ← application descriptor
│   └── Station.apx        ← application binary
├── ConfProject.db         ← project configuration database
├── VariableManager.db     ← variable table database
├── FDTDTMMgr.db           ← Device Type Manager database
├── SLM.db                 ← security/licensing
├── CfgPre.db              ← configuration data
└── [additional .db and config files]
```

The `STATION.CTX` file is the defining marker — it contains wide-character strings with
the application name, processor type, version info, and Schneider product identification
(e.g., "EcoStruxure Control Expert 15.30").

The `props.xml` file provides structured metadata:
```xml
<Properties>
  <ProductVersion>Control Expert 15.30</ProductVersion>
  <CategoryPLC>Micro Basic BMX P34 2000 03.20</CategoryPLC>
  <Author>engineer</Author>
</Properties>
```

## Detection strategy

The rule differentiates STU from STA (the lightweight archive format in DAY 007) by
requiring the internal `.db` database files that only appear in full STU projects.

## DFIR Relevance

- STU files contain the **complete PLC project**: logic, variable tables, hardware config,
  communication settings, and security configuration
- The `CategoryPLC` field in `props.xml` identifies the exact PLC hardware model
- `STATION.CTX` contains processor version, application dates, and connection settings
- STU files are NOT version-compatible across different Control Expert versions

## Historical note

Schneider has rebranded this tool multiple times:
- **Concept** (legacy) → **Unity Pro** (2003–2020) → **EcoStruxure Control Expert** (2020+)

#### Next: DAY 007 — [Schneider Archive & Exchange Files (.STA, .XEF, .ZEF)](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/007)
