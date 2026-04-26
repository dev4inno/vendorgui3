      *****************************************************************
      *    SUB - SIEBKE UNTERNEHMENSBERATUNG  www.siebke.com          *
      *    ---------------------------------                          *
      *                                                               *
      *    VENDOR RECORD                                              *
      *    (ID: VE)                                                   *
      *                                                               *
      *    RECORD LENGTH: 640 BYTES                                   *
      *    ORGANIZATION : INDEXED             LAST CHANGE: 03.04.2024 *
      *****************************************************************
       01  VENDOR-RECORD.
      *  ------------> PRIMARY KEY                         001-008
           05  VENDOR-KEY. 
      *  ------------> VENDOR NUMBER                       001-008
               10  VE-VENNR                PIC 9(008).
      *  ------------> SECONDARY KEY 1                     009-048
           05  VENDOR-KEY-S1.                              
      *  ------------> COMPANY NAME                        009-048
               10  VE-CNAME                PIC X(040).
      *  ------------> LAST NAME                           049-078
           05  VE-LNAME                    PIC X(030).
      *  ------------> FIRST NAME                          079-103
           05  VE-FNAME                    PIC X(025).
      *  ------------> ADD. INFORMATION                    104-133
           05  VE-AINFO                    PIC X(030).
      *  ------------> COUNTRY                             134-158
           05  VE-CNTRY                    PIC X(025).
      *  ------------> POSTCODE                            159-168
           05  VE-PCODE                    PIC X(010). 
      *  ------------> COMPANY CITY                        169-208
           05  VE-CCITY                    PIC X(040).
      *  ------------> STATE                               209-210
           05  VE-STATE                    PIC X(002).
      *  ------------> STREET AND NO.                      211-245
           05  VE-STRNO                    PIC X(035).
      *  ------------> PHONE NUMBER                        246-265
           05  VE-PHONE                    PIC X(020).
      *  ------------> E-MAIL                              266-305
           05  VE-EMAIL                    PIC X(040).           
      *  ------------> BANK NAME                           306-340
           05  VE-BNAME                    PIC X(035).  
      *  ------------> SWIFT/IBAN                          341-362
           05  VE-SWIFT                    PIC X(022).
      *  ------------> BANK ACCOUNT NO.                    363-382
           05  VE-ACCNT                    PIC X(020).
      *  ------------> BANK CITY                           383-422
           05  VE-BCITY                    PIC X(040).
      *  ------------> REMARKS 1                           423-492
           05  VE-REM01                    PIC X(070).
      *  ------------> REMARKS 2                           493-562
           05  VE-REM02                    PIC X(070).
      *  ------------> DELETION FLAG                       563-563
           05  VE-DFLAG                    PIC X(001).
      *  ------------> CHANGE DATE                         564-571
           05  VE-UDATE                    PIC 9(008).
      *  ------------> CHANGE USER                         572-586
           05  VE-UUSER                    PIC X(015).
      *  ------------> CREATION DATE                       587-594
           05  VE-CDATE                    PIC 9(008).
      *  ------------> CREATION USER                       595-609
           05  VE-CUSER                    PIC X(015).
      *  ------------> FILLER (RESERVE FOR EXTENSIONS)     610-640
           05  FILLER                      PIC X(031).
