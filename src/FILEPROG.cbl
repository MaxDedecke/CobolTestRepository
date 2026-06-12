       IDENTIFICATION DIVISION.
       PROGRAM-ID. FILEPROG.
       AUTHOR. GEMINI-CLI.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE ASSIGN TO "data/users.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
           COPY "FILE-REC.cpy".

       WORKING-STORAGE SECTION.
       01  WS-EOF-SWITCH           PIC X(01) VALUE 'N'.
           88  END-OF-FILE                   VALUE 'Y'.

       LINKAGE SECTION.
       01  LK-ACTION               PIC X(05).
       01  LK-STATUS               PIC 9(02).

       PROCEDURE DIVISION USING LK-ACTION LK-STATUS.

       MAIN-LOGIC SECTION.
       000-START.
           IF LK-ACTION = "READ"
               PERFORM 100-READ-FILE
           ELSE
               MOVE 99 TO LK-STATUS
           END-IF.
           GOBACK.

       READ-SECTION SECTION.
       100-READ-FILE.
           OPEN INPUT USER-FILE.
           MOVE 00 TO LK-STATUS.
           
           PERFORM UNTIL END-OF-FILE
               READ USER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-SWITCH
                   NOT AT END
                       DISPLAY "FILEPROG: READ " FD-USER-NAME
               END-READ
           END-PERFORM.
           
           CLOSE USER-FILE.
