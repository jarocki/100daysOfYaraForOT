rule jcj_OT_Siemens_TIAPortal_ZAP {
    meta:
        description = "Siemens TIA Portal project archive (.zap13 through .zap19)"
        author = "John Jarocki"
        reference = "https://support.industry.siemens.com/cs/document/109784440/"
        hash = "008901642e355c884e0f0f293817e00b"

    strings:
        // ZIP local file header magic (TIA .zap files are ZIP archives)
        $zip_magic  = { 50 4B 03 04 }

        // Siemens TIA Portal internal archive paths and metadata
        $tia_auto   = "Siemens.Automation" nocase
        $tia_eng    = "Siemens.Engineering" nocase
        $tia_proj   = "TIA Portal" nocase
        $tia_step7  = "Siemens.Simatic" nocase

        // Internal file paths and filenames found inside .zap archives
        $path_proj  = /ProjectData[\\\/]/
        $path_hw    = /HardwareConfiguration[\\\/]/
        $path_sw    = /SoftwareConfiguration[\\\/]/
        $path_plc   = /PLC_\d/
        $sys_pedata = "System-PEData"
        $plcm_arch  = "plcmArchive.pma"
        $path_im    = /\\IM\\/

        // TIA Portal version markers that appear in metadata XML
        $ver_v13    = "V13" nocase
        $ver_v14    = "V14" nocase
        $ver_v15    = "V15" nocase
        $ver_v16    = "V16" nocase
        $ver_v17    = "V17" nocase
        $ver_v18    = "V18" nocase
        $ver_v19    = "V19" nocase

    condition:
        // Must be a ZIP file
        $zip_magic at 0 and
        // At least one Siemens namespace or product string
        1 of ($tia_*) and
        // At least one internal path or version marker
        (1 of ($path_*) or 1 of ($ver_*) or $sys_pedata or $plcm_arch)
}
