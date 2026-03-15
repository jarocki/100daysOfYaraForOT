rule jcj_OT_Schneider_UnityPro_STU {
    meta:
        description = "Schneider Electric Unity Pro / EcoStruxure Control Expert project file (.STU)"
        author = "John Jarocki"
        reference = "https://www.se.com/us/en/faqs/FAQ000259996/"
        hash = "9aefad18b1d03866abc5bb5e6b2823d4"

    strings:
        // ZIP local file header magic (STU files are ZIP archives)
        $zip_magic      = { 50 4B 03 04 }

        // Schneider-specific internal file paths (always present in STU archives)
        $station_ctx    = "STATION.CTX"
        $props_xml      = "props.xml"
        $bin_appli      = "BinAppli/"
        $station_apx    = "Station.apx"

        // Schneider project metadata embedded in props.xml
        $ctrl_expert    = "Control Expert" nocase
        $unity_pro      = "Unity Pro" nocase
        $ecostruxure    = "EcoStruxure" nocase
        $product_ver    = "ProductVersion"
        $category_plc   = "CategoryPLC"

        // Internal database and config files characteristic of STU
        $fdt_dtm        = "FDTDTMMgr"
        $cfg_pre        = "CfgPre.db"
        $conf_project   = "ConfProject.db"
        $var_mgr        = "VariableManager"
        $slm_db         = "SLM.db"

    condition:
        // Must be a ZIP archive
        $zip_magic at 0 and
        // Must contain STATION.CTX (the defining Schneider project marker)
        $station_ctx and
        // Must contain internal database files (distinguishes full STU from lightweight STA)
        2 of ($fdt_dtm, $cfg_pre, $conf_project, $var_mgr, $slm_db) and
        // Plus product identification
        (1 of ($ctrl_expert, $unity_pro, $ecostruxure, $product_ver, $category_plc) or
         1 of ($bin_appli, $station_apx, $props_xml))
}
