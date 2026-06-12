# COBOL Test Repository

This is a demonstration COBOL project structure.

## Structure
- \`src/\`: Main COBOL source files.
  - \`MAINPROG.cbl\`: Primary orchestrator program.
  - \`UTILPROG.cbl\`: Utility program for data validation.
  - \`FILEPROG.cbl\`: Program handling file I/O operations.
- \`copy/\`: COBOL copybooks.
  - \`USER-DATA.cpy\`: Data structure for user information.
  - \`CONSTANTS.cpy\`: Application constants.
  - \`ERROR-CODES.cpy\`: Standardized error codes.
  - \`FILE-REC.cpy\`: File description for user data.
- \`data/\`: Sample data files.
  - \`users.dat\`: Fixed-width user data file.
- \`scripts/\`: Helper scripts.
  - \`compile.sh\`: Script to compile the project.

## Components
- **Programs**: \`MAINPROG.cbl\`, \`UTILPROG.cbl\`, \`FILEPROG.cbl\`
- **Sections & Paragraphs**: Structured use of Procedure Division divisions.
- **Data Handling**: Usage of \`WORKING-STORAGE\`, \`LINKAGE\`, and \`FILE SECTION\`.
- **File I/O**: Sequential file reading in \`FILEPROG.cbl\`.
- **Modularity**: Extensive use of \`COPY\` statements for reusability.
- **Communication**: Inter-program calls with parameter passing.
