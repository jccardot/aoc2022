/*
--- Day 7: No Space Left On Device ---

You can hear birds chirping and raindrops hitting leaves as the expedition proceeds. Occasionally, you can even hear much louder sounds in the distance; how big do the animals get out here, anyway?

The device the Elves gave you has problems with more than just its communication system. You try to run a system update:

$ system-update --please --pretty-please-with-sugar-on-top
Error: No space left on device

Perhaps you can delete some files to make space for the update?

You browse around the filesystem to assess the situation and save the resulting terminal output (your puzzle input). For example:

$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k

The filesystem consists of a tree of files (plain data) and directories (which can contain other directories or files). The outermost directory is called /. You can navigate around the filesystem, moving into or out of directories and listing the contents of the directory you're currently in.

Within the terminal output, lines that begin with $ are commands you executed, very much like some modern computers:

    cd means change directory. This changes which directory is the current directory, but the specific result depends on the argument:
        cd x moves in one level: it looks in the current directory for the directory named x and makes it the current directory.
        cd .. moves out one level: it finds the directory that contains the current directory, then makes that directory the current directory.
        cd / switches the current directory to the outermost directory, /.
    ls means list. It prints out all of the files and directories immediately contained by the current directory:
        123 abc means that the current directory contains a file named abc with size 123.
        dir xyz means that the current directory contains a directory named xyz.

Given the commands and output in the example above, you can determine that the filesystem looks visually like this:

- / (dir)
  - a (dir)
    - e (dir)
      - i (file, size=584)
    - f (file, size=29116)
    - g (file, size=2557)
    - h.lst (file, size=62596)
  - b.txt (file, size=14848514)
  - c.dat (file, size=8504156)
  - d (dir)
    - j (file, size=4060174)
    - d.log (file, size=8033020)
    - d.ext (file, size=5626152)
    - k (file, size=7214296)

Here, there are four directories: / (the outermost directory), a and d (which are in /), and e (which is in a). These directories also contain files of various sizes.

Since the disk is full, your first step should probably be to find directories that are good candidates for deletion. To do this, you need to determine the total size of each directory. The total size of a directory is the sum of the sizes of the files it contains, directly or indirectly. (Directories themselves do not count as having any intrinsic size.)

The total sizes of the directories above can be found as follows:

    The total size of directory e is 584 because it contains a single file i of size 584 and no other directories.
    The directory a has total size 94853 because it contains files f (size 29116), g (size 2557), and h.lst (size 62596), plus file i indirectly (a contains e which contains i).
    Directory d has total size 24933642.
    As the outermost directory, / contains every file. Its total size is 48381165, the sum of the size of every file.

To begin, find all of the directories with a total size of at most 100000, then calculate the sum of their total sizes. In the example above, these directories are a and e; the sum of their total sizes is 95437 (94853 + 584). (As in this example, this process can count files more than once!)

Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories?
*/

DEFINE VARIABLE cCurPath AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCwd     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFName   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iTotal   AS INT64       NO-UNDO.

DEFINE TEMP-TABLE ttDentry NO-UNDO 
 FIELD cPath      AS CHARACTER
 FIELD cDirName   AS CHARACTER
 FIELD cFileName  AS CHARACTER
 FIELD lIsDir     AS LOGICAL
 FIELD iSize      AS INT64
 INDEX ixp cPath
 INDEX ixd cDirName.

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

folderSize("/").

FOR EACH ttDentry WHERE lIsDir = YES AND iSize <= 100000:
    iTotal = iTotal + iSize.
END.

MESSAGE ETIME SKIP
    iTotal
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
22 
1453349
---------------------------
OK   Aide   
---------------------------
*/
