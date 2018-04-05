#!/bin/bash

function setup_functional_envs()
{
  PATH_TO_FEATURES=$(cat config.yml | grep path_to_features | awk '{print $2}')
  PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS=$(cat config.yml | grep path_to_official_document_of_scenarios | awk '{print $2}')
}

function get_all_features_from_testing_project
{
  FILE_WITH_ALL_FEATURES="features_from_testing_project.txt"
  if [ ! -d $PATH_TO_FEATURES ]; then
    echo -e "\033[31;1mDo not exist any folder: $PATH_TO_FEATURES \nPlease, set correct folder in config.yml!\033[m"
    exit 1
  else
    CONTENT=$(ls $PATH_TO_FEATURES | grep '.feature')
    if [ -z "$CONTENT" ]; then
      echo -e "\033[31;1mDo not exist any feature in folder: $PATH_TO_FEATURES \nPlease, set correct folder in config.yml!\033[m"
      exit 1
    else
      ls $PATH_TO_FEATURES | grep '.feature' >> $FILE_WITH_ALL_FEATURES
    fi
  fi
}

function get_feature_name
{
    FEATURE_NAME=$(cat $PATH_TO_FEATURES$LINE   | grep 'Funcionalidade:\|Feature:' | awk '{t=""; for(i=2;i<=NF;i++) t=t" "$i; print t}')
    FEATURE_NAME=`echo $FEATURE_NAME`
}

function get_total_number_of_scenarios_by_feature
{
    if [ -z "$PLATFORM_NAME" ]; then
        SCENARIOS_TOTAL_BY_FEATURE=0
    else
        CONTENT=$(cat $PATH_TO_FEATURES$LINE  | grep @$PLATFORM_NAME)
        if [ -z "$CONTENT" ]; then
            echo -e "\033[31;1mThe Platform name tag: $PLATFORM_NAME was not found in '.feature' files. \nPlease, set correct platform name in config.yml and/or add this tag for all scenarios already implemented!\033[m"
            exit 1
        else
            SCENARIOS_TOTAL_BY_FEATURE=$(cat $PATH_TO_FEATURES$LINE  | grep @$PLATFORM_NAME -A1 | grep 'Cenário:\|Cenario:\|Scenario:' | wc -l)
            SCENARIOS_TOTAL_BY_FEATURE=$(echo $SCENARIOS_TOTAL_BY_FEATURE | tr -d ' ')
        fi
    fi
}

function get_total_number_of_scenarios_from_project
{
  SCENARIOS_TOTAL_OF_PROJECT=$(($SCENARIOS_TOTAL_OF_PROJECT+$SCENARIOS_TOTAL_BY_FEATURE))
}

function get_scenario_names_by_feature
{
    FILE_WITH_SCENARIO_NAMES_BY_FEATURE="scenarios.txt"
    if [ -z "$PLATFORM_NAME" ]; then
        echo "EmptyFile" >> $FILE_WITH_SCENARIO_NAMES_BY_FEATURE
    else    
        cat $PATH_TO_FEATURES$LINE  | grep @$PLATFORM_NAME -A1 | grep "Cenário:\|Cenario:\|Scenario:" >> $FILE_WITH_SCENARIO_NAMES_BY_FEATURE
    fi
}

function get_total_number_of_scenarios_from_official_document_by_feature
{
   TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE=$(cat $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS | grep $FEATURE_NAME | wc -l)
   TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE=$(echo $TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE | tr -d ' ')
}

function get_scenario_names_from_official_document
{
  FILE_WITH_SCENARIO_NAMES_FROM_OFFICIAL_DOCUMENT="scenario_doc.txt"
  cat $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS | grep $FEATURE_NAME | awk -F"\t" '{print $3}' >> $FILE_WITH_SCENARIO_NAMES_FROM_OFFICIAL_DOCUMENT
}

function calculate_coverage_by_feature
{
  COVERAGE_BY_FEATURE=$((($SCENARIOS_TOTAL_BY_FEATURE*100)/$TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE))
}

function get_total_number_of_scenarios_from_official_document
{
  TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT=$(cat $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS | wc -l)
  TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT=$(echo $TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT | tr -d ' ')
}

function calculate_project_coverage
{
  PROJECT_COVERAGE=$(echo $SCENARIOS_TOTAL_OF_PROJECT 100 $TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT | awk '{print ($1*$2) / $3}')
  PROJECT_COVERAGE=$(printf %.2f $PROJECT_COVERAGE)
  PROJECT_COVERAGE=$(echo $PROJECT_COVERAGE | tr "," ".")
}