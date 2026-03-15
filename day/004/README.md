# DAY 004: CODESYS Structured Text Extensions

CODESYS (Controller Development System), developed by 3S-Smart Software Solutions GmbH,
is the most widely used IEC 61131-3 development environment in the world.  Unlike
vendor-locked platforms, CODESYS runs on PLCs from hundreds of manufacturers.

While DAY 008 detects CODESYS **project archive files** (the ZIP containers), this rule
detects CODESYS **Structured Text source code** by identifying vendor-specific language
extensions that go beyond the IEC 61131-3 standard.

## CODESYS ST Extensions

### Set/Reset Assignments: `S=` and `R=`

CODESYS adds `S=` (set) and `R=` (reset) assignment operators for bistable behavior:

```
Motor_Running S= Start_Button;    (* Set: latch TRUE *)
Motor_Running R= Stop_Button;     (* Reset: latch FALSE *)
```

These are not part of IEC 61131-3 and are unique to CODESYS.

### Function Block Lifecycle Methods

CODESYS extends function blocks with special methods:
- `.FB_init` — called when the FB instance is created
- `.FB_reinit` — called on warm restart
- `.FB_exit` — called when the FB instance is destroyed

### Special Pointers: `SUPER^` and `THIS^`

CODESYS supports object-oriented programming with:
- `THIS^` — pointer to the current FB instance
- `SUPER^` — pointer to the parent class (in inheritance)

### OOP Extensions

CODESYS supports full OOP with `INTERFACE`, `METHOD`, `PROPERTY`, `POINTER TO`,
and `REFERENCE TO` — features not available in most other IEC 61131-3 implementations.

### Pragmas

CODESYS uses curly-brace pragmas for compiler directives:
```
{attribute 'qualified_only'}
{flag off}
```

## Detection Strategy

The rule requires standard ST fundamentals (`:=`, `VAR`, `END_VAR`) plus at least one
CODESYS-specific extension.  This prevents false positives on generic ST while catching
the distinctive CODESYS flavor.

## DFIR Relevance

- CODESYS ST source found outside an engineering workstation may indicate exfiltration
  of PLC program logic
- The OOP extensions (`INTERFACE`, `METHOD`) suggest a modern CODESYS V3 project,
  which narrows the PLC hardware possibilities
- CODESYS runtime vulnerabilities (multiple CVEs) make identifying CODESYS-based
  environments particularly important during incident response

#### See Also
- DAY 008: [CODESYS V3 Project Archives](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/008) — detects the ZIP container format
- DAY 011: [Cross-vendor ST](https://github.com/jarocki/100daysOfYaraForOT/tree/main/day/011) — generic ST detection
