rule jcjot_IEC1131_Structured_Text_file {
    meta:
        description = "Allen-Bradley (Rockwell Automation) Ladder Logic .L5K Structured Text files"
        author = "John Jarocki"
        reference = "https://www.plcacademy.com/structured-text-tutorial/"
        md5 = "e5846301f4fd5a6ec6b2f1768ac648ad"
    strings:
        $start      = "PROGRAM " nocase
        $assign     = /\w\s{0,10}:=\s{0,10}\w/
        $endif      = "END_IF" nocase
        $finish     = "END_PROGRAM" nocase
    condition:
        all of them
}
