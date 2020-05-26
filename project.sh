#!/bin/bash
set -e

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 <data_folder> (<sleep_interval>)"
  exit
fi
data_folder=$1
mkdir -p $data_folder
sleep_interval=${2:-300}

counter=$RANDOM
while true; do
  counter=$((counter + $RANDOM % 3 - 1))
  if [ -f data/$counter ]; then
    counter_hits=$(cat data/$counter)
    if ! echo "$counter_hits" | egrep -q '^[0-9]+$' ; then
      echo "Counter hits format is wrong: Integer value expected, got '$counter_hits'. Replace to 0" >&2
      counter_hits=0
    fi
  else
    counter_hits=0
  fi
  counter_hits=$((counter_hits+1))
  echo "Generated $counter. Hits: $counter_hits"
  echo "$counter_hits" > data/$counter
  sleep_time=$(($RANDOM % $sleep_interval + 1))
  echo "Sleeping for $sleep_time"
  sleep $sleep_time
done
