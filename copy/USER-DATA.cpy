      *****************************************************************
      * SECTION: USER CORE DATA
      *****************************************************************
       01  USER-RECORD.
           05  USER-ID             PIC X(10).
           05  USER-NAME           PIC X(30).
           05  USER-ROLE           PIC X(15).
           
      *****************************************************************
      * SECTION: USER METADATA
      *****************************************************************
           05  USER-LAST-LOGIN     PIC 9(08).
           05  USER-STATUS         PIC X(01).
               88  USER-ACTIVE             VALUE 'A'.
               88  USER-INACTIVE           VALUE 'I'.
               88  USER-LOCKED             VALUE 'L'.
