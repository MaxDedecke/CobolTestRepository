       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDATOR.
       AUTHOR. GEMINI-CLI.

       DATA DIVISION.
       LINKAGE SECTION.
       01  LK-TYPE                 PIC X(10).
       01  LK-VALUE                PIC X(30).
       01  LK-RESULT               PIC 9(01).
           88  VALID-VAL                   VALUE 0.
           88  INVALID-VAL                 VALUE 1.

       PROCEDURE DIVISION USING LK-TYPE LK-VALUE LK-RESULT.

       000-START.
           MOVE 0 TO LK-RESULT.
           
           EVALUATE LK-TYPE
               WHEN "NUMERIC"
                   IF LK-VALUE IS NOT NUMERIC
                       MOVE 1 TO LK-RESULT
                   END-IF
               WHEN "NOT-EMPTY"
                   IF LK-VALUE = SPACES
                       MOVE 1 TO LK-RESULT
                   END-IF
               WHEN OTHER
                   MOVE 9 TO LK-RESULT
           END-EVALUATE.
           
           GOBACK.
