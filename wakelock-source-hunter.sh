#!/bin/bash

#pm list packages -3 -e > packages.txt

SLEEP=30
WAKELOCK=IPA_WS

for i in $( seq 3 ); do

  BEFORE=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')

  sleep ${SLEEP}

  AFTER=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')

  COUNT=$(( ${AFTER} - ${BEFORE} ))
  echo "baseline ${COUNT}"

done


while read LINE; do

  PACKAGE=${LINE#*:}

  echo -n ${PACKAGE} 
  BEFORE=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')
  pm disable ${PACKAGE} >/dev/null

  sleep ${SLEEP}

  AFTER=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')
  pm enable ${PACKAGE} >/dev/null

  COUNT=$(( ${AFTER} - ${BEFORE} ))
  echo " ${COUNT}"
  sleep 5

done < <(cat packages.txt)
