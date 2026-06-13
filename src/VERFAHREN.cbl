       IDENTIFICATION DIVISION.
       PROGRAM-ID. VERFAHREN.
       AUTHOR. GEMINI-CLI.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-JOB-CONTROL.
           05  WS-STEP-COUNT       PIC 9(02) VALUE 0.
           05  WS-CURRENT-STEP     PIC X(20).
           
       01  WS-PARAMS.
           05  WS-MSG              PIC X(50).
           05  WS-RC               PIC 9(02).

           COPY "LOG-DATA.cpy" REPLACING LK-LOG-DATA BY WS-LOG-DATA.

       PROCEDURE DIVISION.

       MAIN-PROCESS SECTION.
       000-START.
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "VERFAHREN" TO WS-LOG-SENDER.
           MOVE "STARTING BATCH SEQUENCE" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           DISPLAY "========================================".
           DISPLAY "VERFAHREN: STARTING BATCH SEQUENCE".
           DISPLAY "========================================".

           PERFORM 100-STEP-INITIALIZE.
           PERFORM 200-STEP-MAIN-LOGIC.
           PERFORM 300-STEP-FILE-REPORT.

           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "BATCH SEQUENCE COMPLETED" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           DISPLAY "========================================".
           DISPLAY "VERFAHREN: SEQUENCE COMPLETED".
           DISPLAY "========================================".
           STOP RUN.

       STEPS SECTION.
       100-STEP-INITIALIZE.
           ADD 1 TO WS-STEP-COUNT.
           MOVE "INITIALIZATION" TO WS-CURRENT-STEP.
           DISPLAY "STEP " WS-STEP-COUNT ": " WS-CURRENT-STEP.
           
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "EXECUTING INITIALIZATION" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           MOVE "SYSTEM STARTUP" TO WS-MSG.
           CALL "UTILPROG" USING WS-MSG WS-RC.
           IF WS-RC NOT = 0
               MOVE "ERROR" TO WS-LOG-LEVEL
               MOVE "INITIALIZATION FAILED" TO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               DISPLAY "CRITICAL ERROR IN " WS-CURRENT-STEP
               STOP RUN
           END-IF.

       200-STEP-MAIN-LOGIC.
           ADD 1 TO WS-STEP-COUNT.
           MOVE "MAIN LOGIC" TO WS-CURRENT-STEP.
           DISPLAY "STEP " WS-STEP-COUNT ": " WS-CURRENT-STEP.
           
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "EXECUTING MAIN LOGIC" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           CALL "MAINPROG".

       300-STEP-FILE-REPORT.
           ADD 1 TO WS-STEP-COUNT.
           MOVE "FILE REPORTING" TO WS-CURRENT-STEP.
           DISPLAY "STEP " WS-STEP-COUNT ": " WS-CURRENT-STEP.
           
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "EXECUTING FILE REPORT" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           MOVE "READ" TO WS-MSG.
           CALL "FILEPROG" USING WS-MSG WS-RC.
           IF WS-RC NOT = 0
               MOVE "WARN " TO WS-LOG-LEVEL
               MOVE "FILE REPORTING RETURNED ERROR" TO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               DISPLAY "ERROR IN " WS-CURRENT-STEP " RC: " WS-RC
           END-IF.
