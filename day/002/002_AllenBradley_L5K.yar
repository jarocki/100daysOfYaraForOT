rule jcjot_AllenBradley_L5K_version {
    meta:
        description = "Find version statement in Allen-Bradley (Rockwell Automation) .L5K files"
        author = "John Jarocki"
        reference = "https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/1756-rm014_-en-p.pdf"
        md5 = "bd8cc5d35263cc3ea00bffd9c16abb8d"

    strings:
        $l5k_vstmt      = "Import-Export"
        $l5k_version    = /Version\s*:=\s*RSLogix[^\r\n]+v[\d\.]+\b/
        $l5k_owner      = /Owner\s*:=\s*[^\r\n,]+,[^\r\n,]+\b/
        $l5k_version    = /Exported\s*:=\s*[^\r\n]+v[\d\.]+\b/

    condition:
        $version
}
