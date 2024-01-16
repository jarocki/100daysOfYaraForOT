# Day 002: Allen-Bradley Structured Logic (.L5K) Files

You know what they say about standards....

Allen-Bradley is a brand of Programmable Logic Controllers developed by Rockwell Automation.
They use a proprietary platform called RSLogix 5000 (hence .L5K) that uses an "extended"
Structured Text format.

The ST extensions in .L5K files make it easier to extract information about the PLC components,
author, and versions of software used because RSLogix 5K exports that metadata automatically.

For example, here is a Version Statement:

```
(*********************************************

  Import-Export
  Version   := RSLogix 5000 v30.00
  Owner     := Jane Doe, PLC Technologies
  Exported  := Mon Apr  2 16:08:56 1971

  Note:  File encoded in UTF-8.  Only edit file in a program 
         which supports UTF-8 (like Notepad, not Wordpad).

**********************************************)
```

Today's signature will match these bits from the Version Statement to give more context.
Check back to this particular signature soon, because I actually want to update it
to extract more of the metadata from the .L5K, such as the device, import/export tool version,
main program name, etc.

#### Next... DAY 003: [Allen-Bradley .L5X XML Structured Text](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/003)


