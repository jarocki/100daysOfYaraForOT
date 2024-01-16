rule jcjot_AllenBradley_L5X {
    meta:
        description = "Allen-Bradley (Rockwell Automation) .L5X XML Structured Text file"

    strings:
        $xml   = "<?xml "
        $rslgx = "<RSLogix5000Content "

    condition:
        $xml in ( 0 .. 3) and $rslgx
}

rule jcjot_UTF8_BOM {
    meta:
        description = "Looks for the UTF-8 Byte Order Mark (BOM)"

    strings:
        $bom = { EF BB BF }

    condition:
        $bom at 0
}
