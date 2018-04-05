#!/bin/bash

source functional_tests_datas.sh

function setup_envs()
{
  # PATH_TO_FEATURES=$(cat weaver-report-config.yml | grep path_to_features | awk '{print $2}')
  # PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS=$(cat weaver-report-config.yml | grep path_to_all_scenarios_document_txt | awk '{print $2}')
  FILE_HTML="file_html.txt"
  FILE_METRICS="file_metrics.txt"
  FILE_BUGS_JS="file_bugs.txt"
  FILE_BUGS_FLAGGED="file_bugs_flagged.txt"
  FILE_CURRENT_BUGS_METRIC="bugs_metric.txt"
  PATH_TESTS=$(cat config.yml | grep path_to_contract_tests | awk '{print $2}')
  FILE_LIST_PATHS='list_paths.txt'
  FILE_LIST_SCENARIOS=' list_scenarios.txt'
  REPORT_NAME=$(cat config.yml | grep report_name | awk '{print $2}')
  PLATFORMS=$(cat config.yml | grep platforms | awk '{print $2}')
  PLATFORM_REPORT=""
  BUG_PLATFORM_REPORT=""
  CHART_INIT=""
  UNIT_TEST_DOC=$(cat config.yml | grep unit_test_document_ios | awk '{print $2}')
  UNIT_TEST_DOC_ANDROID=$(cat config.yml | grep unit_test_document_android | awk '{print $2}')
  ALL_METRICS=""
  FILE_SPRINTS_METRICS="sprints_metrics.txt"
  FILE_SPRINTS_BUGS="sprints_bugs.txt"
  FILE_SPRINT_BUGS_FLAGGED="bugs_flagged.txt"
  DOD=70

}

function get_unit_test_metric_ios()
{

  UNIT_TEST_COVERAGE_IOS=$(cat $UNIT_TEST_DOC | grep -o  "\"total_coverage\">[^']*" | grep -o [0-9]*.[0-9]*%)
  UNIT_TEST_COVERAGE_IOS=$(echo $UNIT_TEST_COVERAGE_IOS | tr '%' ' ')
}

function get_unit_test_metric_android()
{
  UNIT_TEST_COVERAGE_ANDROID=$(cat $UNIT_TEST_DOC_ANDROID | grep Total | grep -o  "\"ctr2\">[^']*" | grep -o [0-9]*.[0-9]*% | head -1)
  UNIT_TEST_COVERAGE_ANDROID=$(echo $UNIT_TEST_COVERAGE_ANDROID | tr '%' ' ' | tr '>' ' ')
}

function set_metrics_sprint_html()
{
  echo "<tr>" >> $FILE_METRICS
  echo "<td>" >> $FILE_METRICS
  echo "<div class='round-img'>" >> $FILE_METRICS
  echo "<a href=''><img src='images/report_scrum.png' alt=''></a>" >> $FILE_METRICS
  echo "</div>" >> $FILE_METRICS
  echo "</td>" >> $FILE_METRICS
  echo "<td>$REPORT_NAME_LABEL</td>" >> $FILE_METRICS
  if [ $UNIT_TEST_COVERAGE = "--" ]
  then
    echo "<td><span class='badge badge-success'>$UNIT_TEST_COVERAGE</span></td>" >> $FILE_METRICS
  elif [ $(echo $UNIT_TEST_COVERAGE ">" $DOD | bc -l) -eq 1 ] && [ $(echo $UNIT_TEST_COVERAGE "< 99"  | bc -l) -eq 1 ]
  then
    echo "<td><span class='badge badge-info'>$UNIT_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  elif [ $(echo $UNIT_TEST_COVERAGE "<" $DOD | bc -l) -eq 1 ]
  then
    echo "<td><span class='badge badge-danger'>$UNIT_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  elif [ $(echo $UNIT_TEST_COVERAGE  "<" $DOD | bc -l) -eq 0 ] && [ $(echo $UNIT_TEST_COVERAGE  ">" $DOD | bc -l) -eq 0 ]
  then
    echo "<td><span class='badge badge-info'>$UNIT_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  elif [ $(echo $UNIT_TEST_COVERAGE ">" $DOD | bc -l) -eq 1 ] && [ $(echo $UNIT_TEST_COVERAGE "> 99" | bc -l) -eq 1 ]
  then
    echo "<td><span class='badge badge-success'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  fi
  
  if [ $(echo $FUNCTIONAL_TEST_COVERAGE ">" $DOD | bc -l) -eq 1 ] && [ $(echo $FUNCTIONAL_TEST_COVERAGE "< 99"  | bc -l) -eq 1 ]
  then
    echo "<td><span class='badge badge-info'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  elif [ $(echo $FUNCTIONAL_TEST_COVERAGE "<" $DOD | bc -l) -eq 1 ]
  then
    echo "<td><span class='badge badge-danger'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  elif [ $(echo $FUNCTIONAL_TEST_COVERAGE  "<" $DOD | bc -l) -eq 0 ] && [ $(echo $FUNCTIONAL_TEST_COVERAGE  ">" $DOD | bc -l) -eq 0 ]
  then
    echo "<td><span class='badge badge-info'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  elif [ $(echo $FUNCTIONAL_TEST_COVERAGE ">" $DOD | bc -l) -eq 1 ] && [ $(echo $FUNCTIONAL_TEST_COVERAGE "> 99" | bc -l) -eq 1 ]
  then
    echo "<td><span class='badge badge-success'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS
  fi

  echo "<td><span class='badge badge-danger'>$CONTRACT_TEST_COVERAGE</span></td>" >> $FILE_METRICS
  echo "</tr>" >> $FILE_METRICS
}

function set_collapse_feature_html()
{
  echo "<h4 class='panel-title'>" >> $FILE_HTML
  echo  "<a data-toggle='collapse' href='#collapse$i'>" >> $FILE_HTML
  echo  "<p class='m-t-30 f-w-600'>"$FEATURE_NAME "("$SCENARIOS_TOTAL_BY_FEATURE"/"$TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE")""<span class='pull-right'>"$COVERAGE_BY_FEATURE"%</span></p>" >> $FILE_HTML
  echo      "<div class='progress '>" >> $FILE_HTML
  if [ $COVERAGE_BY_FEATURE -lt '70' ]  || [ $COVERAGE_BY_FEATURE -eq '0' ]
  then
    echo "<div role='progressbar' style='width: $COVERAGE_BY_FEATURE%; height:8px;' class='progress-bar bg-danger wow animated progress-animated'> <span class='sr-only'>$COVERAGE_BY_FEATURE% Complete</span> </div>" >> $FILE_HTML
  elif [ $COVERAGE_BY_FEATURE -gt '70' ] || [ $COVERAGE_BY_FEATURE -eq '70' ] 
  then
    echo "<div role='progressbar' style='width: $COVERAGE_BY_FEATURE%; height:8px;' class='progress-bar bg-info wow animated progress-animated'> <span class='sr-only'>$COVERAGE_BY_FEATURE% Complete</span> </div>" >> $FILE_HTML
  elif [ $COVERAGE_BY_FEATURE -eq '100' ] 
  then
    echo "<div role='progressbar' style='width: $COVERAGE_BY_FEATURE%; height:8px;' class='progress-bar bg-sucess wow animated progress-animated'> <span class='sr-only'>$COVERAGE_BY_FEATURE% Complete</span> </div>" >> $FILE_HTML
  fi
  
  echo  "</div>" >> $FILE_HTML
  echo  "</a>" >> $FILE_HTML
  echo  "<div id='collapse$i' class='panel-collapse collapse'>" >> $FILE_HTML
  
}

function set_scenarios_not_implemented_to_collapse_html()
{
  if [ $(($j%2)) -eq '0' ]; then
    echo "<div  style='color:lightCoral' class='panel'>$L</div>" >> $FILE_HTML
  else
    echo "<div  style='color:lightCoral' class='panel'>$L</div>" >> $FILE_HTML
  fi
}

function set_scenarios_implemented_to_collapse_html
{
  if [ $(($j%2)) -eq '0' ]; then
    echo "<div  style='color:Green' class='panel'>$L</div>" >> $FILE_HTML
  else
    echo "<div  style='color:Green' class='panel'>$L</div>" >> $FILE_HTML
  fi
}


function set_end_html()
{
  echo    "</div>" >> $FILE_HTML
  echo "</h4>" >> $FILE_HTML
}

function set_report_platform_menu
{
   PLATFORM_REPORT=$PLATFORM_REPORT$(echo "<li><a href="$REPORT_NAME-$PLATFORM_NAME.html">$PLATFORM_NAME</a></li>")
}

function set_bug_platform_menu
{
  
   BUG_PLATFORM_REPORT=$BUG_PLATFORM_REPORT$(echo "<li><a href="chart-morris-$PLATFORM_NAME.html">Bugs $PLATFORM_NAME</a></li>")
}

function set_chart_init
{
  CHART_INIT=$(echo "<script src="js/lib/morris-chart/morris-init-$PLATFORM_NAME.js"></script>")
}

function set_bugs_flagged_chart
{
  echo "<div class='recent-comment'>" >> $FILE_BUGS_FLAGGED
  echo "<div class='media'>" >> $FILE_BUGS_FLAGGED
  echo "<div class='media-left'>" >> $FILE_BUGS_FLAGGED
  echo "<a href='#'><img alt='...' src='images/report_bug_flagged.png' class='media-object'></a>" >> $FILE_BUGS_FLAGGED
  echo "</div>" >> $FILE_BUGS_FLAGGED
  echo "<div class='media-body'>" >> $FILE_BUGS_FLAGGED
  echo "<h4 class='media-heading'>$BUG_TICKET</h4>" >> $FILE_BUGS_FLAGGED
  echo "<p>$BUG_TITLE</p>" >> $FILE_BUGS_FLAGGED
  echo "</div>" >> $FILE_BUGS_FLAGGED
  echo "</div>" >> $FILE_BUGS_FLAGGED
  echo "</div>" >> $FILE_BUGS_FLAGGED
}

function get_all_datas_functional()
{

  setup_functional_envs

  SCENARIOS_TOTAL_OF_PROJECT=0

  get_all_features_from_testing_project
 
  i=1
  while read LINE
  do

    get_feature_name
    get_total_number_of_scenarios_by_feature 
    get_total_number_of_scenarios_from_project
    get_scenario_names_by_feature
    get_total_number_of_scenarios_from_official_document_by_feature
    get_scenario_names_from_official_document
    calculate_coverage_by_feature
    
    set_collapse_feature_html
    
    # echo 'Cenários não implementados':
    j=1
    while read L 
    do 
      SCENARIO_NAME=$(cat $FILE_WITH_SCENARIO_NAMES_BY_FEATURE | grep "$L")
      if [ -z "$SCENARIO_NAME" ]; then
        set_scenarios_not_implemented_to_collapse_html
        j=$(($j+1))
      else
        set_scenarios_implemented_to_collapse_html
        j=$(($j+1))
      fi
    done < $FILE_WITH_SCENARIO_NAMES_FROM_OFFICIAL_DOCUMENT

    rm -rf $FILE_WITH_SCENARIO_NAMES_BY_FEATURE
    rm -rf $FILE_WITH_SCENARIO_NAMES_FROM_OFFICIAL_DOCUMENT
    i=$(($i+1))
    set_end_html
  done < $FILE_WITH_ALL_FEATURES

  get_total_number_of_scenarios_from_official_document
  calculate_project_coverage
  ALL_METRICS=$ALL_METRICS" "$PROJECT_COVERAGE
  
  rm -rf $FILE_WITH_ALL_FEATURES
}

function get_all_datas_contract()
{
  PATHS_TOTAL=0
  SCENARIOS_TOTAL=0
  ls $PATH_TESTS | grep 'testing' >> tests.txt
  while read LINE
  do
    cat $PATH_TESTS$LINE | grep 'const' | grep 'PATH_' | awk '{print $2}' >> $FILE_LIST_PATHS
    cat $PATH_TESTS$LINE | grep 'it(' >> $FILE_LIST_SCENARIOS
  done < tests.txt

  PATHS_TOTAL=$(sort list_paths.txt | awk '$1=$1' | awk '!a[$0]++' | wc -l)
  SCENARIOS_TOTAL=$(sort list_scenarios.txt | awk '$1=$1' |awk '!a[$0]++' | wc -l)

  PATHS_TOTAL=$(echo $PATHS_TOTAL | tr -d ' ')
  SCENARIOS_TOTAL=$(echo $SCENARIOS_TOTAL | tr -d ' ')

  ALL_METRICS=$ALL_METRICS" "$SCENARIOS_TOTAL"-"$PATHS_TOTAL

  rm -rf tests.txt
  rm -rf list_paths.txt
  rm -rf list_scenarios.txt
}

function get_all_sprints_metrics()
{

  cat $FILE_SPRINTS_METRICS | sort -rn -k 1 | grep $PLATFORM_NAME >> sprint_historic.txt
  while read LINE 
  do
    REPORT_NAME_LABEL=$(echo $LINE | awk '{print $2}')
    UNIT_TEST_COVERAGE=$(echo $LINE | awk '{print $3}')
    FUNCTIONAL_TEST_COVERAGE=$(echo $LINE | awk '{print $4}')
    CONTRACT_TEST_COVERAGE=$(echo $LINE | awk '{print $5}')
    set_metrics_sprint_html
  done < sprint_historic.txt

  rm -rf sprint_historic.txt
 
}

function set_bugs_sprints_js()
{
  echo "{" >> $FILE_BUGS_JS
  echo "s: '$REPORT_NAME_LABEL'," >> $FILE_BUGS_JS
	echo "bl: $BACKLOG_NUMBER," >> $FILE_BUGS_JS
	echo "fx: $BUG_FIXED_NUMBER," >> $FILE_BUGS_JS
	echo "fl: $BUG_FLAGGED_NUMBER" >> $FILE_BUGS_JS
  if [ $COUNT -gt 1 ] && [ $MAX -lt $COUNT ];
  then
    echo "}," >> $FILE_BUGS_JS
  else
    echo "}" >> $FILE_BUGS_JS
  fi
}

function get_all_sprints_bugs()
{
  cat $FILE_SPRINTS_BUGS | grep $PLATFORM_NAME >> sprint_historic.txt
  COUNT=$(cat $FILE_SPRINTS_BUGS | grep $PLATFORM_NAME | wc -l)
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
  
  cat $FILE_CURRENT_BUGS_METRIC | grep $PLATFORM_NAME >> sprint_historic.txt
  while read LINE 
  do
    BACKLOG_CURRENT=$(echo $LINE | awk '{print $2}')
    FIXED_CURRENT=$(echo $LINE | awk '{print $3}')
    FLAGGED_CURRENT=$(echo $LINE | awk '{print $4}')
  done < sprint_historic.txt
  ALL_METRICS_BUGS=$ALL_METRICS_BUGS" "$BACKLOG_CURRENT" "$FIXED_CURRENT" "$FLAGGED_CURRENT
  rm -rf sprint_historic.txt
}

function get_all_bugs_flagged()
{
  cat $FILE_SPRINT_BUGS_FLAGGED | grep $PLATFORM_NAME >> sprint_historic.txt
  while read LINE 
  do
    BUG_TICKET=$(echo $LINE | awk '{print $2}')
    BUG_TITLE=$(echo $LINE | awk '{t=""; for(i=3;i<=NF;i++) t=t" "$i; print t}')
    set_bugs_flagged_chart
  done < sprint_historic.txt
  rm -rf sprint_historic.txt 
}

function set_metrics_in_template()
{
  FILE=$(cat $FILE_HTML)
  FILE=`echo ${FILE} | tr '\n' "\\n"`
  FILE_SPRINT=$(cat $FILE_METRICS)
  FILE_SPRINT=`echo ${FILE_SPRINT} | tr '\n' "\\n"`
  FILE_BUGS=$(cat $FILE_BUGS_JS)
  FILE_BUGS=`echo ${FILE_BUGS} | tr '\n' "\\n"`
  

  cat ../template/index.html | sed -e "s|FUNCTIONAL_PERCENTAGE|${PROJECT_COVERAGE}|" > report_tests.html
  cat report_tests.html | sed -e "s|FUNCTIONAL_SCENARIOS_NUMBER|${TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT}|" > report_tests_1.html
  cat report_tests_1.html | sed -e "s|CONTRACT_PERCENTAGE|${SCENARIOS_TOTAL}|" > report_tests.html
  cat report_tests.html | sed -e "s|ENDPOINTS_NUMBER|${PATHS_TOTAL}|" > report_tests_1.html
  
  cat report_tests_1.html | sed -e "s|ALL-FEATURES-AND-SCENARIOS-HERE|${FILE}|" > report_tests.html
  cat report_tests.html | sed -e "s|ALL_SPRINTS_METRICS|${FILE_SPRINT}|" > $REPORT_NAME-$PLATFORM_NAME.html
  
  cat ../template/js/lib/morris-chart/morris-init.js | sed -e "s|INFO_BUGS_SPRINT|${FILE_BUGS}|" > report_bugs.js
  cat report_bugs.js | sed -e "s|BACKLOG_SPRINT|${BACKLOG_CURRENT}|" > report_bugs_1.js
  cat report_bugs_1.js | sed -e "s|FIXED_SPRINT|${FIXED_CURRENT}|" > report_bugs.js
  cat report_bugs.js | sed -e "s|FLAGGED_SPRINT|${FLAGGED_CURRENT}|" > ../template/js/lib/morris-chart/morris-init-$PLATFORM_NAME.js
  
  
  rm -rf report_tests_1.html
  rm -rf report_tests.html
  rm -rf report_bugs.js
  rm -rf report_bugs_1.js
  rm -rf $FILE_HTML
  rm -rf $FILE_METRICS
  rm -rf $FILE_BUGS_JS
  
}

function set_chart_template()
{
  cat ../template/chart-morris.html >> chart-morris-$PLATFORM_NAME.html

}

function genenerate_report_by_platform()
{
 
  BUGS_FLAGGED_CONTENT=$(cat $FILE_BUGS_FLAGGED)
  BUGS_FLAGGED_CONTENT=`echo ${BUGS_FLAGGED_CONTENT} | tr '\n' "\\n"`


  cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|REPORT_PLATFORM_NAME|${PLATFORM_REPORT}|" > report_tests.html
  cat chart-morris-$PLATFORM_NAME.html | sed -e "s|REPORT_PLATFORM_NAME|${PLATFORM_REPORT}|" > report_chart.html 
  
  cat report_tests.html | sed -e "s|BUGS_PLATFORM_NAME|${BUG_PLATFORM_REPORT}|" > report_tests_1.html
  cat report_chart.html | sed -e "s|BUGS_PLATFORM_NAME|${BUG_PLATFORM_REPORT}|" > report_chart_1.html
  set_chart_init
  cat report_chart_1.html | sed -e "s|CHART_BUG_INIT|${CHART_INIT}|" > report_chart.html
  cat report_chart.html | sed -e "s|LIST_FLAGGED_BUGS|${BUGS_FLAGGED_CONTENT}|" > report_chart_1.html
  
  rm -rf $REPORT_NAME-$PLATFORM_NAME.html
  rm -rf chart-morris-$PLATFORM_NAME.html

  mv report_tests_1.html $REPORT_NAME-$PLATFORM_NAME.html
  mv report_chart_1.html chart-morris-$PLATFORM_NAME.html

  cp $REPORT_NAME-$PLATFORM_NAME.html $REPORT_NAME/
  cp chart-morris-$PLATFORM_NAME.html $REPORT_NAME/
  
  rm -rf $REPORT_NAME-$PLATFORM_NAME.html
  rm -rf chart-morris-$PLATFORM_NAME.html
  rm -rf $FILE_BUGS_FLAGGED
  rm -rf report_tests.html
  rm -rf report_chart_1.html
  rm -rf report_chart.html

}

function generate_weaver_report
{
  mkdir $REPORT_NAME
  ALL_PLATFORMS=($(echo $PLATFORMS | tr "," "\n"))
  LENGHT=${#ALL_PLATFORMS[*]}
  count=0
  python3 main.py
  while [ $count -lt $LENGHT ]; do
    PLATFORM_NAME=${ALL_PLATFORMS[$count]}
    
    ALL_METRICS=""
    ALL_METRICS=$PLATFORM_NAME
    ALL_METRICS=$ALL_METRICS" "$REPORT_NAME
    ALL_METRICS_BUGS=""
    ALL_METRICS_BUGS=$PLATFORM_NAME
    ALL_METRICS_BUGS=$ALL_METRICS_BUGS" "$REPORT_NAME
   
    if [ "$PLATFORM_NAME" = "ios" ];
    then
      get_unit_test_metric_ios
      ALL_METRICS=$ALL_METRICS" "$UNIT_TEST_COVERAGE_IOS
    elif [ "$PLATFORM_NAME" = "android" ];
    then
      get_unit_test_metric_android
      ALL_METRICS=$ALL_METRICS" "$UNIT_TEST_COVERAGE_ANDROID
    fi
 
  
    get_all_datas_functional
    set_report_platform_menu
    set_bug_platform_menu
    get_all_datas_contract
    get_current_bug_metric
    echo $ALL_METRICS >> $FILE_SPRINTS_METRICS
    echo $ALL_METRICS_BUGS >> $FILE_SPRINTS_BUGS
    get_all_sprints_metrics
    get_all_sprints_bugs
    set_metrics_in_template
    set_chart_template
    let count++
    
  done
  
  count=0
  while [ $count -lt $LENGHT ]; do
    PLATFORM_NAME=${ALL_PLATFORMS[$count]}
    get_all_bugs_flagged
    genenerate_report_by_platform
    let count++
  done

  cp -r ../template/ $REPORT_NAME/
  rm -rf $REPORT_NAME/index.html
  rm -rf $REPORT_NAME/chart-morris.html
  rm -rf $REPORT_NAME/js/lib/morris-chart/morris-init.js
}


setup_envs
generate_weaver_report

