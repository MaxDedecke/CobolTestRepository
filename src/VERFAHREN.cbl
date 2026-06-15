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
           05  WS-DB-ACTION        PIC X(10).

           COPY "LOG-DATA.cpy" REPLACING LK-LOG-DATA BY WS-LOG-DATA.
           COPY "DB-RECORD.cpy" REPLACING DB-RECORD BY WS-DB-REC.

       PROCEDURE DIVISION.

       MAIN-PROCESS SECTION.
       000-START.
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "VERFAHREN" TO WS-LOG-SENDER.
           MOVE "STARTING COMPLEX BATCH SEQUENCE" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           DISPLAY "========================================".
           DISPLAY "VERFAHREN: STARTING COMPLEX BATCH SEQUENCE".
           DISPLAY "========================================".

           PERFORM 100-STEP-INITIALIZE.
           PERFORM 150-STEP-DB-LOAD.
           PERFORM 200-STEP-MAIN-LOGIC.
           PERFORM 250-STEP-DB-UPDATE.
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

       150-STEP-DB-LOAD.
           ADD 1 TO WS-STEP-COUNT.
           MOVE "DB LOAD" TO WS-CURRENT-STEP.
           DISPLAY "STEP " WS-STEP-COUNT ": " WS-CURRENT-STEP.
           
           MOVE "GET" TO WS-DB-ACTION.
           MOVE "BATCH-JOB-DATA" TO DB-KEY OF WS-DB-REC.
           CALL "DBPROG" USING WS-DB-ACTION WS-DB-REC.
           
           IF DB-OK OF WS-DB-REC
               DISPLAY "DB LOADED: " DB-DATA-FIELD-1 OF WS-DB-REC
           ELSE
               DISPLAY "DB LOAD FAILED"
           END-IF.

       200-STEP-MAIN-LOGIC.
           ADD 1 TO WS-STEP-COUNT.
           MOVE "MAIN LOGIC" TO WS-CURRENT-STEP.
           DISPLAY "STEP " WS-STEP-COUNT ": " WS-CURRENT-STEP.
           
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "EXECUTING MAIN LOGIC" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           CALL "MAINPROG".

       250-STEP-DB-UPDATE.
           ADD 1 TO WS-STEP-COUNT.
           MOVE "DB UPDATE" TO WS-CURRENT-STEP.
           DISPLAY "STEP " WS-STEP-COUNT ": " WS-CURRENT-STEP.
           
           MOVE "PUT" TO WS-DB-ACTION.
           MOVE "BATCH-JOB-RESULT" TO DB-KEY OF WS-DB-REC.
           MOVE "SUCCESSFUL RUN" TO DB-DATA-FIELD-1 OF WS-DB-REC.
           CALL "DBPROG" USING WS-DB-ACTION WS-DB-REC.

       300-STEP-FILE-REPORT.
           ADD 1 TO WS-STEP-COUNT.
           MOVE "FILE REPORTING" TO WS-CURRENT-STEP.
           DISPLAY "STEP " WS-STEP-COUNT ": " WS-CURRENT-STEP.
           
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "EXECUTING FILE REPORT" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           MOVE "READ" TO WS-MSG.
           CALL "FILEPROG" USING WS-MSG WS-RC.
