#!/bin/bash

function set_contract_test_data_in_html
{
  if [ "$STATUS_CONTRACT_TESTING" = "true" ];then
    cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|CONTRACT_PERCENTAGE|${TOTAL_NUMBER_OF_CONTRACT_SCENARIOS}|" > report_tests.html
    cat report_tests.html | sed -e "s|ENDPOINTS_NUMBER|${TOTAL_NUMBER_OF_ENDPOINTS}|" > $REPORT_NAME-$PLATFORM_NAME.html
  else
    cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|CONTRACT_PERCENTAGE|N/A|" > report_tests.html
    cat report_tests.html | sed -e "s|ENDPOINTS_NUMBER|N/A|" > $REPORT_NAME-$PLATFORM_NAME.html
  fi
  
  rm -rf report_tests.html
}

