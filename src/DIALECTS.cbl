       IDENTIFICATION DIVISION.
       PROGRAM-ID. DIALECTS.
       AUTHOR. GEMINI-CLI.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MESSAGE          PIC X(100).
       01  WS-SQL-STATUS       PIC S9(9) COMP.
       01  WS-LONG-STRING      PIC X(200) VALUE "THIS IS A VERY LONG STR
      -    "ING THAT USES THE CONTINUATION CHARACTER IN COLUMN 7".

       PROCEDURE DIVISION.

       MAIN-SECTION SECTION.
       100-START.
           DISPLAY "STARTING DIALECT TEST".

           * Test 1: EXEC SQL (Should be masked)
           EXEC SQL
               SELECT COUNT(*)
               INTO :WS-SQL-STATUS
               FROM CUSTOMERS
               WHERE STATUS = 'ACTIVE'
           END-EXEC.

           IF WS-SQL-STATUS > 0
               MOVE "CUSTOMERS FOUND" TO WS-MESSAGE
               DISPLAY WS-MESSAGE
           END-IF.

           * Test 2: EXEC CICS (Should be masked)
           EXEC CICS
               SEND TEXT FROM(WS-MESSAGE)
               ERASE
           END-EXEC.

           * Test 3: Continuation Line
           DISPLAY WS-LONG-STRING.

           GOBACK.
