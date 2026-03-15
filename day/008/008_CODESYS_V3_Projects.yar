rule jcj_OT_CODESYS_V3_ProjectArchive {
    meta:
        description = "CODESYS V3 project archive (.projectarchive) — 3S-Smart Software Solutions"
        author = "John Jarocki"
        reference = "https://www.codesys.com/"
        hash = "22241b566581056fe2ac6abb7bb0639a"

    strings:
        // ZIP local file header magic (projectarchive files are ZIP containers)
        $zip_magic      = { 50 4B 03 04 }

        // CODESYS-specific content within the archive
        $codesys        = "CODESYS" nocase
        $3s_software    = "3S-Smart Software" nocase
        $3s_namespace   = "3s-software.com" nocase
        $codesys_proj   = ".project"
        $codesys_ns     = "http://www.3s-software.com"

        // Internal file paths found in CODESYS project archives
        $content_types  = "[Content_Types].xml"
        $plc_logic      = "PlcLogic"
        $application    = "Application"
        $device_desc    = "DeviceDescription"
        $gvl            = "GVL"

        // CODESYS runtime and compilation markers
        $runtime        = "CoDeSys" nocase
        $compiler       = "Compiler" nocase
        $iec_project    = "IEC-Project"

    condition:
        // Must be a ZIP archive
        $zip_magic at 0 and
        // At least one CODESYS identifier
        1 of ($codesys, $3s_software, $3s_namespace, $codesys_ns, $runtime) and
        // Plus project structure indicators
        2 of ($codesys_proj, $content_types, $plc_logic, $application, $device_desc, $gvl, $iec_project, $compiler)
}

rule jcj_OT_CODESYS_V3_Library {
    meta:
        description = "CODESYS V3 compiled library (.library / .compiled-library)"
        author = "John Jarocki"
        reference = "https://www.codesys.com/"
        hash = "bdf405dfb048b3a72a44d2f5ece9204e"

    strings:
        // ZIP local file header magic
        $zip_magic      = { 50 4B 03 04 }

        // CODESYS library-specific markers
        $codesys        = "CODESYS" nocase
        $3s_software    = "3S-Smart Software" nocase
        $3s_namespace   = "3s-software.com" nocase

        // Library metadata
        $lib_meta       = "LibraryInfo"
        $lib_category   = "LibraryCategory"
        $lib_version    = "LibVersion"
        $lib_company    = "Company"
        $lib_namespace  = "DefaultNamespace"

        // CODESYS library repository paths
        $lib_repo       = "Library Repository" nocase
        $lib_manager    = "Library Manager" nocase

    condition:
        // Must be a ZIP archive
        $zip_magic at 0 and
        // CODESYS identifier
        1 of ($codesys, $3s_software, $3s_namespace) and
        // Library-specific metadata
        2 of ($lib_meta, $lib_category, $lib_version, $lib_company, $lib_namespace, $lib_repo, $lib_manager)
}
