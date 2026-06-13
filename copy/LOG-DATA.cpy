      *****************************************************************
      * SECTION: LOGGING DATA STRUCTURE
      *****************************************************************
       01  LK-LOG-DATA.
           05  LK-LOG-LEVEL        PIC X(05).
               88  LOG-INFO                VALUE "INFO ".
               88  LOG-WARN                VALUE "WARN ".
               88  LOG-ERROR               VALUE "ERROR".
           05  LK-LOG-MSG          PIC X(60).
           05  LK-LOG-SENDER       PIC X(10).
           05  LK-LOG-TIMESTAMP    PIC X(19).
