# DAY 007: Schneider Unity Pro Archive & Exchange Files (.STA, .XEF, .ZEF)

While DAY 006 covered the primary Schneider project file (.STU), Schneider's ecosystem also
produces several additional file formats for archiving, exchanging, and backing up PLC projects.

## File formats

### .STA — Schneider Archive

The STA file is a **ZIP-based archive** that bundles together the entire project:
- The .STU project file itself
- Exchange files (.XEF, .ZEF)
- Configuration data and project settings

Think of it as a "project backup" format — everything needed to restore the project on
another engineering workstation.

### .XEF — XML Exchange Format

The XEF format is Schneider's **XML-based export** of PLC program data.  This is the
human-readable format used for:
- Transferring program sections between projects
- Version control (XML diffs are meaningful)
- Integration with external tools

Key XML elements include:
- `<Exchange>` or `<UnityExport>` as root elements
- `<program>`, `<section>`, `<variables>`, `<dataBlock>` for program structure
- `<FBD>`, `<LD>`, `<ST>`, `<IL>` for programming language-specific sections
- Schneider PLC identifiers (Modicon, M340, M580)

### .ZEF — Compressed Exchange Format

ZEF files are **binary/compressed variants** of the XEF exchange format.  Tools like
[ZEF_splitter](https://github.com/corax4/ZEF_splitter) can decompose them into text
and binary components for version control workflows.

## Two rules, one file

This YARA file contains two rules:

1. **`jcj_OT_Schneider_UnityPro_STA_Archive`** — Detects ZIP-based .STA archives containing
   Schneider project data
2. **`jcj_OT_Schneider_UnityPro_XEF_Exchange`** — Detects XML-based .XEF exchange files
   with Schneider program content

## IR Use Cases

- **Exfiltration detection**: XEF files are human-readable PLC logic — finding them in
  email attachments, cloud storage, or network captures is noteworthy
- **Change tracking**: XEF exports can be diffed to identify unauthorized PLC modifications
- **Backup analysis**: STA archives on engineering workstations reveal the project history
  and what PLC environments are managed from that system
- **Supply chain review**: Exchange files may contain third-party function blocks with
  embedded logic worth reviewing

#### Next: DAY 008 — [CODESYS V3 Project Archives](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/008)
