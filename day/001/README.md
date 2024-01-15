# IEC 61131-3 Structured Text files

The IEC 61131 standard for Programmable Logic Controllers (PLC) defines five programming languages for PLC devices:

1. Structured Text (ST or STX): A programming language based on Pascal
2. Ladder Diagram (or Ladder Logic)
3. Instruction List (IL): aka Statement List (STL); looks a lot like "PLC assembly language"
4. Function Block Diagram (FBD): a graphical diagram of functional flow
5. Sequential Function Chart (SFC): a graphical representation of sequential and parallel steps

For the first part of the #100daysofYARA challenge, I want to create Yara signatures for these filetypes
to help analysts discover PLC programming on systems or in network transfers.

---

## ASIDE: Accounting for the UTF-8 Byte Order Mark

When I first developed these signatures, I was suprised that not all samples matched them.  After all,
I had reviewed the contents closely.  That's when it occurred to me:  I neglected to examine the
samples with a hex editor.

In fact, it turned out that some of the files started with a sequence of 3 non-printable bytes:
```0xEF 0xBB 0xBF```  This was because some of the samples were Unicode (rather than ASCII encoded).  You can see this below

```% find . -name \*.L5X -exec xxd -l 8 {} \;```
```
% find . -name \*.L5X -print -exec xxd -l 8 {} \;                                               ;: [1192]18:42:12.609
./samples/IO Processing/Anlg_In.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/IO Processing/Anlg_Out.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/IO Processing/DI_In.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/IO Processing/DI_Out.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/BCNT/BCNT.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/Gauss-Jordan/Solve_GaussJordan.L5X
00000000: 3c3f 786d 6c20 7665                      <?xml ve
./samples/HexSTOD.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/SEQ_TIMER.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/AOI_SeqTimer_103.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/HexSTOD10.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
./samples/Array_Scroll.L5X
00000000: efbb bf3c 3f78 6d6c                      ...<?xml
```

This is why the search for the XML filemagic has to be within the first 4 bytes.
