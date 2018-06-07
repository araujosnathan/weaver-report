#!/bin/bash

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
  echo "<div class='media'>" >> $
  
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

function set_chart_template()
{
  cat ../template/chart-morris.html >> chart-morris-$PLATFORM_NAME.html

}


function set_recent_bugs_sprint_in_html()
{
    FILE_BUGS=$(cat $FILE_BUGS_JS)
    FILE_BUGS=`echo ${FILE_BUGS} | tr '\n' "\\n"`

    cat ../template/js/lib/morris-chart/morris-init.js | sed -e "s|INFO_BUGS_SPRINT|${FILE_BUGS}|" > report_bugs.js
    cat report_bugs.js | sed -e "s|BACKLOG_SPRINT|${BACKLOG_CURRENT}|" > report_bugs_1.js
    cat report_bugs_1.js | sed -e "s|FIXED_SPRINT|${FIXED_CURRENT}|" > report_bugs.js
    cat report_bugs.js | sed -e "s|FLAGGED_SPRINT|${FLAGGED_CURRENT}|" > ../template/js/lib/morris-chart/morris-init-$PLATFORM_NAME.js
  
  
    rm -rf report_bugs.js
    rm -rf report_bugs_1.js
    rm -rf $FILE_BUGS_JS
  
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