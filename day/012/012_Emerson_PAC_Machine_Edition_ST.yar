rule jcj_OT_Emerson_PAC_Machine_Edition_ST {
    meta:
        description = "Emerson PAC Machine Edition (formerly GE Proficy) Structured Text export"
        author = "John Jarocki"
        reference = "https://www.emerson.com/en-us/automation/control-and-safety-systems/programmable-automation-control-systems"
        hash = "7667e08ecc8a86612b7464d64ff70edb"

    strings:
        // GE/Emerson apostrophe-style inline comments (unique to this platform)
        // Standard IEC 61131-3 uses (* *) for comments; Machine Edition uses '
        $comment_apos   = /'\s{0,3}-{3,}/
        $comment_block  = /'\s{1,5}(Created|Modified|Author|Version|Description)[:]/
        $comment_line   = /\n'\s{1,5}\w/

        // Emerson / GE product identifiers
        $emerson        = "Emerson" nocase
        $ge_proficy     = "Proficy" nocase
        $machine_ed     = "Machine Edition" nocase
        $pac_systems    = "PACSystems" nocase
        $pac_me         = "PAC Machine Edition" nocase

        // PACSystems PLC family references
        $rx3i           = "RX3i" nocase
        $rx7i           = "RX7i" nocase
        $versamax       = "VersaMax" nocase
        $pacsys_cpu     = /IC69\dCPU\d{3}/

        // Standard IEC 61131-3 ST keywords (must also be present)
        $kw_var         = "VAR" nocase
        $kw_end_var     = "END_VAR" nocase
        $assign         = /\w\s{0,5}:=\s{0,5}/
        $end_if         = "END_IF" nocase

    condition:
        // Must have ST fundamentals
        $assign and $kw_var and
        (
            // Path 1: Apostrophe comments (unique to Machine Edition) + ST keywords
            (3 of ($comment_apos, $comment_block, $comment_line) and $kw_end_var) or
            // Path 2: Product identifier + ST fundamentals
            (1 of ($emerson, $ge_proficy, $machine_ed, $pac_systems, $pac_me) and $end_if) or
            // Path 3: PLC family reference + apostrophe comments
            (1 of ($rx3i, $rx7i, $versamax, $pacsys_cpu) and 1 of ($comment_apos, $comment_block, $comment_line))
        )
}
