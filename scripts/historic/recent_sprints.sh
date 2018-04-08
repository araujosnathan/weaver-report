#!/bin/bash

source historic/sprints_html.sh

function setup_historic_envs
{
    FILE_WITH_RECENT_SPRINTS_METRICS="recent_sprints_metrics.txt"
    FILE_WITH_METRICS_BY_PLATFORM="recent_sprint_by_platform.txt"
    FILE_METRICS_HTML="file_metrics_html.txt"
}

function get_recent_sprints_metrics
{
  cat $FILE_WITH_RECENT_SPRINTS_METRICS | sort -rn -k 1 | grep "$PLATFORM_NAME" >> $FILE_WITH_METRICS_BY_PLATFORM
  while read LINE 
  do
    REPORT_NAME_LABEL=$(echo $LINE | awk '{print $2}')
    UNIT_TEST_COVERAGE=$(echo $LINE | awk '{print $3}')
    FUNCTIONAL_TEST_COVERAGE=$(echo $LINE | awk '{print $4}')
    CONTRACT_TEST_COVERAGE=$(echo $LINE | awk '{print $5}')
    set_recent_metrics_sprint_html
  done < $FILE_WITH_METRICS_BY_PLATFORM

  rm -rf $FILE_WITH_METRICS_BY_PLATFORM
 
}

function set_recent_sprints_data_in_html
{
  FILE_SPRINTS=$(cat $FILE_METRICS_HTML)
  FILE_SPRINTS=`echo ${FILE_SPRINTS} | tr '\n' "\\n"`

  cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|ALL_SPRINTS_METRICS|${FILE_SPRINTS}|" > report_tests.html
  
  rm -rf $REPORT_NAME-$PLATFORM_NAME.html
  mv report_tests.html $REPORT_NAME-$PLATFORM_NAME.html
  rm -rf $FILE_METRICS_HTML
}