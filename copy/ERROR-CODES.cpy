      *****************************************************************
      * SECTION: NUMERIC ERROR CODES
      *****************************************************************
       01  ERR-CODES.
           05  ERR-SUCCESS         PIC 9(02) VALUE 00.
           05  ERR-NOT-FOUND       PIC 9(02) VALUE 01.
           05  ERR-INVALID-INPUT   PIC 9(02) VALUE 02.
           05  ERR-PERMISSION      PIC 9(02) VALUE 03.
           05  ERR-SYSTEM-ERROR    PIC 9(02) VALUE 99.

      *****************************************************************
      * SECTION: CORRESPONDING ERROR MESSAGES
      *****************************************************************
       01  ERR-MESSAGES.
           05  MSG-SUCCESS         PIC X(30) VALUE "OPERATION SUCCESSFUL".
           05  MSG-NOT-FOUND       PIC X(30) VALUE "RECORD NOT FOUND".
           05  MSG-INVALID         PIC X(30) VALUE "INVALID INPUT DETECTED".
           05  MSG-PERMISSION      PIC X(30) VALUE "PERMISSION DENIED".
           05  MSG-SYSTEM          PIC X(30) VALUE "CRITICAL SYSTEM ERROR".
