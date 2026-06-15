      * FINANCIAL DATA STRUCTURE
       01  FIN-DATA.
           05  FIN-AMOUNT          PIC 9(07)V99.
           05  FIN-TAX-RATE        PIC V99 VALUE .19.
           05  FIN-DISCOUNT        PIC V99 VALUE .05.
           05  FIN-TOTAL           PIC 9(07)V99.
           05  FIN-CURRENCY        PIC X(03) VALUE "EUR".
           05  FIN-STATUS          PIC X(02).
               88  FIN-SUCCESS     VALUE "00".
               88  FIN-OVERFLOW    VALUE "01".
               88  FIN-INVALID     VALUE "02".
