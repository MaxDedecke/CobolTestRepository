       IDENTIFICATION DIVISION.
       PROGRAM-ID. DATEPROG.
       AUTHOR. GEMINI-CLI.

       DATA DIVISION.
       LINKAGE SECTION.
       01  LK-DATE-REQUEST.
           05  LK-ACTION           PIC X(10).
               88  ACT-GET-DATE            VALUE "GETDATE".
               88  ACT-FORMAT-DATE         VALUE "FORMAT".
           05  LK-DATE-ISO         PIC X(10).
           05  LK-DATE-NUM         PIC 9(08).

       PROCEDURE DIVISION USING LK-DATE-REQUEST.

       MAIN-LOGIC SECTION.
       000-START.
           EVALUATE TRUE
               WHEN ACT-GET-DATE
                   ACCEPT LK-DATE-NUM FROM DATE YYYYMMDD
                   MOVE LK-DATE-NUM(1:4) TO LK-DATE-ISO(1:4)
                   MOVE "-" TO LK-DATE-ISO(5:1)
                   MOVE LK-DATE-NUM(5:2) TO LK-DATE-ISO(6:2)
                   MOVE "-" TO LK-DATE-ISO(8:1)
                   MOVE LK-DATE-NUM(7:2) TO LK-DATE-ISO(9:2)
               WHEN ACT-FORMAT-DATE
                   * Assume LK-DATE-NUM is set
                   MOVE LK-DATE-NUM(1:4) TO LK-DATE-ISO(1:4)
                   MOVE "-" TO LK-DATE-ISO(5:1)
                   MOVE LK-DATE-NUM(5:2) TO LK-DATE-ISO(6:2)
                   MOVE "-" TO LK-DATE-ISO(8:1)
                   MOVE LK-DATE-NUM(7:2) TO LK-DATE-ISO(9:2)
           END-EVALUATE.

           GOBACK.
