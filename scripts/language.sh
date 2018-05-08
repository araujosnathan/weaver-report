#!/bin/bash

CONTENT=$(cat weaver_languages.json | jq ".$1")
if [ ! "$CONTENT" = "null" ]; then
    FUNCTIONAL_COVERAGE_LABEL=$(cat weaver_languages.json | jq ".$1.functional_testing_coverage" | tr '"' " " | sed 's/ //')
    CONTRACT_COVERAGE_LABEL=$(cat weaver_languages.json | jq ".$1.contract_tesgint_coverage" | tr '"' " " | sed 's/ //')
else
    echo -e "\033[31;1mNot found language '$1'\Please, set correct language parameter!\n \033[m"
    exit 1
fi

echo $FUNCTIONAL_COVERAGE_LABEL
echo $CONTRACT_COVERAGE_LABEL