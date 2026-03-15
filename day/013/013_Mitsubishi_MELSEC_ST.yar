rule jcj_OT_Mitsubishi_MELSEC_Structured_Text {
    meta:
        description = "Mitsubishi Electric MELSEC Structured Text with vendor-specific functions"
        author = "John Jarocki"
        reference = "https://dl.mitsubishielectric.com/dl/fa/document/manual/plc/sh080366e/sh080366ek.pdf"
        hash = "2c465c33c194e6c734ad6c261bbbc6bc"

    strings:
        // MELSEC-specific special functions ending in _M()
        // These are unique to Mitsubishi MELSEC Q and L series
        $mfn_set    = "SET_M" nocase
        $mfn_rst    = "RST_M" nocase
        $mfn_delta  = "DELTA_M" nocase
        $mfn_stop   = "STOP_M" nocase
        $mfn_out    = "OUT_M" nocase
        $mfn_pls    = "PLS_M" nocase
        $mfn_plf    = "PLF_M" nocase

        // Regex for the general MELSEC _M() function pattern
        $mfn_regex  = /[A-Z_]{2,10}_M\s{0,3}\(/

        // MELSEC device memory prefixes (D = data register, M = relay, X = input, Y = output)
        // Using := context to avoid slow scanning on short patterns
        $dev_d      = /D\d{1,5}\s{0,3}:?=/
        $dev_m      = /M\d{1,5}\s{0,3}[;)]/
        $dev_x      = /X\d{1,5}\s{0,3}[;)=]/
        $dev_y      = /Y\d{1,5}\s{0,3}[;)]/
        $dev_w      = /W\d{1,5}\s{0,3}[;)=]/
        $dev_r      = /R\d{1,5}\s{0,3}[;)=]/

        // Mitsubishi product identifiers
        $melsec     = "MELSEC" nocase
        $gx_works   = "GX Works" nocase
        $gx_dev     = "GX Developer" nocase
        $mitsubishi = "Mitsubishi" nocase
        $melsoft    = "MELSOFT" nocase

        // Standard IEC 61131-3 ST keywords
        $kw_var     = "VAR" nocase
        $kw_end_var = "END_VAR" nocase
        $assign     = /\w\s{0,5}:=\s{0,5}/

    condition:
        // Must have ST fundamentals
        $assign and $kw_var and $kw_end_var and
        // At least one MELSEC-specific indicator:
        (
            // Option 1: MELSEC _M() functions
            2 of ($mfn_set, $mfn_rst, $mfn_delta, $mfn_stop, $mfn_out, $mfn_pls, $mfn_plf) or
            // Option 2: _M() regex pattern + device memory references
            ($mfn_regex and 2 of ($dev_d, $dev_m, $dev_x, $dev_y, $dev_w, $dev_r)) or
            // Option 3: Mitsubishi product identifier + any _M() function or device refs
            (1 of ($melsec, $gx_works, $gx_dev, $mitsubishi, $melsoft) and
             ($mfn_regex or 2 of ($dev_d, $dev_m, $dev_x, $dev_y, $dev_w, $dev_r)))
        )
}
