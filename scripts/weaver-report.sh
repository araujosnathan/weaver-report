#!/bin/bash

source functional/testing_data.sh
source functional/setting_html.sh
source contract/endpoints_data.sh
source contract/setting_html.sh
source develop/unit_test.sh
source develop/info_html.sh
source historic/recent_sprints.sh
source historic/sprints_html.sh
source jira/jira_data.sh

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
  check_tag_jira_server
}


function set_report_platform_menu
{
   PLATFORM_REPORT=$PLATFORM_REPORT$(echo "<li><a href="$REPORT_NAME-$PLATFORM_NAME.html">$PLATFORM_NAME</a></li>")
}

# function set_bug_platform_menu
# {
  
#    BUG_PLATFORM_REPORT=$BUG_PLATFORM_REPORT$(echo "<li><a href="chart-morris-$PLATFORM_NAME.html">Bugs $PLATFORM_NAME</a></li>")
# }

# function set_chart_init
# {
#   CHART_INIT=$(echo "<script src="js/lib/morris-chart/morris-init-$PLATFORM_NAME.js"></script>")
# }

# function set_bugs_flagged_chart
# {
#   echo "<div class='recent-comment'>" >> $FILE_BUGS_FLAGGED
#   echo "<div class='media'>" >> $FILE_BUGS_FLAGGED
#   echo "<div class='media-left'>" >> $FILE_BUGS_FLAGGED
#   echo "<a href='#'><img alt='...' src='images/report_bug_flagged.png' class='media-object'></a>" >> $FILE_BUGS_FLAGGED
#   echo "</div>" >> $FILE_BUGS_FLAGGED
#   echo "<div class='media-body'>" >> $FILE_BUGS_FLAGGED
#   echo "<h4 class='media-heading'>$BUG_TICKET</h4>" >> $FILE_BUGS_FLAGGED
#   echo "<p>$BUG_TITLE</p>" >> $FILE_BUGS_FLAGGED
#   echo "</div>" >> $FILE_BUGS_FLAGGED
#   echo "</div>" >> $FILE_BUGS_FLAGGED
#   echo "</div>" >> $FILE_BUGS_FLAGGED
# }

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


# function set_bugs_sprints_js()
# {
#   echo "{" >> $FILE_BUGS_JS
#   echo "s: '$REPORT_NAME_LABEL'," >> $FILE_BUGS_JS
# 	echo "bl: $BACKLOG_NUMBER," >> $FILE_BUGS_JS
# 	echo "fx: $BUG_FIXED_NUMBER," >> $FILE_BUGS_JS
# 	echo "fl: $BUG_FLAGGED_NUMBER" >> $FILE_BUGS_JS
#   if [ $COUNT -gt 1 ] && [ $MAX -lt $COUNT ];
#   then
#     echo "}," >> $FILE_BUGS_JS
#   else
#     echo "}" >> $FILE_BUGS_JS
#   fi
# }

# function get_all_sprints_bugs()
# {
#   cat $FILE_SPRINTS_BUGS | grep $PLATFORM_NAME >> sprint_historic.txt
#   COUNT=$(cat $FILE_SPRINTS_BUGS | grep "$PLATFORM_NAME" | wc -l)
#   MAX=1
#   while read LINE 
#   do
#     REPORT_NAME_LABEL=$(echo $LINE | awk '{print $2}')
#     BACKLOG_NUMBER=$(echo $LINE | awk '{print $3}')
#     BUG_FIXED_NUMBER=$(echo $LINE | awk '{print $4}')
#     BUG_FLAGGED_NUMBER=$(echo $LINE | awk '{print $5}')
#     set_bugs_sprints_js
#     let MAX++
#   done < sprint_historic.txt

#   rm -rf sprint_historic.txt
 
# }

# function get_current_bug_metric(){
  
#   cat $FILE_CURRENT_BUGS_METRIC | grep "$PLATFORM_NAME" >> sprint_historic.txt
#   while read LINE 
#   do
#     BACKLOG_CURRENT=$(echo $LINE | awk '{print $2}')
#     FIXED_CURRENT=$(echo $LINE | awk '{print $3}')
#     FLAGGED_CURRENT=$(echo $LINE | awk '{print $4}')
#   done < sprint_historic.txt
#   ALL_METRICS_BUGS=$ALL_METRICS_BUGS" "$BACKLOG_CURRENT" "$FIXED_CURRENT" "$FLAGGED_CURRENT
#   rm -rf sprint_historic.txt
# }

# function get_all_bugs_flagged()
# {
#   cat $FILE_SPRINT_BUGS_FLAGGED | grep $PLATFORM_NAME >> sprint_historic.txt
#   while read LINE 
#   do
#     BUG_TICKET=$(echo $LINE | awk '{print $2}')
#     BUG_TITLE=$(echo $LINE | awk '{t=""; for(i=3;i<=NF;i++) t=t" "$i; print t}')
#     set_bugs_flagged_chart
#   done < sprint_historic.txt
#   rm -rf sprint_historic.txt 
# }

function set_metrics_in_template()
{
  set_functional_test_data_in_html
  set_contract_test_data_in_html
  set_unit_test_data_in_html
  set_recent_sprints_data_in_html
  # # FILE_SPRINT=$(cat $FILE_METRICS_HTML)
  # # FILE_SPRINT=`echo ${FILE_SPRINT} | tr '\n' "\\n"`
  # # FILE_BUGS=$(cat $FILE_BUGS_JS)
  # # FILE_BUGS=`echo ${FILE_BUGS} | tr '\n' "\\n"`
  

  # cat report_tests.html | sed -e "s|ALL_SPRINTS_METRICS|${FILE_SPRINT}|" > $REPORT_NAME-$PLATFORM_NAME.html
  
  # cat ../template/js/lib/morris-chart/morris-init.js | sed -e "s|INFO_BUGS_SPRINT|${FILE_BUGS}|" > report_bugs.js
  # cat report_bugs.js | sed -e "s|BACKLOG_SPRINT|${BACKLOG_CURRENT}|" > report_bugs_1.js
  # cat report_bugs_1.js | sed -e "s|FIXED_SPRINT|${FIXED_CURRENT}|" > report_bugs.js
  # cat report_bugs.js | sed -e "s|FLAGGED_SPRINT|${FLAGGED_CURRENT}|" > ../template/js/lib/morris-chart/morris-init-$PLATFORM_NAME.js
  
  
  # rm -rf report_bugs.js
  # rm -rf report_bugs_1.js
  # rm -rf $FILE_HTML
  # rm -rf $FILE_METRICS_HTML
  # rm -rf $FILE_BUGS_JS
  
}

function set_chart_template()
{
  cat ../template/chart-morris.html >> chart-morris-$PLATFORM_NAME.html

}

function genenerate_report_by_platform()
{
 
  # BUGS_FLAGGED_CONTENT=$(cat $FILE_BUGS_FLAGGED)
  # BUGS_FLAGGED_CONTENT=`echo ${BUGS_FLAGGED_CONTENT} | tr '\n' "\\n"`


  cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|REPORT_PLATFORM_NAME|${PLATFORM_REPORT}|" > report_tests.html
  # cat chart-morris-$PLATFORM_NAME.html | sed -e "s|REPORT_PLATFORM_NAME|${PLATFORM_REPORT}|" > report_chart.html 
  
  # cat report_tests.html | sed -e "s|BUGS_PLATFORM_NAME|${BUG_PLATFORM_REPORT}|" > report_tests_1.html
  # cat report_chart.html | sed -e "s|BUGS_PLATFORM_NAME|${BUG_PLATFORM_REPORT}|" > report_chart_1.html
  # set_chart_init
  # cat report_chart_1.html | sed -e "s|CHART_BUG_INIT|${CHART_INIT}|" > report_chart.html
  # cat report_chart.html | sed -e "s|LIST_FLAGGED_BUGS|${BUGS_FLAGGED_CONTENT}|" > report_chart_1.html
  
  # rm -rf $REPORT_NAME-$PLATFORM_NAME.html
  # rm -rf chart-morris-$PLATFORM_NAME.html

  mv report_tests.html $REPORT_NAME-$PLATFORM_NAME.html
  # mv report_chart_1.html chart-morris-$PLATFORM_NAME.html

  cp $REPORT_NAME-$PLATFORM_NAME.html $REPORT_NAME/
  # cp chart-morris-$PLATFORM_NAME.html $REPORT_NAME/
  
  rm -rf $REPORT_NAME-$PLATFORM_NAME.html
  # rm -rf chart-morris-$PLATFORM_NAME.html
  # rm -rf $FILE_BUGS_FLAGGED
  # rm -rf report_tests.html
  # rm -rf report_chart_1.html
  # rm -rf report_chart.html

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
  # python3 main.py
  while [ $count -lt $LENGHT ]; do
    PLATFORM_NAME=${ALL_PLATFORMS[$count]}
    
    ALL_METRICS=""
    ALL_METRICS=$PLATFORM_NAME
    ALL_METRICS=$ALL_METRICS" "$REPORT_NAME
    # ALL_METRICS_BUGS=""
    # ALL_METRICS_BUGS=$PLATFORM_NAME
    # ALL_METRICS_BUGS=$ALL_METRICS_BUGS" "$REPORT_NAME
   
    if [ "$PLATFORM_NAME" = "ios" ];
    then
      get_unit_test_metric_ios
      save_ios_unit_test
    elif [ "$PLATFORM_NAME" = "android" ];
    then
      get_unit_test_metric_android
      save_android_unit_test
    fi
 
    get_all_functional_datas
    get_all_contract_datas
    set_report_platform_menu
    # set_bug_platform_menu
    # get_current_bug_metric
    echo $ALL_METRICS >> $FILE_WITH_RECENT_SPRINTS_METRICS
    # echo $ALL_METRICS_BUGS >> $FILE_SPRINTS_BUGS
    get_recent_sprints_metrics
    # get_all_sprints_bugs
    set_metrics_in_template
    # set_chart_template
    let count++
    
  done
  
  count=0
  while [ $count -lt $LENGHT ]; do
    PLATFORM_NAME=${ALL_PLATFORMS[$count]}
    # get_all_bugs_flagged
    genenerate_report_by_platform
    let count++
  done

  cp -r ../template/ $REPORT_NAME/
  rm -rf $REPORT_NAME/index.html
  rm -rf $REPORT_NAME/chart-morris.html
  # rm -rf $REPORT_NAME/js/lib/morris-chart/morris-init.js

  generate_feature_express
}

echo "Gerando Weaver Report ..."
setup_envs
setup_functional_envs
setup_contract_envs
setup_develop_envs
setup_historic_envs
check_tags_in_config_file
generate_weaver_report
echo "Weaver Report gerado com sucesso!"

