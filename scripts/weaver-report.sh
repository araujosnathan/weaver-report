#!/bin/bash

source dependencies/install_dependencies.sh
source dictionary/language.sh
source functional/testing_data.sh
source functional/setting_html.sh
source contract/endpoints_data.sh
source contract/setting_html.sh
source develop/unit_test.sh
source develop/info_html.sh
source historic/recent_sprints.sh
source historic/sprints_html.sh
source jira/jira_data.sh
source bugs/bug_data_html.sh
source bugs/metric_data.sh

function setup_envs()
{
  FILE_BUGS_JS="file_bugs.txt"
  FILE_BUGS_FLAGGED="file_bugs_flagged.txt"
  FILE_CURRENT_BUGS_METRIC="bugs_metric.txt"
  REPORT_NAME=$(cat config.yml | grep report_name | awk '{t=""; for(i=2;i<=NF;i++) t=t" "$i; print t}')
  PLATFORMS=$(cat config.yml | grep platforms | awk '{t=""; for(i=2;i<=NF;i++) t=t" "$i; print t}')
  PLATFORM_REPORT=""
  BUG_PLATFORM_REPORT=""
  CHART_INIT=""
  ALL_METRICS=""
  FILE_SPRINTS_BUGS="sprints_bugs.txt"
  FILE_SPRINT_BUGS_FLAGGED="bugs_flagged.txt"
  DOD=70
}


function check_tags_in_config_file
{
  
  
  check_tag_for_contract_test
  if [ "$STATUS_CONTRACT_TESTING" = "true" ]; then
    check_folder_of_contract_test
  fi
  check_tag_for_ios_unit_test
  if [ "$IOS_STATUS_UNIT_TEST" = "true" ]; then
    check_file_of_ios_unit_test
  fi
  check_tag_for_android_unit_test
  if [ "$ANDROID_STATUS_UNIT_TEST" = "true" ]; then
    check_file_of_android_unit_test
  fi
  check_tag_jira_android
  check_tag_jira_ios
}


function set_report_platform_menu
{
   PLATFORM_REPORT=$PLATFORM_REPORT$(echo "<li><a href="$REPORT_NAME-$PLATFORM_NAME.html">$PLATFORM_NAME</a></li>")
}

function get_all_functional_datas()
{
  setup_functional_envs

  get_all_features_from_testing_project
  
  i=1
  while read LINE
  do

    get_feature_name
    get_total_number_of_scenarios_by_feature_implemented 
    get_total_number_of_scenarios_implemented_from_project
    get_scenario_names_by_feature_implemented
    get_scenario_names_by_feature
    get_total_number_of_scenarios_by_feature
    get_total_number_of_scenarios_from_projet

      
    calculate_coverage_by_feature

    if [ $TOTAL_NUMBER_OF_SCENARIOS_BY_FEATURE -gt 0 ]; then  
      set_collapse_feature_html
        
      while read L 
      do 
        SCENARIO_NAME=$(cat $FILE_WITH_SCENARIO_NAMES_BY_FEATURE_IMPLEMENTED | grep "$L")
        if [ -z "$SCENARIO_NAME" ]; then
          set_scenarios_not_implemented_to_collapse_html
        else
          set_scenarios_implemented_to_collapse_html
        fi
      done < $FILE_WITH_SCENARIO_NAMES_BY_FEATURE

      rm -rf $FILE_WITH_SCENARIO_NAMES_BY_FEATURE
      rm -rf $FILE_WITH_SCENARIO_NAMES_BY_FEATURE_IMPLEMENTED

      set_end_html
    fi
    
    i=$(($i+1))
  done < $FILE_WITH_ALL_FEATURES

  calculate_project_coverage
  save_functional_test_metric
  
  rm -rf $FILE_WITH_ALL_FEATURES
 
}

function get_all_contract_datas()
{
  if [ "$STATUS_CONTRACT_TESTING" = "true" ]; then
    get_testing_files_name
    while read LINE
    do
      get_tested_endpoints_by_file
      get_contract_scenarios_by_file
    done < $FILE_WITH_TESTING_FILES_NAMES

    get_total_number_of_endpoints
    get_total_number_of_contract_scenarios
    remove_all_files_used_in_contract_module

    save_contract_metric
    echo "TOTAL NUMBER OF ENDPOINTS: "$TOTAL_NUMBER_OF_ENDPOINTS
    echo "TOTAL NUMBER OF CONTRACT SCENARIOS: "$TOTAL_NUMBER_OF_CONTRACT_SCENARIOS
  else
    TOTAL_NUMBER_OF_ENDPOINTS="N/A"
    TOTAL_NUMBER_OF_CONTRACT_SCENARIOS="N/A"
    save_contract_metric
  fi
}

function set_metrics_in_template()
{
  set_functional_test_data_in_html
  set_contract_test_data_in_html
  set_recent_sprints_data_in_html
}


function genenerate_report_by_platform()
{

  cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|REPORT_PLATFORM_NAME|${PLATFORM_REPORT}|" > report_tests.html

  
  CONTENT=$(echo $BUG_CONTROL | grep $PLATFORM_NAME)
  if [ ! -z  "$CONTENT" ];
  then
    
    cat report_tests.html | sed -e "s|BUGSCOMMENTEND|-->|" > report_tests_1.html
    cat report_tests_1.html | sed -e "s|BUGSCOMMENT|--|" > report_tests.html
    cat report_tests.html | sed -e "s|BUGS_PLATFORM_NAME|${BUG_PLATFORM_REPORT}|" > report_tests_1.html
    mv report_tests_1.html $REPORT_NAME-$PLATFORM_NAME.html
    cp $REPORT_NAME-$PLATFORM_NAME.html $REPORT_NAME/

    BUGS_FLAGGED_CONTENT=$(cat $FILE_BUGS_FLAGGED)
    BUGS_FLAGGED_CONTENT=`echo ${BUGS_FLAGGED_CONTENT} | tr '\n' "\\n"`

    cat chart-morris-$PLATFORM_NAME.html | sed -e "s|REPORT_PLATFORM_NAME|${PLATFORM_REPORT}|" > report_chart.html 
    cat report_chart.html | sed -e "s|BUGS_PLATFORM_NAME|${BUG_PLATFORM_REPORT}|" > report_chart_1.html
    set_chart_init
    cat report_chart_1.html | sed -e "s|CHART_BUG_INIT|${CHART_INIT}|" > report_chart.html
    cat report_chart.html | sed -e "s|LIST_FLAGGED_BUGS|${BUGS_FLAGGED_CONTENT}|" > report_chart_1.html
  
    rm -rf chart-morris-$PLATFORM_NAME.html

    mv report_chart_1.html chart-morris-$PLATFORM_NAME.html
  
    cp chart-morris-$PLATFORM_NAME.html $REPORT_NAME/
    
    rm -rf chart-morris-$PLATFORM_NAME.html
  
    rm -rf report_chart_1.html
    rm -rf report_chart.html
    rm -rf 
  else
    mv report_tests.html $REPORT_NAME-$PLATFORM_NAME.html
    cp $REPORT_NAME-$PLATFORM_NAME.html $REPORT_NAME/
  fi
  
  rm -rf $FILE_BUGS_FLAGGED
  rm -rf $REPORT_NAME-$PLATFORM_NAME.html
  cp ../template/index2.html ../template/index.html 
  rm -rf report_tests.html
  rm -rf report_tests_1.html
 

}

function generate_weaver_report
{
  REPORT_NAME=$(echo $REPORT_NAME | tr ' ' '_')
  if [ -d $REPORT_NAME ]; then
    rm -rf $REPORT_NAME
  fi
  mkdir $REPORT_NAME
  ALL_PLATFORMS=($(echo $PLATFORMS | tr "," "\n"))
  LENGHT=${#ALL_PLATFORMS[*]}
  count=0
  BUG_CONTROL=""
  while [ $count -lt $LENGHT ]; do
    PLATFORM_NAME=${ALL_PLATFORMS[$count]}
    
    ALL_METRICS=""
    ALL_METRICS=$PLATFORM_NAME
    ALL_METRICS=$ALL_METRICS" "$REPORT_NAME
   
    ALL_METRICS_BUGS=""

    if [ "$PLATFORM_NAME" = "ios" ];
    then
      get_unit_test_metric_ios
      save_ios_unit_test
      if [ "$JIRA_IOS" = "true" ];
      then
        BUG_CONTROL=$BUG_CONTROL"-"$PLATFORM_NAME
        ALL_METRICS_BUGS=$PLATFORM_NAME
        ALL_METRICS_BUGS=$ALL_METRICS_BUGS" "$REPORT_NAME
        python3 jira/main_ios.py
        set_bug_platform_menu
        get_current_bug_metric
        echo $ALL_METRICS_BUGS >> $FILE_SPRINTS_BUGS
        get_all_sprints_bugs
        set_chart_template
        set_recent_bugs_sprint_in_html
      fi
    elif [ "$PLATFORM_NAME" = "android" ];
    then
      get_unit_test_metric_android
      save_android_unit_test
      if [ "$JIRA_ANDROID" = "true" ];
      then
        BUG_CONTROL=$BUG_CONTROL"-"$PLATFORM_NAME
        ALL_METRICS_BUGS=$PLATFORM_NAME
        ALL_METRICS_BUGS=$ALL_METRICS_BUGS" "$REPORT_NAME
        python3 jira/main_android.py
        set_bug_platform_menu
        get_current_bug_metric
        echo $ALL_METRICS_BUGS >> $FILE_SPRINTS_BUGS
        get_all_sprints_bugs
        set_chart_template
        set_recent_bugs_sprint_in_html
      fi
    fi
    
    get_all_functional_datas
    get_all_contract_datas
    set_report_platform_menu
    
    echo $ALL_METRICS >> $FILE_WITH_RECENT_SPRINTS_METRICS
    get_recent_sprints_metrics
    set_metrics_in_template    
    let count++
    
  done
  
  count=0
  while [ $count -lt $LENGHT ]; do
    PLATFORM_NAME=${ALL_PLATFORMS[$count]}
    CONTENT=$(echo $BUG_CONTROL | grep $PLATFORM_NAME)
    if [ ! -z  "$CONTENT" ];
    then
      get_all_bugs_flagged
    fi
    genenerate_report_by_platform
    let count++

  done

  cp -r ../template/ $REPORT_NAME/
  rm -rf $REPORT_NAME/index.html
  rm -rf $REPORT_NAME/chart-morris.html
  rm -rf $REPORT_NAME/js/lib/morris-chart/morris-init.js
  
  count=0
  while [ $count -lt $LENGHT ]; do
    PLATFORM_NAME=${ALL_PLATFORMS[$count]}
    rm -rf ../template/js/lib/morris-chart/morris-init-$PLATFORM_NAME.js
    let count++
  done
  
  rm -rf $FILE_SPRINT_BUGS_FLAGGED
  rm -rf $FILE_CURRENT_BUGS_METRIC
  generate_feature_express
}


echo "Checking dependecies ..."
check_all_dependencies
echo "Generating Weaver Report ..."
setup_language $1
set_language_in_template
setup_envs
setup_functional_envs
setup_contract_envs
setup_develop_envs
setup_historic_envs
setup_jira_envs
check_tags_in_config_file
generate_weaver_report
echo "Weaver Report generated with successful!"

