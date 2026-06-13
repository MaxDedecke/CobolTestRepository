       IDENTIFICATION DIVISION.
       PROGRAM-ID. REPORTPROG.
       AUTHOR. GEMINI-CLI.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-REPORT-HEADER.
           05  FILLER              PIC X(10) VALUE "REPORT ID:".
           05  HDR-REPORT-ID       PIC X(10) VALUE "USR-REP-01".
           05  FILLER              PIC X(05) VALUE SPACE.
           05  FILLER              PIC X(06) VALUE "DATE:".
           05  HDR-DATE            PIC X(10).

       01  WS-REPORT-LINE.
           05  DET-USER-ID         PIC X(10).
           05  FILLER              PIC X(02) VALUE " | ".
           05  DET-USER-NAME       PIC X(30).
           05  FILLER              PIC X(02) VALUE " | ".
           05  DET-USER-ROLE       PIC X(15).

           COPY "USER-DATA.cpy".
           COPY "CONSTANTS.cpy".

       PROCEDURE DIVISION.

       MAIN-LOGIC SECTION.
       000-START.
           DISPLAY "----------------------------------------------------".
           MOVE "2026-06-13" TO HDR-DATE.
           DISPLAY WS-REPORT-HEADER.
           DISPLAY "----------------------------------------------------".
           DISPLAY "USER ID    | NAME                           | ROLE".
           DISPLAY "----------------------------------------------------".
           
           MOVE "USR001" TO USER-ID.
           MOVE "MAX MUSTERMANN" TO USER-NAME.
           MOVE "ADMIN" TO USER-ROLE.
           PERFORM 100-PRINT-LINE.
           
           MOVE "USR002" TO USER-ID.
           MOVE "ERIKA MUSTERMANN" TO USER-NAME.
           MOVE "USER" TO USER-ROLE.
           PERFORM 100-PRINT-LINE.
           
           DISPLAY "----------------------------------------------------".
           DISPLAY "REPORT FINISHED.".
           GOBACK.

       100-PRINT-LINE.
           MOVE USER-ID TO DET-USER-ID.
           MOVE USER-NAME TO DET-USER-NAME.
           MOVE USER-ROLE TO DET-USER-ROLE.
           DISPLAY WS-REPORT-LINE.
