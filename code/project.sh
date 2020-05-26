#!/bin/bash
set -e

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 <generated_data_folder> (<sleep_interval>)"
  exit
fi
generated_data_folder=$1
mkdir -p $generated_data_folder
sleep_interval=${2:-300}

counter=$RANDOM
while true; do
  counter=$((counter + $RANDOM % 3 - 1))
  if [ -f $generated_data_folder/$counter ]; then
    counter_hits=$(cat $generated_data_folder/$counter)
    if ! echo "$counter_hits" | egrep -q '^[0-9]+$' ; then
      echo "Counter hits format is wrong: Integer value expected, got '$counter_hits'. Replace to 0" >&2
      counter_hits=0
    fi
  else
    counter_hits=0
  fi
  counter_hits=$((counter_hits+1))
  echo "Generated $counter. Hits: $counter_hits"
  echo "$counter_hits" > $generated_data_folder/$counter
  sleep_time=$(($RANDOM % $sleep_interval + 1))
  echo "Sleeping for $sleep_time"
  sleep $sleep_time
done
