# COBOL Test Repository

This is a demonstration COBOL project structure.

## Structure
- \`src/\`: Main COBOL source files.
  - \`MAINPROG.cbl\`: Primary program demonstrating sections, paragraphs, and data fields.
  - \`UTILPROG.cbl\`: Utility program called by \`MAINPROG\`.
- \`copy/\`: COBOL copybooks.
  - \`USER-DATA.cpy\`: Data structure for user information.
  - \`CONSTANTS.cpy\`: Application constants.
  - \`ERROR-CODES.cpy\`: Standardized error codes and messages.
- \`scripts/\`: Helper scripts.
  - \`compile.sh\`: Script to simulate or perform compilation.

## Components
- **Programs**: \`MAINPROG.cbl\`, \`UTILPROG.cbl\`
- **Sections**: \`MAIN-LOGIC\`, \`INITIALIZATION-SECTION\`, \`PROCESSING-SECTION\`, \`FINALIZATION-SECTION\`, \`MAIN-SECTION\`.
- **Paragraphs**: \`000-START\`, \`100-INITIALIZE\`, \`200-PROCESS\`, \`300-FINALIZE\`, \`000-PROCESS-UTILS\`.
- **Data Fields**: Defined in \`WORKING-STORAGE SECTION\`, \`LINKAGE SECTION\` and via copybooks.
- **Copybooks**: Used for modularity and shared data structures.
- **Inter-program communication**: \`MAINPROG\` calls \`UTILPROG\` using parameters.
