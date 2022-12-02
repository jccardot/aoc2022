/*
--- Part Two ---

The Elf finishes helping with the tent and sneaks back over to you. "Anyway, the second column says how the round needs to end: X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"

The total score is still calculated in the same way, but now you need to figure out what shape to choose so the round ends as indicated. The example above now goes like this:

    In the first round, your opponent will choose Rock (A), and you need the round to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3 = 4.
    In the second round, your opponent will choose Paper (B), and you choose Rock so you lose (X) with a score of 1 + 0 = 1.
    In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7.

Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of 12.

Following the Elf's instructions for the second column, what would your total score be if everything goes exactly according to your strategy guide?
*/

&GLOBAL-DEFINE xiScoreX 1
&GLOBAL-DEFINE xiScoreY 2
&GLOBAL-DEFINE xiScoreZ 3
&GLOBAL-DEFINE xiLost   0
&GLOBAL-DEFINE xiDraw   3
&GLOBAL-DEFINE xiWon    6

DEFINE VARIABLE cABC   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cXYZ   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iScore AS INTEGER     NO-UNDO.

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day2.txt.
REPEAT:
    IMPORT cABC cXYZ.
    CASE cXYZ:
        WHEN "X" THEN /* lose */
            CASE cABC:
                WHEN "A" THEN iScore = iScore + {&xiScoreZ} + {&xiLost}.
                WHEN "B" THEN iScore = iScore + {&xiScoreX} + {&xiLost}.
                WHEN "C" THEN iScore = iScore + {&xiScoreY} + {&xiLost}.
            END CASE.
        WHEN "Y" THEN /* draw */
            CASE cABC:
                WHEN "A" THEN iScore = iScore + {&xiScoreX} + {&xiDraw}.
                WHEN "B" THEN iScore = iScore + {&xiScoreY} + {&xiDraw}.
                WHEN "C" THEN iScore = iScore + {&xiScoreZ} + {&xiDraw}.
            END CASE.
        WHEN "Z" THEN /* win */
            CASE cABC:
                WHEN "A" THEN iScore = iScore + {&xiScoreY} + {&xiWon}.
                WHEN "B" THEN iScore = iScore + {&xiScoreZ} + {&xiWon}.
                WHEN "C" THEN iScore = iScore + {&xiScoreX} + {&xiWon}.
            END CASE.
    END CASE.
END.
INPUT CLOSE.

MESSAGE ETIME SKIP
    iScore
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
9 
14859
---------------------------
OK   Aide   
---------------------------
*/
