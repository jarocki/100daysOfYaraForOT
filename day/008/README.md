# DAY 008: CODESYS V3 Project Archives and Libraries

[CODESYS](https://www.codesys.com/) (Controller Development System) is arguably the most
widespread IEC 61131-3 development environment in the OT world.  Developed by 3S-Smart
Software Solutions GmbH, CODESYS is not tied to a single hardware vendor — it runs on
PLCs from **hundreds of manufacturers** including ABB, Beckhoff, Bosch Rexroth, WAGO,
Festo, Schneider (SoMachine), and many others.

This makes CODESYS project files particularly valuable for detection: one rule covers a
huge range of OT devices.

## File formats

### .projectarchive — CODESYS V3 Project Archive

A `.projectarchive` is a **ZIP container** that bundles the complete CODESYS project:

```
project.projectarchive (ZIP)
├── [Content_Types].xml    ← OpenXML-style content type definitions
├── .project               ← project metadata (XML, references 3s-software.com namespace)
├── PlcLogic/
│   └── Application/       ← PLC programs, function blocks, GVLs
├── DeviceDescription/     ← target PLC hardware configuration
└── [library references, compiler settings, etc.]
```

The archive structure resembles OpenXML (like .docx), with `[Content_Types].xml` at the
root level.  The 3S-Smart Software namespace (`http://www.3s-software.com`) in XML metadata
is the strongest indicator.

### .library / .compiled-library — CODESYS Libraries

CODESYS libraries are also ZIP-based and contain reusable function blocks, functions, and
data types.  They include metadata like `LibraryInfo`, `LibraryCategory`, version numbers,
and namespace declarations.

Libraries are significant from a security perspective because:
- They contain pre-compiled code that runs on PLCs
- Malicious libraries could introduce backdoor logic
- The CODESYS Library Manager downloads libraries from repositories

## DFIR Relevance

- **Broad vendor coverage**: A single CODESYS detection catches projects targeting PLCs
  from dozens of manufacturers
- **Supply chain risk**: CODESYS libraries are a potential vector for supply chain attacks
  against industrial controllers
- **Encrypted archives**: CODESYS V3 supports project encryption — encrypted archives
  will match the ZIP header but may not expose internal strings.  Document this as a
  known limitation.
- **CODESYS vulnerabilities**: Multiple CVEs have targeted the CODESYS runtime
  (e.g., CVE-2021-29240, CVE-2022-47391).  Finding CODESYS projects helps identify
  potentially affected devices.

## Caveat: encrypted projects

CODESYS V3 supports project-level encryption.  Encrypted `.projectarchive` files will
still match the ZIP magic bytes, but the internal file paths and metadata strings may
be encrypted.  The rule may not match encrypted projects — this is a known limitation
that should be documented in any detection playbook.

#### Next: DAY 009 — [Omron CX-Programmer Project Files](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/009)
