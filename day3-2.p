/*
--- Part Two ---

As you finish identifying the misplaced items, the Elves come to you with another issue.

For safety, the Elves are divided into groups of three. Every Elf carries a badge that identifies their group. For efficiency, within each group of three Elves, the badge is the only item type carried by all three Elves. That is, if a group's badge is item type B, then all three Elves will have item type B somewhere in their rucksack, and at most two of the Elves will be carrying any other item type.

The problem is that someone forgot to put this year's updated authenticity sticker on the badges. All of the badges need to be pulled out of the rucksacks so the new authenticity stickers can be attached.

Additionally, nobody wrote down which item type corresponds to each group's badges. The only way to tell which item type is the right one is by finding the one item type that is common between all three Elves in each group.

Every set of three lines in your list corresponds to a single group, but each group can have a different badge item type. So, in the above example, the first group's rucksacks are the first three lines:

vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg

And the second group's rucksacks are the next three lines:

wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw

In the first group, the only item type that appears in all three rucksacks is lowercase r; this must be their badges. In the second group, their badge item type must be Z.

Priorities for these items must still be found to organize the sticker attachment efforts: here, they are 18 (r) for the first group and 52 (Z) for the second group. The sum of these is 70.

Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?
*/

DEFINE VARIABLE cItemType   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOne        AS CHARACTER   CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE cSack       AS CHARACTER   CASE-SENSITIVE EXTENT 3 NO-UNDO.
DEFINE VARIABLE cTwo        AS CHARACTER   CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE i           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPriorities AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSmallest   AS INTEGER     NO-UNDO.
DEFINE VARIABLE j           AS INTEGER     NO-UNDO.
DEFINE VARIABLE lFound      AS LOGICAL     NO-UNDO.

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day3.txt.
blkElves:
REPEAT:
    IMPORT cSack[1].
    IMPORT cSack[2].
    IMPORT cSack[3].

    iSmallest = 1.
    IF LENGTH(cSack[2]) < LENGTH(cSack[iSmallest]) THEN iSmallest = 2.
    IF LENGTH(cSack[3]) < LENGTH(cSack[iSmallest]) THEN iSmallest = 3.

    DO i = 1 TO LENGTH(cSack[iSmallest]):
        cItemType = SUBSTRING(cSack[iSmallest], i, 1).
        IF INDEX(cSack[iSmallest], cItemType) < i THEN NEXT. /* already tested */
        lFound = YES.
        DO j = 1 TO 3.
            IF j = iSmallest THEN NEXT.
            lFound = lFound AND INDEX(cSack[j], cItemType) > 0.
        END.
        IF lFound THEN DO:
            iPriorities = iPriorities
                        + ASC(cItemType)
                           - IF ASC(cItemType) >= 97 THEN 96 ELSE 38.
            NEXT blkElves.
        END.
    END.

END.
INPUT CLOSE.

MESSAGE ETIME SKIP
    iPriorities
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
7 
2817
---------------------------
OK   Aide   
---------------------------
*/
