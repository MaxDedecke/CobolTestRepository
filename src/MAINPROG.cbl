       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAINPROG.
       AUTHOR. GEMINI-CLI.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.
      * Including copybooks from copy/ directory
           COPY "USER-DATA.cpy".
           COPY "CONSTANTS.cpy".
           COPY "ERROR-CODES.cpy".
           COPY "LOG-DATA.cpy" REPLACING LK-LOG-DATA BY WS-LOG-DATA.

       01  WS-INTERNAL-DATA.
           05  WS-COUNTER          PIC 9(03) VALUE 0.
           05  WS-MSG              PIC X(50).
           05  WS-UTIL-RC          PIC 9(02).
           05  WS-FILE-ACTION      PIC X(05).
           05  WS-FILE-STATUS      PIC 9(02).
           05  WS-VAL-TYPE         PIC X(10).
           05  WS-VAL-VALUE        PIC X(30).
           05  WS-VAL-RESULT       PIC 9(01).

       PROCEDURE DIVISION.

       MAIN-LOGIC SECTION.
       000-START.
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "MAINPROG" TO WS-LOG-SENDER.
           MOVE "STARTING PROCESSING" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           PERFORM 100-INITIALIZE.
           
           DISPLAY "--- STAGE 1: LOCAL PROCESSING ---".
           PERFORM 200-PROCESS.
           
           DISPLAY "--- STAGE 2: UTILITY CALL ---".
           MOVE "Testing Util Call" TO WS-MSG.
           CALL "UTILPROG" USING WS-MSG WS-UTIL-RC.
           DISPLAY "UTILPROG RETURNED: " WS-UTIL-RC.
           
           DISPLAY "--- STAGE 3: FILE PROCESSING ---".
           MOVE "READ" TO WS-FILE-ACTION.
           CALL "FILEPROG" USING WS-FILE-ACTION WS-FILE-STATUS.
           DISPLAY "FILEPROG STATUS: " WS-FILE-STATUS.
           
           PERFORM 300-FINALIZE.
           
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "FINISHED PROCESSING" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.
           
           GOBACK.

       INITIALIZATION-SECTION SECTION.
       100-INITIALIZE.
           MOVE "INITIALIZING DATA..." TO WS-MSG.
           DISPLAY WS-MSG.
           MOVE "USR001" TO USER-ID.
           MOVE "MAX MUSTERMANN" TO USER-NAME.
           
           MOVE "NUMERIC" TO WS-VAL-TYPE.
           MOVE USER-ID TO WS-VAL-VALUE.
           CALL "VALIDATOR" USING WS-VAL-TYPE WS-VAL-VALUE WS-VAL-RESULT.
           
           IF WS-VAL-RESULT NOT = 0
               MOVE "WARN " TO WS-LOG-LEVEL
               MOVE "USER-ID IS NOT NUMERIC" TO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
           END-IF.

           MOVE "ADMIN" TO USER-ROLE.
           MOVE 20260612 TO USER-LAST-LOGIN.

       PROCESSING-SECTION SECTION.
       200-PROCESS.
           MOVE "PROCESSING USER: " TO WS-MSG.
           DISPLAY WS-MSG USER-NAME.
           ADD 1 TO WS-COUNTER.
           DISPLAY "VISIT COUNTER: " WS-COUNTER.

       FINALIZATION-SECTION SECTION.
       300-FINALIZE.
           DISPLAY "SHUTTING DOWN " APP-NAME.
           MOVE SUCCESS-CODE TO WS-COUNTER.
