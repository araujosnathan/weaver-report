#!/bin/bash


function get_danger_button_of_contract_test
{
  BUTTON_CONTRACT_TEST="<button type='button' class='btn btn-danger m-b-10 m-l-5' id='toastr-contract-tests-danger-bottom-full-width'>Testes de Contrato</button>"
}

function set_contract_test_data_in_html
{
  if [ "$STATUS_CONTRACT_TESTING" = "true" ];then
    cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|CONTRACT_PERCENTAGE|${TOTAL_NUMBER_OF_CONTRACT_SCENARIOS}|" > report_tests.html
    cat report_tests.html | sed -e "s|ENDPOINTS_NUMBER|${TOTAL_NUMBER_OF_ENDPOINTS}|" > $REPORT_NAME-$PLATFORM_NAME.html
  else
    cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|CONTRACT_PERCENTAGE|N/A|" > report_tests.html
    cat report_tests.html | sed -e "s|ENDPOINTS_NUMBER|N/A|" > report_tests_2.html
    get_danger_button_of_contract_test
    cat report_tests_2.html | sed -e "s|\<!-- BUTTON_DANGER_CONTRACT_TEST -->|${BUTTON_CONTRACT_TEST}|g" > $REPORT_NAME-$PLATFORM_NAME.html
  fi
  
  rm -rf report_tests.html
  rm -rf report_tests_2.html
}

