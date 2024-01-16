# DAY 001: IEC 61131-3 Structured Text files

The IEC 61131 standard for Programmable Logic Controllers (PLC) defines five programming languages for PLC devices in part 3 [IEC 61131-3](https://en.wikipedia.org/wiki/IEC_61131-3):

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

#### NEXT UP:  Day 002: [Allen-Bradley L5K Structured Text](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/002)

