#!/bin/bash

SLEEP=30
WAKELOCK=IPA_WS



PARENT=$(dumpsys window windows | grep mCurrentFocus | cut -d'{' -f2 |cut -d' ' -f3 |cut -d'/' -f1)
echo -e "Parent app is ${PARENT}, will skip it during the tests.\n"

if [ ! -e /sys/kernel/debug/wakeup_sources ]; then
  echo "Error: can't find the wakeup_sources file."
  exit 1
fi

if ! grep ${WAKELOCK} /sys/kernel/debug/wakeup_sources >/dev/null; then
  echo "Error: you have selected the ${WAKELOCK} to hunt down, but your phone doesn't have this wakelock. Please edit this script and select another wakelock."
  exit 1
fi

echo -e "I will count ${WAKELOCK} wakelocks during disabling apps one-by-one. But before I'll make some baseline with all apps enabled. Please wait...\n"

for i in $( seq 3 ); do

  printf "Baseline ..."
  BEFORE=$(grep ${WAKELOCK} /sys/kernel/debug/wakeup_sources |awk '{ print $2; }')

  sleep ${SLEEP}

  AFTER=$(grep ${WAKELOCK} /sys/kernel/debug/wakeup_sources | awk '{ print $2; }')

  COUNT=$(( AFTER - BEFORE ))
  printf "\r%10d baseline\n" ${COUNT}

done


pm list packages -3 -e | while read -r LINE; do

  PACKAGE=${LINE#*:}

  if [ "$PACKAGE" == "$PARENT" ]; then
    continue
  fi


  printf "%s ..." ${PACKAGE}
  BEFORE=$(grep ${WAKELOCK} /sys/kernel/debug/wakeup_sources | awk '{ print $2; }')
  pm disable ${PACKAGE} >/dev/null

  sleep ${SLEEP}

  AFTER=$(grep ${WAKELOCK} /sys/kernel/debug/wakeup_sources | awk '{ print $2; }')
  pm enable ${PACKAGE} >/dev/null

  COUNT=$(( AFTER - BEFORE ))
  printf "\r%10d %s\n" ${COUNT} ${PACKAGE}
  
  # This sleep is for braking the script without stucking an app disabled
  sleep 5

done

