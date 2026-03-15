rule jcj_OT_Schneider_UnityPro_STA_Archive {
    meta:
        description = "Schneider Electric Unity Pro / EcoStruxure Control Expert archive (.STA)"
        author = "John Jarocki"
        reference = "https://www.se.com/us/en/faqs/FAQ000259996/"
        hash = "0201a5e00c7821803acbc5859a69d705"

    strings:
        // ZIP local file header magic (STA files are ZIP-based archives)
        $zip_magic      = { 50 4B 03 04 }

        // Schneider-specific internal file paths
        $station_ctx    = "STATION.CTX"
        $props_xml      = "props.xml"
        $bin_appli      = "BinAppli/"
        $station_apx    = "Station.apx"
        $station_apd    = "Station.apd"
        $dtm_audit      = "DtmAuditRecord.xml"

        // Embedded metadata from props.xml
        $ctrl_expert    = "Control Expert" nocase
        $unity_pro      = "Unity Pro" nocase
        $product_ver    = "ProductVersion"
        $category_plc   = "CategoryPLC"

    condition:
        // Must be a ZIP archive
        $zip_magic at 0 and
        // Must contain STATION.CTX (defines this as a Schneider project)
        $station_ctx and
        // Plus props.xml or BinAppli (standard STA structure)
        ($props_xml or $bin_appli or $station_apx or $station_apd or $dtm_audit) and
        // Schneider product confirmation (from embedded props.xml or STATION.CTX)
        1 of ($ctrl_expert, $unity_pro, $product_ver, $category_plc)
}

rule jcj_OT_Schneider_UnityPro_XEF_Exchange {
    meta:
        description = "Schneider Electric Unity Pro / EcoStruxure Control Expert XML exchange file (.XEF)"
        author = "John Jarocki"
        reference = "https://github.com/corax4/ZEF_splitter"
        hash = "ce2b3818c996e8f4f022c6251dc6a291"

    strings:
        // XML declaration (XEF files are XML-based)
        $xml_decl       = "<?xml " nocase

        // Schneider exchange format root element and header
        $fef_root       = "<FEFExchangeFile" nocase
        $file_header    = "<fileHeader"
        $content_header = "<contentHeader"

        // Schneider company identifier in fileHeader
        $schneider_co   = "Schneider Automation" nocase
        $schneider_se   = "Schneider Electric" nocase

        // Product version markers
        $ctrl_expert    = "Control Expert" nocase
        $unity_pro      = "Unity Pro" nocase

        // XEF program content elements
        $fb_source      = "<FBSource" nocase
        $fbd_source     = "<FBDSource" nocase
        $efb_source     = "<EFBSource" nocase
        $ef_source      = "<EFSource" nocase
        $ddt_source     = "<DDTSource" nocase
        $data_block     = "<dataBlock" nocase
        $fb_program     = "<FBProgram" nocase

    condition:
        // Must start with XML declaration (within first 10 bytes for BOM)
        $xml_decl in (0..10) and
        // Must have the FEF exchange root element
        $fef_root and
        // Must have fileHeader with Schneider company or product identifier
        ($file_header or $content_header) and
        (1 of ($schneider_co, $schneider_se, $ctrl_expert, $unity_pro)) and
        // At least one program content element (reduces false positives on generic XML)
        1 of ($fb_source, $fbd_source, $efb_source, $ef_source, $ddt_source, $data_block, $fb_program)
}
