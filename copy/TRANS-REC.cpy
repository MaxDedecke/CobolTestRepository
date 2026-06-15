      * TRANSACTION RECORD STRUCTURE
       01  TRANS-REC.
           05  TRANS-ID            PIC X(10).
           05  TRANS-DATE          PIC 9(08).
           05  TRANS-TYPE          PIC X(01).
               88  TRANS-DEBIT     VALUE "D".
               88  TRANS-CREDIT    VALUE "C".
           05  TRANS-AMOUNT        PIC 9(07)V99.
           05  TRANS-USER-ID       PIC X(06).
           05  TRANS-DESC          PIC X(30).
           05  TRANS-STATUS        PIC X(01).
               88  TRANS-PENDING   VALUE "P".
               88  TRANS-POSTED    VALUE "S".
               88  TRANS-FAILED    VALUE "F".
