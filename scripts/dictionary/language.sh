#!/bin/bash


function setup_language
{
    if [ ! -z "$1" ]; then
        
        CONTENT=$(cat dictionary/weaver_languages.json | jq ".$1")
        if [ ! "$CONTENT" = "null" ]; then
            TITLE_REPORT=$(cat dictionary/weaver_languages.json | jq ".$1.title_report" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            UNIT_TEST_WARNING_BUTTON=$(cat dictionary/weaver_languages.json | jq ".$1.unit_test_warning_button" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            CONTRACT_TEST_WARNING_BUTTON=$(cat dictionary/weaver_languages.json | jq ".$1.contract_test_warning_button" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            PLATFORMS_MENU_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.platform_menu_label" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            GRAPHIC_MENU_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.graphic_menu_label" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            REPORT_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.report_label" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            FUNCTIONAL_COVERAGE_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.functional_testing_coverage" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            FUNCTIONAL_SCENARIOS_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.functional_scenarios_card" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            CONTRACT_COVERAGE_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.contract_testing_coverage" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            CONTRACT_ENDPOINTS_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.contract_endpoints_card" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            FEATURE_EXPRESS_BUTTON=$(cat dictionary/weaver_languages.json | jq ".$1.feature_express_button" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            COVERAGE_BY_FEATURE_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.coverage_by_feature_title" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            TITLE_TABLE_SPRINTS=$(cat dictionary/weaver_languages.json | jq ".$1.title_table_sprints" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            NAME_COLUMN_TABLE=$(cat dictionary/weaver_languages.json | jq ".$1.name_column_table" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            UNIT_TEST_COLUMN_TABLE=$(cat dictionary/weaver_languages.json | jq ".$1.unit_test_column_table" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            FUNCTIONAL_COLUMN_TABLE=$(cat dictionary/weaver_languages.json | jq ".$1.functional_column_table" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            CONTRACT_COLUMN_TABLE=$(cat dictionary/weaver_languages.json | jq ".$1.contract_test_column_table" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            REPORT_BUG_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.report_bug_label" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            BUG_SPRINT_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.bug_sprint_label" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
            ATTENTION_POINT_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.attention_point_label" | tr '"' " " | sed 's/ //' | sed 's/ *$//') 
            BUGS_EVOLUTION_LABEL=$(cat dictionary/weaver_languages.json | jq ".$1.bugs_evolution_label" | tr '"' " " | sed 's/ //' | sed 's/ *$//')
        else
            echo -e "\033[31;1mNot found language '$1'\nPlease, set correct language parameter!\n \033[m"
            exit 1
        fi
    else
        echo -e "\033[31;1mPlease, set a language parameter to generate your report, like: ./weaver-report en\n \033[m"
        exit 1
    fi


}

function set_language_in_template
{
    cat ../template/index.html | \
        sed -e "s|title_report|${TITLE_REPORT}|" | \
        sed -e "s|platform_menu_label|${PLATFORMS_MENU_LABEL}|" | \
        sed -e "s|graphic_menu_label|${GRAPHIC_MENU_LABEL}|" | \
        sed -e "s|report_label|${REPORT_LABEL}|" | \
        sed -e "s|functional_testing_coverage|${FUNCTIONAL_COVERAGE_LABEL}|" | \
        sed -e "s|functional_scenarios_card|${FUNCTIONAL_SCENARIOS_LABEL}|" | \
        sed -e "s|contract_testing_coverage|${CONTRACT_COVERAGE_LABEL}|" | \
        sed -e "s|contract_endpoints_card|${CONTRACT_ENDPOINTS_LABEL}|" | \
        sed -e "s|feature_express_button|${FEATURE_EXPRESS_BUTTON}|" | \
        sed -e "s|coverage_by_feature_title|${COVERAGE_BY_FEATURE_LABEL}|" | \
        sed -e "s|title_table_sprints|${TITLE_TABLE_SPRINTS}|" | \
        sed -e "s|name_column_table|${NAME_COLUMN_TABLE}|" | \
        sed -e "s|unit_test_column_table|${UNIT_TEST_COLUMN_TABLE}|" | \
        sed -e "s|functional_column_table|${FUNCTIONAL_COLUMN_TABLE}|" | \
        sed -e "s|contract_test_column_table|${CONTRACT_COLUMN_TABLE}|" > report_tests.html
    
    cat ../template/chart-morris.html | \
        sed -e "s|title_report|${TITLE_REPORT}|" | \
        sed -e "s|platform_menu_label|${PLATFORMS_MENU_LABEL}|" | \
        sed -e "s|graphic_menu_label|${GRAPHIC_MENU_LABEL}|" | \
        sed -e "s|report_bug_label|${REPORT_BUG_LABEL}|" | \
        sed -e "s|bug_sprint_label|${BUG_SPRINT_LABEL}|" | \
        sed -e "s|attention_point_label|${ATTENTION_POINT_LABEL}|" | \
        sed -e "s|bugs_evolution_label|${BUGS_EVOLUTION_LABEL}|" > report_tests_1.html

    
    cp ../template/index.html ../template/index2.html 
    rm -rf ../template/index.html
    mv report_tests.html index.html
    cp index.html ../template/
    rm -rf index.html

    cp ../template/chart-morris.html ../template/chart-morris2.html
    rm -rf ../template/chart-morris.html
    mv report_tests_1.html chart-morris.html
    cp chart-morris.html ../template
    rm -rf chart-morris.html
}
