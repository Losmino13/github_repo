#!/bin/bash
NUMBER_OF_ROUNDS=$1
INITIAL_BET=$2
TIMES_A_DAY=$3

DAYS=30
AVERAGE_ODD="3"
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


echo "##################################################"

SUM_OF_INPUT="0"
POTENTIAL_WIN="0"

ITERATE=`echo "$((DAYS*TIMES_A_DAY))" | bc`
while [[ i -lt $ITERATE ]]
do
  r=$(( $RANDOM %2 ))
  if [ "$r" -eq "0" ]
  then
  WIN=`echo "$INITIAL_BET*$AVERAGE_ODD" | bc`
  POTENTIAL_WIN=`echo "$POTENTIAL_WIN+$WIN" | bc`
  fi
  ((i = i + 1))
done

BET1=`echo "$ITERATE*$INITIAL_BET" | bc`

echo "Potential BET $BET1"
echo "Potential WIN $POTENTIAL_WIN"