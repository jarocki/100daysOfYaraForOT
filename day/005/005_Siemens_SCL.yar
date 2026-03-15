rule jcj_OT_Siemens_SCL_Source {
    meta:
        description = "Siemens SCL (Structured Control Language) source file — STEP 7 / TIA Portal"
        author = "John Jarocki"
        reference = "https://cache.industry.siemens.com/dl/files/623/45523623/att_108338/v1/s7sclv5e_en-US.pdf"
        reference2 = "https://support.industry.siemens.com/cs/document/109784440/"
        hash = "ffbfb68405ddbe156d6a2da6e33ae9b8"

    strings:
        // Siemens-specific block declarations (not found in generic IEC 61131-3 ST)
        $blk_ob     = "ORGANIZATION_BLOCK" nocase
        $blk_db     = "DATA_BLOCK" nocase
        $blk_fb     = "FUNCTION_BLOCK" nocase
        $blk_fc     = /FUNCTION\s{0,10}[^_B]/

        // Siemens SCL pragmas and attributes
        $pragma_opt = "{S7_Optimized_Access" nocase
        $pragma_ext = "{InstructionName" nocase
        $pragma_gen = /\{\s{0,5}S7_/

        // TITLE = header lines (Siemens convention)
        $title      = /TITLE\s{0,5}=\s{0,5}[^\r\n]{0,100}/

        // BEGIN keyword separating declarations from code body
        $begin      = /\nBEGIN\s{0,5}[\r\n]/

        // Siemens temp variable notation with # prefix
        $temp_var   = /#\w{1,50}\s{0,5}:=/

        // NETWORK keyword for organizing logic sections
        $network    = /NETWORK\s{0,5}[\r\n]/

        // REGION / END_REGION for code folding (TIA Portal SCL)
        $region     = "REGION" nocase
        $end_region = "END_REGION" nocase

    condition:
        // Must have at least one Siemens-specific block type
        any of ($blk_*) and
        // Plus at least 2 of the Siemens-specific markers
        2 of ($pragma_*, $title, $begin, $temp_var, $network, $region, $end_region)
}
