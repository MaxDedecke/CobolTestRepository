      *****************************************************************
      * SECTION: APPLICATION IDENTIFICATION
      *****************************************************************
       01  WS-APP-INFO.
           05  APP-NAME            PIC X(20) VALUE 'COBOL-DEMO-APP'.
           05  VERSION             PIC X(05) VALUE '1.0.1'.
           05  BUILD-DATE          PIC X(10) VALUE '2026-06-13'.

      *****************************************************************
      * SECTION: RETURN CODES
      *****************************************************************
       01  WS-RETURN-CODES.
           05  SUCCESS-CODE        PIC 9(01) VALUE 0.
           05  ERROR-CODE          PIC 9(01) VALUE 1.
           05  FATAL-CODE          PIC 9(01) VALUE 9.

      *****************************************************************
      * SECTION: FILE STATUS CODES
      *****************************************************************
       01  WS-FILE-STATUS-CONST.
           05  FS-OK               PIC X(02) VALUE '00'.
           05  FS-EOF              PIC X(02) VALUE '10'.
           05  FS-NOT-FOUND        PIC X(02) VALUE '23'.
