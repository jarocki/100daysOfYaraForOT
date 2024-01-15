# IEC 61131-3 Structured Text files

The IEC 61131 standard for Programmable Logic Controllers (PLC) defines five programming languages for PLC devices:

1. Structured Text (ST or STX): A programming language based on Pascal
2. Ladder Diagram (or Ladder Logic)
3. Instruction List (IL): aka Statement List (STL); looks a lot like "PLC assembly language"
4. Function Block Diagram (FBD): a graphical diagram of functional flow
5. Sequential Function Chart (SFC): a graphical representation of sequential and parallel steps

For the first part of the #100daysofYARA challenge, I want to create Yara signatures for these filetypes
to help analysts discover PLC programming on systems or in network transfers.

## #100daysofYARA for #OT DAY 001: 

For the first day of the YARAtide season, I am sharing a very simple signature to detect Structured Text files.
Theoretically, this signature will detect any vendor and non-vendor ST files.  It relies on the END_* keywords
that close flow control statements, like "IF .. END_IF;"  
Also, the assignment statement (":=") is used to assign values to variables, as it is in structured programming
languages from the school of [Niklaus Wirth](https://en.wikipedia.org/wiki/Niklaus_Wirth), such as 
[Pascal](https://www.swissdelphicenter.ch/en/niklauswirth.php) and Modula/2.

Here is an example of Structured Text:
```
PROGRAM close_valve
   VAR valve_open : BOOL;
   END_VAR
   IF valve_open = True THEN
      valve_open := False
   END_IF;
END_PROGRAM;
```

The semicolon is requred to end all statements, but some implementations ignore that requirement,
just to make our lives more difficult. :-)

### NEXT UP:  Day 002 -- Allen-Bradley Structured Text (.L5K files)

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
