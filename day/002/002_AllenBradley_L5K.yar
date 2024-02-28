rule jcjot_AllenBradley_L5K_version {
    meta:
        description = "Find version statement in Allen-Bradley (Rockwell Automation) .L5K files"
        author = "John Jarocki"
        reference = "https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/1756-rm014_-en-p.pdf"
        md5 = "bd8cc5d35263cc3ea00bffd9c16abb8d"

    strings:
        $l5k_vstmt  = "Import-Export"
        $version    = /Version\s{0,10}:=\s{0,10}RSLogix[^\r\n]{0,100}[\r\n]/
        $owner      = /Owner\s{0,10}:=\s{0,10}[^\r\n,]{0,100}[\r\n]/
        $date       = /Exported\s{0,10}:=\s{0,10}[^\r\n]{0,100}[\r\n]/

    condition:
        all of them
}
