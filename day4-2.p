/*
--- Part Two ---

It seems like there is still quite a bit of duplicate work planned. Instead, the Elves would like to know the number of pairs that overlap at all.

In the above example, the first two pairs (2-4,6-8 and 2-3,4-5) don't overlap, while the remaining four pairs (5-7,7-9, 2-8,3-7, 6-6,4-6, and 2-6,4-8) do overlap:

    5-7,7-9 overlaps in a single section, 7.
    2-8,3-7 overlaps all of the sections 3 through 7.
    6-6,4-6 overlaps in a single section, 6.
    2-6,4-8 overlaps in sections 4, 5, and 6.

So, in this example, the number of overlapping assignment pairs is 4.

In how many assignment pairs do the ranges overlap?
*/

DEFINE VARIABLE cPair1   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPair2   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iFrom1   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFrom2   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iOverlap AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTo1     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTo2     AS INTEGER     NO-UNDO.

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day4.txt.
blkLine:
REPEAT:
    IMPORT DELIMITER "," cPair1 cPair2.
    ASSIGN
        iFrom1 = INTEGER(ENTRY(1, cPair1, "-"))
        iTo1   = INTEGER(ENTRY(2, cPair1, "-"))
        iFrom2 = INTEGER(ENTRY(1, cPair2, "-"))
        iTo2   = INTEGER(ENTRY(2, cPair2, "-")).
    IF    iFrom1 >= iFrom2 AND iFrom1 <= iTo2 
       OR iTo1 >= iFrom2 AND iTo1 <= iTo2
       OR iFrom2 >= iFrom1 AND iFrom2 <= iTo1 
       OR iTo2 >= iFrom1 AND iTo2 <= iTo1
        THEN
        iOverlap = iOverlap + 1.
END.
INPUT CLOSE.

MESSAGE ETIME SKIP
    iOverlap
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
6 
909
---------------------------
OK   Aide   
---------------------------
*/
