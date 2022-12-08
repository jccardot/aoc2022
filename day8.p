/*
--- Day 8: Treetop Tree House ---

The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a tree house.

First, determine whether there is enough tree cover here to keep a tree house hidden. To do this, you need to count the number of trees that are visible from outside the grid when looking directly along a row or column.

The Elves have already launched a quadcopter to generate a map with the height of each tree (your puzzle input). For example:

30373
25512
65332
33549
35390

Each tree is represented as a single digit whose value is its height, where 0 is the shortest and 9 is the tallest.

A tree is visible if all of the other trees between it and an edge of the grid are shorter than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

All of the trees around the edge of the grid are visible - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the interior nine trees to consider:

    The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
    The top-middle 5 is visible from the top and right.
    The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
    The left-middle 5 is visible, but only from the right.
    The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
    The right-middle 3 is visible from the right.
    In the bottom row, the middle 5 is visible, but the 3 and 4 are not.

With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

Consider your map; how many trees are visible from outside the grid?
*/

DEFINE TEMP-TABLE ttTree NO-UNDO 
 FIELD X        AS INTEGER  
 FIELD Y        AS INTEGER  
 FIELD iHeight  AS INTEGER  
 FIELD lVisible AS LOGICAL
 INDEX ixxy X Y
 INDEX ixy Y
 INDEX ixv lVisible.

DEFINE VARIABLE cLine       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxX       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxY       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPrevHeight AS INTEGER     NO-UNDO.
DEFINE VARIABLE iX          AS INTEGER     INITIAL 1 NO-UNDO.
DEFINE VARIABLE iY          AS INTEGER     INITIAL 1 NO-UNDO.
DEFINE VARIABLE j           AS INTEGER     NO-UNDO.

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day8.txt.
REPEAT:
    iX = 1.
    IMPORT UNFORMATTED cLine.
    DO i = 1 TO LENGTH(cLine):
        CREATE ttTree.
        ASSIGN ttTree.iHeight = INTEGER(SUBSTRING(cLine,i,1))
               ttTree.X       = iX
               ttTree.Y       = iY.
        iX = iX + 1.
    END.
    iY = iY + 1.
END.
INPUT CLOSE.
ASSIGN
    iMaxY = iY - 1
    iMaxX = iY - 1.

FOR EACH ttTree WHERE ttTree.X = 1 OR ttTree.X = iMaxX:
    ttTree.lVisible = YES.
END.
FOR EACH ttTree WHERE ttTree.Y = 1 OR ttTree.Y = iMaxX:
    ttTree.lVisible = YES.
END.
DO i = 2 TO iMaxY - 1:
    iPrevHeight = -1.
    DO j = 1 TO iMaxX:
        FIND ttTree WHERE X = j AND Y = i.
        IF ttTree.iHeight > iPrevHeight THEN DO:
            ASSIGN
             ttTree.lVisible = YES
             iPrevHeight     = ttTree.iHeight.
        END.
        IF iPrevHeight = 9 THEN LEAVE.
    END.
    iPrevHeight = -1.
    DO j = iMaxX TO 1 BY -1:
        FIND ttTree WHERE X = j AND Y = i.
        IF ttTree.iHeight > iPrevHeight THEN DO:
            ASSIGN
             ttTree.lVisible = YES
             iPrevHeight     = ttTree.iHeight.
        END.
        IF iPrevHeight = 9 THEN LEAVE.
    END.
END.
DO j = 2 TO iMaxX - 1:
    iPrevHeight = -1.
    DO i = 1 TO iMaxY:
        FIND ttTree WHERE X = j AND Y = i.
        IF ttTree.iHeight > iPrevHeight THEN DO:
            ASSIGN
             ttTree.lVisible = YES
             iPrevHeight     = ttTree.iHeight.
        END.
        IF iPrevHeight = 9 THEN LEAVE.
    END.
    iPrevHeight = -1.
    DO i = iMaxY TO 1 BY -1:
        FIND ttTree WHERE X = j AND Y = i.
        IF ttTree.iHeight > iPrevHeight THEN DO:
            ASSIGN
             ttTree.lVisible = YES
             iPrevHeight     = ttTree.iHeight.
        END.
        IF iPrevHeight = 9 THEN LEAVE.
    END.
END.
/*
DEFINE VARIABLE cMatrix AS CHARACTER   NO-UNDO.
DO i = 1 TO iMaxY:
    DO j = 1 TO iMaxX:
        FIND ttTree WHERE X = j AND Y = i.
        cMatrix = cMatrix + STRING(ttTree.lVisible,"1/0").
    END.
    cMatrix = cMatrix + "~n".
END.
*/

DEFINE VARIABLE iVisible AS INTEGER     NO-UNDO.
FOR EACH ttTree WHERE ttTree.lVisible = YES:
    iVisible = iVisible + 1.
END.

MESSAGE ETIME SKIP
    iVisible
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
196 
1711
---------------------------
OK   Aide   
---------------------------
*/
