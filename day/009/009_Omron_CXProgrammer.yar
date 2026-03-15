rule jcj_OT_Omron_CXProgrammer_CXT {
    meta:
        description = "Omron CX-Programmer text export file (.cxt)"
        author = "John Jarocki"
        reference = "https://www.omron.com/global/en/products/family/17/"
        hash = "36ab2255b29ae37f885f90a7f25f6ce1"

    strings:
        // CXT files are text-based exports with Omron-specific headers
        $cxt_header     = "CX-Programmer" nocase
        $omron          = "OMRON" nocase

        // Omron-specific structured text and ladder export markers
        $plc_name       = /PLC\s{0,5}Name\s{0,5}[:=]/
        $plc_type       = /PLC\s{0,5}Type\s{0,5}[:=]/
        $program_name   = /Program\s{0,5}Name\s{0,5}[:=]/
        $section        = /Section\s{0,5}(Name|Type)\s{0,5}[:=]/
        $rung_export    = /Rung\s{0,5}\d/

        // Omron PLC model references
        $cp_series      = "CP1" nocase
        $cj_series      = "CJ2" nocase
        $cs_series      = "CS1" nocase
        $sysmac         = "Sysmac" nocase

    condition:
        // Must contain CX-Programmer or Omron reference
        ($cxt_header or $omron) and
        // Plus structured export content
        2 of ($plc_name, $plc_type, $program_name, $section, $rung_export) and
        // And a PLC series reference
        1 of ($cp_series, $cj_series, $cs_series, $sysmac)
}

// NOTE: Omron CX-Programmer binary project files (.cxp) use proprietary compression
// that produces no identifiable magic bytes or embedded strings. YARA cannot reliably
// detect .cxp files. To hunt for CXP files, use file extension matching or filesystem
// metadata instead. The CXT (text export) rule above covers the human-readable variant.
