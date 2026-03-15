rule jcj_OT_IEC61131_ST_Generic_Module {
    meta:
        description = "Cross-vendor IEC 61131-3 Structured Text module detection — function blocks, functions, and programs"
        author = "John Jarocki"
        reference = "https://en.wikipedia.org/wiki/IEC_61131-3"
        reference2 = "https://www.plcacademy.com/structured-text-tutorial/"
        hash = "c63aca875972332f7a8c83895ecf9346"

    strings:
        // IEC 61131-3 variable declaration keywords
        $kw_var         = "VAR" nocase
        $kw_var_input   = "VAR_INPUT" nocase
        $kw_var_output  = "VAR_OUTPUT" nocase
        $kw_var_inout   = "VAR_IN_OUT" nocase
        $kw_var_global  = "VAR_GLOBAL" nocase
        $kw_end_var     = "END_VAR" nocase

        // Program Organization Unit (POU) declarations
        $pou_fb         = "FUNCTION_BLOCK" nocase
        $pou_fn         = /FUNCTION\s{1,10}\w/
        $pou_prog       = "PROGRAM " nocase

        // POU closing keywords
        $end_fb         = "END_FUNCTION_BLOCK" nocase
        $end_fn         = "END_FUNCTION" nocase
        $end_prog       = "END_PROGRAM" nocase

        // Flow control END_ keywords (IEC 61131-3 specific)
        $end_if         = "END_IF" nocase
        $end_for        = "END_FOR" nocase
        $end_while      = "END_WHILE" nocase
        $end_case       = "END_CASE" nocase
        $end_repeat     = "END_REPEAT" nocase

        // ST assignment operator — the Wirth-family `:=`
        $assign         = /\w\s{0,5}:=\s{0,5}/

        // ST comment style: (* ... *)
        $comment_st     = /\(\*[^)]{0,200}\*\)/

        // IEC 61131-3 data types (help distinguish from Pascal/Modula-2)
        $dt_bool        = /:\s{0,5}BOOL/  nocase
        $dt_int         = /:\s{0,5}INT/   nocase
        $dt_real        = /:\s{0,5}REAL/  nocase
        $dt_dint        = /:\s{0,5}DINT/  nocase
        $dt_word        = /:\s{0,5}WORD/  nocase
        $dt_time        = /:\s{0,5}TIME/  nocase

    condition:
        // Require assignment operator (defines ST vs other IEC languages)
        $assign and
        // At least one END_ block closer (separates from C-style languages)
        1 of ($end_if, $end_for, $end_while, $end_case, $end_repeat) and
        // At least one POU declaration or closing
        (1 of ($pou_*) or 1 of ($end_fb, $end_fn, $end_prog)) and
        // Variable declarations present
        $kw_var and $kw_end_var and
        // Threshold: at least 3 keyword matches for confidence
        3 of ($kw_*) and
        // ST-style comments or data type declarations for additional confidence
        ($comment_st or 1 of ($dt_*))
}
