#!/bin/bash

NUMBER_OF_ROUNDS=$1
INITIAL_BET=$2
AVERAGE_ODD="2.5"
SUM_OF_INPUT="0"
BET=$INITIAL_BET
EXP=0

for i in $(seq 1 $NUMBER_OF_ROUNDS)
do
ROUND=$i
echo Round $ROUND...

echo -e "bet: $BET"

POTENTIAL_WIN=`echo "$BET*$AVERAGE_ODD" | bc`
echo -e "Potential win: $POTENTIAL_WIN"

SUM_OF_INPUT=`echo "$BET+$SUM_OF_INPUT" | bc`

NEXT_BET=`echo "$INITIAL_BET*(2^$i)" | bc`
EXP=$((EXP++))
BET=$NEXT_BET

done

echo "Sum of input = $SUM_OF_INPUT"