# U prilogu se nalazi lista fajlova u formatu 'kABCDEFGH.kod' gde je ABCDEFGH broj u heksadecimalnom formatu, npr. k000ccf3b.kod .

# Zadatak 1: Potrebno je napraviti bash skript koji će u lokalnom direktorijumu:

# 1. Kreirati prazne fajlove sa nazivima iz liste
# 2. Proveriti za svaki fajl da li mu je naziv u zadatom formatu i prikazati neispravne nazive fajlova
# 3. Napraviti potrebne poddirektorijume i u njih rasporediti fajlove po sledećem šablonu:
#     - Fajl kABCDEFGH.kod treba prebaciti u direktorijum G0/E0 , ako je G paran broj
#     - Fajl kABCDEFGH.kod treba prebaciti u direktorijum X0/E0 , gde je X=G-1 , ako je G neparan broj
#      Na primer, fajl k000ccf3b.kod treba prebaciti u folder 20/c0, fajl k000cde67.kod treba prebaciti u folder 60/d0 .
#      Fajlove čiji naziv nije u zadatom formatu treba ignorisati.

#!/usr/bin/env bash
echo "This script will parse prilog.txt and do the need as written in comment at the script begining"

BASEDIR=`pwd`
INPUT_PRILOG=$1
HEX_VALUE=()
for i in $(cat $INPUT_PRILOG)
do
  if [ `uname -s` = "Darwin" ]; then
    file=`echo $i | tr '\r' '\n'`
    touch $file
  else
    touch $i
  fi
  HEX_CALC=`echo $i | sed 's/k//' | awk -F"." '{print $1"\n"}'`
  if [[ $HEX_CALC =~ ^[A-Fa-f0-9]+$ ]]; then 
   HEX_VALUE+=( "$HEX_CALC" )
  else
    echo "Invalid file"
    echo `pwd`"/$i"
  fi
done
#echo ${HEX_VALUE[@]}
for j in "${HEX_VALUE[@]}"
do
  # if [ $(( 16#$j )) ]; then
  #   echo valid
  # fi
  STR_LENGTH=`echo $j | awk '{print length}'`
  if [ $STR_LENGTH == 8 ]; then
    G=`echo ${j:6:1}`
    E=`echo ${j:4:1}`
    if [[ $G =~ ^[0-9] ]]; then
      if [[ $((G%2)) -eq 0 ]]; then
        #echo $G
        #echo $E
        #echo ${G}0/${E}0
        mkdir -p ${G}0/${E}0
        mv k${j}.kod ${G}0/${E}0
      else
        X=`echo ${G}-1 | bc`
        #echo ${X}0/${E}0
        mv k${j}.kod ${X}0/${E}0
      fi
    fi
  fi
  #break
done