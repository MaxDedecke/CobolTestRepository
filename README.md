# COBOL Test Repository

This is a demonstration COBOL project structure.

## Structure
- `src/`: Main COBOL source files.
  - `MAINPROG.cbl`: Primary program demonstrating sections, paragraphs, and data fields.
- `copy/`: COBOL copybooks.
  - `USER-DATA.cpy`: Data structure for user information.
  - `CONSTANTS.cpy`: Application constants.

## Components
- **Programs**: `MAINPROG.cbl`
- **Sections**: `MAIN-LOGIC`, `INITIALIZATION-SECTION`, `PROCESSING-SECTION`, `FINALIZATION-SECTION`.
- **Paragraphs**: `000-START`, `100-INITIALIZE`, `200-PROCESS`, `300-FINALIZE`.
- **Data Fields**: Defined in `WORKING-STORAGE SECTION` and via copybooks.
- **Copybooks**: Used for modularity and shared data structures.
