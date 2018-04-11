#!/bin/bash

function setup_jira_envs
{
    JIRA_SERVER=$(cat config.yml | grep jira_server | awk '{print $2}')
    JIRA_USER=$(cat config.yml | grep jira_user | awk '{print $2}')
    JIRA_PASSWORD=$(cat config.yml | grep jira_password | awk '{print $2}')
}

function check_tag_jira_server
{
    CONTENT=$(cat config.yml | grep jira_server)
    if [ -z "$CONTENT" ]; then
      CONTENT_FILE=$(cat config.yml)
      if [[ $CONTENT_FILE =~ "jira" || $CONTENT_FILE =~ "server" || $CONTENT_FILE =~ "jira_ser" ]]; then
        echo -e "\033[33;1mDo you mean? jira_server\033[m"
        exit 1
      else
        STATUS_JIRA="false"
      fi
    else
        STATUS_JIRA="true"
    fi
}

function check_tag_jira_user
{
    if [ "$STATUS_JIRA" = "true" ]; then
        CONTENT=$(cat config.yml | grep jira_user)
        if [ -z "$CONTENT" ]; then
            CONTENT_FILE=$(cat config.yml)
            if [[ $CONTENT_FILE =~ "user" || $CONTENT_FILE =~ "jira_us" ]]; then
                echo -e "\033[33;1mDo you mean? jira_user\033[m"
                exit 1
            else
                echo -e "\033[31;1mYou have set jira server but NOT set jira user! please, set user or remove jira tag from config.yml!\033[m"
                exit 1
            fi
        fi
    fi

}

function check_tag_jira_password
{
    if [ "$STATUS_JIRA" = "true" ]; then
        CONTENT=$(cat config.yml | grep jira_password)
        if [ -z "$CONTENT" ]; then
            CONTENT_FILE=$(cat config.yml)
            if [[ $CONTENT_FILE =~ "password" || $CONTENT_FILE =~ "jira_pass" ]]; then
                echo -e "\033[33;1mDo you mean? jira_password\033[m"
                exit 1
            else
                echo -e "\033[31;1mYou have set jira server/user but NOT set jira password! please, set password or remove jira tag from config.yml!\033[m"
                exit 1
            fi
        fi
    fi

}
 