      * DATABASE RECORD STRUCTURE
       01  DB-RECORD.
           05  DB-KEY              PIC X(20).
           05  DB-DATA-FIELD-1     PIC X(50).
           05  DB-DATA-FIELD-2     PIC 9(10).
           05  DB-TIMESTAMP        PIC 9(14).
           05  DB-STATUS           PIC X(02).
               88  DB-OK           VALUE "00".
               88  DB-NOT-FOUND    VALUE "01".
               88  DB-LOCKED       VALUE "02".
               88  DB-ERROR        VALUE "99".
