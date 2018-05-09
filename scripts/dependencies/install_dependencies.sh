#!/bin/bash

function check_jq
{
    if [ -z $(which jq) ]; then
        echo -e "\033[31;1mPlease, install jq to continue, like: brew install jq\n \033[m"
        exit 1
    fi   
}

function check_feature_express
{
    if [ -z $(which feature-express) ]; then
        npm install -g feature-express
    fi
}

function check_all_dependencies
{
    check_jq
    check_feature_express
}
