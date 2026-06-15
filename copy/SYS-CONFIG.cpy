      * SYSTEM CONFIGURATION
       01  SYS-CONFIG.
           05  SYS-NAME            PIC X(20) VALUE "COBOL-TEST-SYSTEM".
           05  SYS-VERSION         PIC X(05) VALUE "V2.0".
           05  SYS-ENVIRONMENT     PIC X(10) VALUE "DEVELOPMENT".
           05  SYS-MAX-THREADS     PIC 9(02) VALUE 04.
           05  SYS-LOG-PATH        PIC X(50) VALUE "/var/log/cobol/".
           05  SYS-TIMEOUT         PIC 9(03) VALUE 120.
           05  SYS-FLAGS           PIC X(10).
               88  SYS-DEBUG-ON    VALUE "DEBUG".
               88  SYS-AUDIT-ON    VALUE "AUDIT".
