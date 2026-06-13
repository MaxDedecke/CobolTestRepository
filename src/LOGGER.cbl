       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOGGER.
       AUTHOR. GEMINI-CLI.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CURRENT-DATE-DATA.
           05  WS-DATE             PIC 9(08).
           05  WS-TIME             PIC 9(08).

       LINKAGE SECTION.
           COPY "LOG-DATA.cpy".

       PROCEDURE DIVISION USING LK-LOG-DATA.

       000-LOG.
           ACCEPT WS-DATE FROM DATE YYYYMMDD.
           ACCEPT WS-TIME FROM TIME.
           
           DISPLAY WS-DATE " " WS-TIME " [" LK-LOG-LEVEL "] " 
                   LK-LOG-SENDER ": " LK-LOG-MSG.
           
           GOBACK.
