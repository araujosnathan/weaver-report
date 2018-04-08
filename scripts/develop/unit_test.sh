#!/bin/bash

function setup_develop_envs
{
    IOS_UNIT_TEST_REPORT=$(cat config.yml | grep ios_unit_test_report | awk '{print $2}')
    ANDROID_UNIT_TEST_REPORT=$(cat config.yml | grep android_unit_test_report | awk '{print $2}')
    UNIT_TEST_DEFINITION_OF_DONE_TARGET=70
}

function check_tag_for_ios_unit_test
{
    CONTENT=$(cat config.yml | grep ios_unit_test_report)
    if [ -z "$CONTENT" ]; then
      CONTENT_FILE=$(cat config.yml)
      if [[ $CONTENT_FILE =~ "ios_" || $CONTENT_FILE =~ "ios_unit" || $CONTENT_FILE =~ "ios_unit_tes" || $CONTENT_FILE =~ "ios_unit_test_rep" ]]; then
        echo -e "\033[33;1mDo you mean? ios_unit_test_report\033[m"
        exit 1
      else
        IOS_STATUS_UNIT_TEST="false"
      fi
    else
      IOS_STATUS_UNIT_TEST="true"
    fi
}

function check_tag_for_android_unit_test
{
    CONTENT=$(cat config.yml | grep android_unit_test_report)
    if [ -z "$CONTENT" ]; then
      CONTENT_FILE=$(cat config.yml)
      if [[ $CONTENT_FILE =~ "android_" || $CONTENT_FILE =~ "android_unit" || $CONTENT_FILE =~ "android_unit_tes" || $CONTENT_FILE =~ "android_unit_test_rep" ]]; then
        echo -e "\033[33;1mDo you mean? android_unit_test_report\033[m"
        exit 1
      else
        ANDROID_STATUS_UNIT_TEST="false"
      fi
    else
      ANDROID_STATUS_UNIT_TEST="true"
    fi
}


function check_file_of_ios_unit_test
{
    if [ ! -f "$IOS_UNIT_TEST_REPORT" ]; then
        echo -e "\033[31;1mFile not found in: '$IOS_UNIT_TEST_REPORT' in tag: 'ios_unit_test_report'. \nPlease, set a correct path to unit test file or remove this tag from config.yml \033[m"
        exit 1
    fi
}

function check_file_of_android_unit_test
{
    if [ ! -f "$ANDROID_UNIT_TEST_REPORT" ]; then
        echo -e "\033[31;1mFile not found in: '$ANDROID_UNIT_TEST_REPORT' in tag: 'android_unit_test_report'. \nPlease, set a correct path to unit test file or remove this tag from config.yml \033[m"
        exit 1
    fi
}


function get_unit_test_metric_ios()
{
    if [ "$IOS_STATUS_UNIT_TEST" = "true" ]; then
        IOS_UNIT_TEST_COVERAGE=$(cat $IOS_UNIT_TEST_REPORT | grep -o  "\"total_coverage\">[^']*" | grep -o [0-9]*.[0-9]*%)
        IOS_UNIT_TEST_COVERAGE=$(echo $IOS_UNIT_TEST_COVERAGE | tr '%' ' ')
    else
        IOS_UNIT_TEST_COVERAGE="N/A"
    fi
}

function get_unit_test_metric_android()
{  
    if [ "$ANDROID_STATUS_UNIT_TEST" = "true" ]; then
        ANDROID_UNIT_TEST_COVERAGE=$(cat $ANDROID_UNIT_TEST_REPORT | grep Total | grep -o  "\"ctr2\">[^']*" | grep -o [0-9]*.[0-9]*% | head -1)
        ANDROID_UNIT_TEST_COVERAGE=$(echo $ANDROID_UNIT_TEST_COVERAGE | tr '%' ' ' | tr '>' ' ')
    else
        ANDROID_UNIT_TEST_COVERAGE="N/A"
    fi
}

function save_ios_unit_test()
{
    ALL_METRICS=$ALL_METRICS" "$IOS_UNIT_TEST_COVERAGE
}

function save_android_unit_test()
{
    ALL_METRICS=$ALL_METRICS" "$ANDROID_UNIT_TEST_COVERAGE
}


