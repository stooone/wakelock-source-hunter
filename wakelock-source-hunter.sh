#!/bin/bash

SLEEP=30
WAKELOCK=IPA_WS



PARENT=$(dumpsys window windows | grep mCurrentFocus | cut -d'{' -f2 |cut -d' ' -f3 |cut -d'/' -f1)
echo -e "Parent app is ${PARENT}, will skip it during the tests.\n"

echo -e "I will count ${WAKELOCK} wakelocks during disabling apps one-by-one. But before I'll make some baseline with all apps enabled. Please wait...\n"

for i in $( seq 3 ); do

  echo -n "Baseline"
  BEFORE=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')

  sleep ${SLEEP}

  AFTER=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')

  COUNT=$(( ${AFTER} - ${BEFORE} ))
  echo " ${COUNT}"

done


while read LINE; do

  PACKAGE=${LINE#*:}

  if [ "$PACKAGE" == "$PARENT" ]; then
    continue
  fi


  echo -n ${PACKAGE} 
  BEFORE=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')
  pm disable ${PACKAGE} >/dev/null

  sleep ${SLEEP}

  AFTER=$(cat /sys/kernel/debug/wakeup_sources | grep ${WAKELOCK} |awk '{ print $2; }')
  pm enable ${PACKAGE} >/dev/null

  COUNT=$(( ${AFTER} - ${BEFORE} ))
  echo " ${COUNT}"
  
  # This sleep is for braking the script without stucking an app disabled
  sleep 5

done < <(pm list packages -3 -e)

