#!/bin/bash

function set_recent_metrics_sprint_html()
{
    echo "<tr>" >> $FILE_METRICS_HTML
    echo "<td>" >> $FILE_METRICS_HTML
    echo "<div class='round-img'>" >> $FILE_METRICS_HTML
    echo "<a href=''><img src='images/report_scrum.png' alt=''></a>" >> $FILE_METRICS_HTML
    echo "</div>" >> $FILE_METRICS_HTML
    echo "</td>" >> $FILE_METRICS_HTML
    echo "<td>$REPORT_NAME_LABEL</td>" >> $FILE_METRICS_HTML
    if [ $UNIT_TEST_COVERAGE = "N/A" ];
    then
        echo "<td><span class='badge badge-warning'>$UNIT_TEST_COVERAGE</span></td>" >> $FILE_METRICS_HTML
    elif [ $(echo $UNIT_TEST_COVERAGE ">" $UNIT_TEST_DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ] && [ $(echo $UNIT_TEST_COVERAGE "< 99"  | bc -l) -eq 1 ]
    then
        echo "<td><span class='badge badge-info'>$UNIT_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    elif [ $(echo $UNIT_TEST_COVERAGE "<" $UNIT_TEST_DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ]
    then
        echo "<td><span class='badge badge-danger'>$UNIT_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    elif [ $(echo $UNIT_TEST_COVERAGE  "<" $UNIT_TEST_DEFINITION_OF_DONE_TARGET | bc -l) -eq 0 ] && [ $(echo $UNIT_TEST_COVERAGE  ">" $UNIT_TEST_DEFINITION_OF_DONE_TARGET | bc -l) -eq 0 ]
    then
        echo "<td><span class='badge badge-info'>$UNIT_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    elif [ $(echo $UNIT_TEST_COVERAGE ">" $UNIT_TEST_DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ] && [ $(echo $UNIT_TEST_COVERAGE "> 99" | bc -l) -eq 1 ]
    then
        echo "<td><span class='badge badge-success'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    fi
    
    if [ $(echo $FUNCTIONAL_TEST_COVERAGE ">" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ] && [ $(echo $FUNCTIONAL_TEST_COVERAGE "< 99"  | bc -l) -eq 1 ]
    then
        echo "<td><span class='badge badge-info'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    elif [ $(echo $FUNCTIONAL_TEST_COVERAGE "<" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ]
    then
        echo "<td><span class='badge badge-danger'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    elif [ $(echo $FUNCTIONAL_TEST_COVERAGE  "<" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 0 ] && [ $(echo $FUNCTIONAL_TEST_COVERAGE  ">" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 0 ]
    then
        echo "<td><span class='badge badge-info'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    elif [ $(echo $FUNCTIONAL_TEST_COVERAGE ">" $DEFINITION_OF_DONE_TARGET | bc -l) -eq 1 ] && [ $(echo $FUNCTIONAL_TEST_COVERAGE "> 99" | bc -l) -eq 1 ]
    then
        echo "<td><span class='badge badge-success'>$FUNCTIONAL_TEST_COVERAGE%</span></td>" >> $FILE_METRICS_HTML
    fi

    if [ "$CONTRACT_TEST_COVERAGE" = "N/A-N/A" ]; then 
        echo "<td><span class='badge badge-warning'>$CONTRACT_TEST_COVERAGE</span></td>" >> $FILE_METRICS_HTML
    else
        echo "<td><span class='badge badge-danger'>$CONTRACT_TEST_COVERAGE</span></td>" >> $FILE_METRICS_HTML
    fi
    echo "</tr>" >> $FILE_METRICS_HTML
}