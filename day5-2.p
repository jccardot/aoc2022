/*
--- Part Two ---

As you watch the crane operator expertly rearrange the crates, you notice the process isn't following your prediction.

Some mud was covering the writing on the side of the crane, and you quickly wipe it away. The crane isn't a CrateMover 9000 - it's a CrateMover 9001.

The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, an extra cup holder, and the ability to pick up and move multiple crates at once.

Again considering the example above, the crates begin in the same configuration:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

Moving a single crate from stack 2 to stack 1 behaves the same as before:

[D]        
[N] [C]    
[Z] [M] [P]
 1   2   3 

However, the action of moving three crates from stack 1 to stack 3 means that those three moved crates stay in the same order, resulting in this new configuration:

        [D]
        [N]
    [C] [Z]
    [M] [P]
 1   2   3

Next, as both crates are moved from stack 2 to stack 1, they retain their order as well:

        [D]
        [N]
[C]     [Z]
[M]     [P]
 1   2   3

Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:

        [D]
        [N]
        [Z]
[M] [C] [P]
 1   2   3

In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.

Before the rearrangement process finishes, update your simulation so that the Elves know where they should stand to be ready to unload the final supplies. After the rearrangement procedure completes, what crate ends up on top of each stack?
*/

/*                                   
        [M]     [B]             [N]
[T]     [H]     [V] [Q]         [H]
[Q]     [N]     [H] [W] [T]     [Q]
[V]     [P] [F] [Q] [P] [C]     [R]
[C]     [D] [T] [N] [N] [L] [S] [J]
[D] [V] [W] [R] [M] [G] [R] [N] [D]
[S] [F] [Q] [Q] [F] [F] [F] [Z] [S]
[N] [M] [F] [D] [R] [C] [W] [T] [M]
 1   2   3   4   5   6   7   8   9 
*/

DEFINE VARIABLE cDummy  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cStack  AS CHARACTER   EXTENT 9 NO-UNDO.
DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFrom   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLength AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMove   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTo     AS INTEGER     NO-UNDO.

ASSIGN
    cStack[1] = "NSDCVQT"
    cStack[2] = "MFV"
    cStack[3] = "FQWDPNHM"
    cStack[4] = "DQRFT"
    cStack[5] = "RFMNQHVB"
    cStack[6] = "CFGNPWQ"
    cStack[7] = "WFRLCT"
    cStack[8] = "TZNS"
    cStack[9] = "MSDJRQHN"
    .

ETIME(TRUE).
    
INPUT FROM C:\Work\aoc\aoc2022\day5.txt.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine = "" THEN LEAVE.
END.
REPEAT:
    IMPORT cDummy iMove cDummy iFrom cDummy iTo. /* move 1 from 8 to 7 */
    iLength = LENGTH(cStack[iFrom]).
    cStack[iTo] = cStack[iTo] + SUBSTRING(cStack[iFrom], iLength - iMove + 1, iMove).
    cStack[iFrom] = SUBSTRING(cStack[iFrom], 1, iLength - iMove).
END.
INPUT CLOSE.
DO i = 1 TO 9:
    cResult = cResult + SUBSTRING(cStack[i], LENGTH(cStack[i]), 1).
END.

MESSAGE ETIME SKIP
    cResult 
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
---------------------------
Renseignement (Press HELP to view stack trace)
---------------------------
2 
HRTFQVWNN
---------------------------
OK   Aide   
---------------------------
*/
