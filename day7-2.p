/*
--- Part Two ---

Now, you're ready to choose a directory to delete.

The total disk space available to the filesystem is 70000000. To run the update, you need unused space of at least 30000000. You need to find a directory you can delete that will free up enough space to run the update.

In the example above, the total size of the outermost directory (and thus the total amount of used space) is 48381165; this means that the size of the unused space must currently be 21618835, which isn't quite the 30000000 required by the update. Therefore, the update still requires a directory with total size of at least 8381165 to be deleted before it can run.

To achieve this, you have the following options:

    Delete directory e, which would increase unused space by 584.
    Delete directory a, which would increase unused space by 94853.
    Delete directory d, which would increase unused space by 24933642.
    Delete directory /, which would increase unused space by 48381165.

Directories e and a are both too small; deleting them would not free up enough space. However, directories d and / are both big enough! Between these, choose the smallest: d, increasing unused space by 24933642.

Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?
*/

DEFINE VARIABLE cCurPath AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCwd     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFName   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iTotal   AS INT64       NO-UNDO.
DEFINE VARIABLE iUsed    AS INT64       NO-UNDO.

DEFINE TEMP-TABLE ttDentry NO-UNDO 
 FIELD cPath      AS CHARACTER
 FIELD cDirName   AS CHARACTER
 FIELD cFileName  AS CHARACTER
 FIELD lIsDir     AS LOGICAL
 FIELD iSize      AS INT64
 INDEX ixp cPath
 INDEX ixd cDirName
 INDEX ixds lIsDir iSize.

FUNCTION dirname RETURNS CHARACTER ( pcPath AS CHARACTER ):    
    ENTRY(NUM-ENTRIES(pcPath, "/"), pcPath, "/") = "".
    pcPath = RIGHT-TRIM(pcPath, "/").
    RETURN IF pcPath = "" THEN "/" ELSE pcPath.
END FUNCTION.

FUNCTION basename RETURNS CHARACTER ( pcPath AS CHARACTER ):    
    RETURN ENTRY(NUM-ENTRIES(pcPath, "/"), pcPath, "/").
END FUNCTION.

FUNCTION folderSize RETURNS INT64 ( pcFolderPath AS CHARACTER ):    
    DEFINE BUFFER ttDentry FOR ttDentry.
    DEFINE VARIABLE iFolderSize AS INT64     NO-UNDO.
    FOR EACH ttDentry WHERE cDirName = pcFolderPath:
        IF lIsDir THEN iFolderSize = iFolderSize + folderSize(cPath).
        ELSE iFolderSize = iFolderSize + iSize.
    END.
    FIND ttDentry WHERE cPath = pcFolderPath.
    ttDentry.iSize = iFolderSize.
    RETURN iFolderSize.
END FUNCTION.

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day7.txt.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine = "" THEN NEXT.
    IF cLine BEGINS "$ " THEN DO:
        IF cLine BEGINS "$ cd " THEN DO:
            cCwd = REPLACE(cLine, "$ cd ", "").
            IF cCwd BEGINS "/" THEN cCurPath = cCwd.
            ELSE IF cCwd = ".." THEN cCurPath = dirname(cCurPath).
            ELSE cCurPath = cCurPath + (IF cCurPath = "/" THEN "" ELSE "/") + cCwd.
            FIND ttDentry WHERE cPath = cCurPath NO-ERROR.
            IF NOT AVAILABLE ttDentry THEN DO:
               CREATE ttDentry.
               ASSIGN cPath     = cCurPath
                      cDirName  = IF cPath = "/" THEN "" ELSE dirname(cCurPath)
                      cFileName = basename(cCurPath)
                      lIsDir    = YES.
            END.
        END.
    END. ELSE DO:
        IF cLine BEGINS "dir" THEN DO:
            /* nothing atm */
        END.
        ELSE DO: /* file */
            cFName = ENTRY(2, cLine, " ").
            FIND ttDentry WHERE cPath = cCurPath + "/" + cFName NO-ERROR.
            IF NOT AVAILABLE ttDentry THEN DO:
                CREATE ttDentry.
                ASSIGN cPath     = cCurPath + (IF cCurPath = "/" THEN "" ELSE "/") + cFName
                       cDirName  = dirname(cPath)
                       cFileName = cFName
                       iSize     = INTEGER(ENTRY(1, cLine, " ")).
            END.
        END.
    END.
END.
INPUT CLOSE.

iUsed = folderSize("/").

FOR EACH ttDentry WHERE lIsDir = YES AND iSize <= 100000:
    iTotal = iTotal + iSize.
END.

FIND FIRST ttDentry WHERE ttDentry.lIsDir = YES AND ttDentry.iSize >= 30000000 - 70000000 + iUsed.

MESSAGE ETIME SKIP
    /* "used" iUsed skip */
    /* "free" 70000000 - iUsed SKIP */
    /* "need" 30000000 SKIP */
    /* "MIN"  30000000 - 70000000 + iUsed SKIP */
    ttDentry.iSize
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
32 
30469934
---------------------------
OK   Aide   
---------------------------
*/
