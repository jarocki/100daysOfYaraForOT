rule jcj_OT_CODESYS_Structured_Text {
    meta:
        description = "CODESYS Structured Text source with vendor-specific extensions"
        author = "John Jarocki"
        reference = "https://content.helpme-codesys.com/en/CODESYS%20Development%20System/_cds_struct_text_editor.html"
        hash = "69826a7f5476221ace619e3c27020711"

    strings:
        // CODESYS-specific assignment extensions (not in IEC 61131-3 standard)
        $ext_set    = /\w\s{0,5}S=\s{0,5}/
        $ext_reset  = /\w\s{0,5}R=\s{0,5}/

        // CODESYS special method names for function block initialization
        $fb_init    = ".FB_init" nocase
        $fb_reinit  = ".FB_reinit" nocase
        $fb_exit    = ".FB_exit" nocase

        // CODESYS special pointer syntax
        $ptr_super  = "SUPER^"
        $ptr_this   = "THIS^"

        // CODESYS pragmas (curly-brace attribute syntax)
        $pragma_attr = /\{attribute\s{1,10}'/
        $pragma_flag = /\{flag\s/

        // Standard IEC 61131-3 keywords that must also be present
        $kw_fb      = "FUNCTION_BLOCK" nocase
        $kw_var     = "VAR" nocase
        $kw_end_var = "END_VAR" nocase
        $assign     = /\w\s{0,5}:=\s{0,5}/

        // CODESYS-specific data types and keywords
        $pointer    = "POINTER TO" nocase
        $reference  = "REFERENCE TO" nocase
        $interface  = /INTERFACE\s{1,10}\w/
        $method     = /METHOD\s{1,10}\w/
        $property   = /PROPERTY\s{1,10}\w/

    condition:
        // Must have ST fundamentals
        $assign and ($kw_fb or $kw_var) and $kw_end_var and
        // Must have at least one CODESYS-specific extension
        (1 of ($ext_set, $ext_reset) or
         1 of ($fb_init, $fb_reinit, $fb_exit) or
         1 of ($ptr_super, $ptr_this) or
         1 of ($pragma_attr, $pragma_flag) or
         // CODESYS OOP extensions (INTERFACE, METHOD, PROPERTY with POINTER/REFERENCE TO)
         (1 of ($interface, $method, $property) and 1 of ($pointer, $reference)))
}
