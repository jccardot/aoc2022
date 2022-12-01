/*
--- Part Two ---

By the time you calculate the answer to the Elves' question, they've already realized that the Elf carrying the most Calories of food might eventually run out of snacks.

To avoid this unacceptable situation, the Elves would instead like to know the total Calories carried by the top three Elves carrying the most Calories. That way, even if one of those Elves runs out of snacks, they still have two backups.

In the example above, the top three Elves are the fourth Elf (with 24000 Calories), then the third Elf (with 11000 Calories), then the fifth Elf (with 10000 Calories). The sum of the Calories carried by these three elves is 45000.

Find the top three Elves carrying the most Calories. How many Calories are those Elves carrying in total?
*/

DEFINE VARIABLE cLine     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCalories AS INTEGER     NO-UNDO.
DEFINE VARIABLE iElve     AS INTEGER     INITIAL 1 NO-UNDO.

DEFINE TEMP-TABLE ttElve NO-UNDO LABEL ""
 FIELD iElve AS INTEGER
 FIELD iCalories AS INTEGER
 INDEX ix iCalories DESCENDING.

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day1.txt.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine = "" THEN DO:
        CREATE ttElve.
        ASSIGN ttElve.iElve = iElve
               ttElve.iCalories = iCalories.
        ASSIGN iElve     = iElve + 1
               iCalories = 0.
        NEXT.
    END.
    iCalories = iCalories + INTEGER(cLine).
END.
INPUT CLOSE.

iCalories = 0.
iElve = 0.
FOR EACH ttElve:
    iCalories = iCalories + ttElve.iCalories.
    iElve = iElve + 1.
    IF iElve > 2 THEN LEAVE.
END.

MESSAGE ETIME SKIP
    iCalories
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
25 
200945
---------------------------
OK   Aide   
---------------------------
*/
