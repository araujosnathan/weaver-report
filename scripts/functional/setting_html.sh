#!/bin/bash


function set_collapse_feature_html()
{
  echo "<h4 class='panel-title'>" >> $FILE_HTML
  echo  "<a data-toggle='collapse' href='#collapse$i'>" >> $FILE_HTML
  echo  "<p class='m-t-30 f-w-600'>"$FEATURE_NAME "("$SCENARIOS_TOTAL_BY_FEATURE"/"$TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE")""<span class='pull-right'>"$COVERAGE_BY_FEATURE"%</span></p>" >> $FILE_HTML
  echo      "<div class='progress '>" >> $FILE_HTML
  
  if [ $(echo $COVERAGE_BY_FEATURE ">" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ] && [ $(echo $COVERAGE_BY_FEATURE "< 99"  | bc -l) -eq 1 ]
  then
    echo "<div role='progressbar' style='width: $COVERAGE_BY_FEATURE%; height:8px;' class='progress-bar bg-info wow animated progress-animated'> <span class='sr-only'>$COVERAGE_BY_FEATURE% Complete</span> </div>" >> $FILE_HTML
  elif [ $(echo $COVERAGE_BY_FEATURE "<" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ]
  then
    echo "<div role='progressbar' style='width: $COVERAGE_BY_FEATURE%; height:8px;' class='progress-bar bg-danger wow animated progress-animated'> <span class='sr-only'>$COVERAGE_BY_FEATURE% Complete</span> </div>" >> $FILE_HTML
  elif [ $(echo $COVERAGE_BY_FEATURE  "<" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 0 ] && [ $(echo $COVERAGE_BY_FEATURE  ">" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 0 ]
  then
    echo "<div role='progressbar' style='width: $COVERAGE_BY_FEATURE%; height:8px;' class='progress-bar bg-info wow animated progress-animated'> <span class='sr-only'>$COVERAGE_BY_FEATURE% Complete</span> </div>" >> $FILE_HTML
  elif [ $(echo $COVERAGE_BY_FEATURE ">" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ] && [ $(echo $COVERAGE_BY_FEATURE "> 99" | bc -l) -eq 1 ]
  then
    echo "<div role='progressbar' style='width: $COVERAGE_BY_FEATURE%; height:8px;' class='progress-bar bg-sucess wow animated progress-animated'> <span class='sr-only'>$COVERAGE_BY_FEATURE% Complete</span> </div>" >> $FILE_HTML
  fi
  
  echo  "</div>" >> $FILE_HTML
  echo  "</a>" >> $FILE_HTML
  echo  "<div id='collapse$i' class='panel-collapse collapse'>" >> $FILE_HTML
  
}


function set_scenarios_not_implemented_to_collapse_html()
{
    echo "<div  style='color:lightCoral' class='panel'>$L</div>" >> $FILE_HTML 
}

function set_scenarios_implemented_to_collapse_html
{
    echo "<div  style='color:Green' class='panel'>$L</div>" >> $FILE_HTML
}

function set_end_html()
{
  echo    "</div>" >> $FILE_HTML
  echo "</h4>" >> $FILE_HTML
}

function set_functional_test_data_in_html
{
  FILE=$(cat $FILE_HTML)
  FILE=`echo ${FILE} | tr '\n' "\\n"`

  cat ../template/index.html | sed -e "s|FUNCTIONAL_PERCENTAGE|${PROJECT_COVERAGE}|" > report_tests.html
  cat report_tests.html | sed -e "s|FUNCTIONAL_SCENARIOS_NUMBER|${TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT}|" > report_tests_1.html
  cat report_tests_1.html | sed -e "s|ALL-FEATURES-AND-SCENARIOS-HERE|${FILE}|" > $REPORT_NAME-$PLATFORM_NAME.html

  rm -rf report_tests_1.html
  rm -rf report_tests.html
  rm -rf $FILE_HTML
 
}
