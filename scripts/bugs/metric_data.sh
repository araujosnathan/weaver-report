#!/bin/bash

function get_all_sprints_bugs()
{
  cat $FILE_SPRINTS_BUGS | grep $PLATFORM_NAME >> sprint_historic.txt
  COUNT=$(cat $FILE_SPRINTS_BUGS | grep "$PLATFORM_NAME" | wc -l)
  MAX=1
  while read LINE 
  do
    REPORT_NAME_LABEL=$(echo $LINE | awk '{print $2}')
    BACKLOG_NUMBER=$(echo $LINE | awk '{print $3}')
    BUG_FIXED_NUMBER=$(echo $LINE | awk '{print $4}')
    BUG_FLAGGED_NUMBER=$(echo $LINE | awk '{print $5}')
    set_bugs_sprints_js
    let MAX++
  done < sprint_historic.txt

  rm -rf sprint_historic.txt
 
}

function get_current_bug_metric(){
  
  cat $FILE_CURRENT_BUGS_METRIC | grep "$PLATFORM_NAME" >> sprint_historic.txt
  while read LINE 
  do
    BACKLOG_CURRENT=$(echo $LINE | awk '{print $2}')
    FIXED_CURRENT=$(echo $LINE | awk '{print $3}')
    FLAGGED_CURRENT=$(echo $LINE | awk '{print $4}')
  done < sprint_historic.txt
  ALL_METRICS_BUGS=$ALL_METRICS_BUGS" "$BACKLOG_CURRENT" "$FIXED_CURRENT" "$FLAGGED_CURRENT
  rm -rf sprint_historic.txt
}
