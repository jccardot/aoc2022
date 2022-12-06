/*
--- Part Two ---

Your device's communication system is correctly detecting packets, but still isn't working. It looks like it also needs to look for messages.

A start-of-message marker is just like a start-of-packet marker, except it consists of 14 distinct characters rather than 4.

Here are the first positions of start-of-message markers for all of the above examples:

    mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
    bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
    nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26

How many characters need to be processed before the first start-of-message marker is detected?
*/

DEFINE VARIABLE cLine AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSOP  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iPos  AS INTEGER     INITIAL 1 NO-UNDO.

&GLOBAL-DEFINE xiMarkerLength 14

FUNCTION allDifferentChars RETURNS LOGICAL ( cStr AS CHARACTER ):
    /* First, naive implementation
    DEFINE VARIABLE cChar AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j     AS INTEGER     NO-UNDO.
    DO i = 1 TO 14:
        cChar = SUBSTRING(cStr,i,1).
        DO j = 1 TO 14:
            IF i = j THEN NEXT.
            IF SUBSTRING(cStr,j,1) = cChar THEN RETURN FALSE.
        END.
    END.
    RETURN TRUE.
    */
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    DO i = 1 TO {&xiMarkerLength}:
        IF LENGTH(REPLACE(cStr, SUBSTRING(cStr,i,1),"")) < {&xiMarkerLength} - 1 THEN RETURN FALSE.
    END.
    RETURN TRUE.
END FUNCTION.

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day6.txt.
IMPORT UNFORMATTED cLine.
INPUT CLOSE.

cSOP = SUBSTRING(cLine,iPos,{&xiMarkerLength}).
DO WHILE NOT allDifferentChars(cSOP):
    iPos = iPos + 1.
    cSOP = SUBSTRING(cLine,iPos,{&xiMarkerLength}).
END.

MESSAGE ETIME SKIP
    iPos + {&xiMarkerLength} - 1
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
64 
3697
---------------------------
OK   Aide   
---------------------------
*/
