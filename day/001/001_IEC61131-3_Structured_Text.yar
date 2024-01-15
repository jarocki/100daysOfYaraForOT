rule jcjot_IEC1131_Structured_Text_file {
    meta:
        description = "Allen-Bradley (Rockwell Automation) Ladder Logic .L5K Structured Text files"
        author = "John Jarocki"
        reference = "https://www.plcacademy.com/structured-text-tutorial/"
        md5 = "e5846301f4fd5a6ec6b2f1768ac648ad"

    strings:
        $endif      = "END_IF" nocase
        $endcase    = "END_CASE" nocase
        $endfor     = "END_FOR" nocase
        $endwhile   = "END_WHILE" nocase
        $endrepeat  = "END_REPEAT" nocase
        $start      = "PROGRAM " nocase
        $finish     = "END_PROGRAM" nocase
        $assign     = "\s*:=\s*" nocase
    condition:
        $start and $finish and $assign and 1 of ($end*)
}
