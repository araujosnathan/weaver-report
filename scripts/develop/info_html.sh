#!/bin/bash

function get_danger_button_of_unit_test
{
  BUTTON_UNIT_TEST="<button type='button' class='btn btn-danger m-b-10 m-l-5' id='toastr-unit-tests-danger-bottom-full-width'>Testes Unitários</button>"
}

function set_unit_test_data_in_html
{
    get_danger_button_of_unit_test
    if [[ "$IOS_STATUS_UNIT_TEST" = "false" && "$PLATFORM_NAME" = "ios" ]];then
        cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|\<!-- BUTTON_DANGER_UNIT_TEST -->|${BUTTON_UNIT_TEST}|g" > report_tests.html
        mv report_tests.html $REPORT_NAME-$PLATFORM_NAME.html
        rm -rf report_tests.html
    elif [[ "$ANDROID_STATUS_UNIT_TEST" = "false"  && "$PLATFORM_NAME" = "android" ]]; then
        cat $REPORT_NAME-$PLATFORM_NAME.html | sed -e "s|\<!-- BUTTON_DANGER_UNIT_TEST -->|${BUTTON_UNIT_TEST}|g" > report_tests.html
        mv report_tests.html $REPORT_NAME-$PLATFORM_NAME.html
        rm -rf report_tests.html
    fi

}