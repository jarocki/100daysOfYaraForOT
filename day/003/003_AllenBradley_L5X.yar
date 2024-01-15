rule jcjot_AllenBradley_L5X {
    meta:
        description = "Allen-Bradley (Rockwell Automation) .L5X XML Structured Text file"

    strings:
        $xml   = "<?xml "
        $rslgx = "<RSLogix5000Content "

    condition:
        $xml in ( 0 .. 3) and $rslgx
}
