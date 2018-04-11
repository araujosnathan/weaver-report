#! /bin/sh

echo "\nExecuting Unit Tests ...\n"

source ../jira/jira_data.sh

testShouldReturnTrueForExistJiraServerTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "jira_server:" >> config.yml
    setup_jira_envs
    check_tag_jira_server
    assertEquals "true" "$STATUS_JIRA"
}

testShouldReturnFalseForExistJiraServerTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    setup_jira_envs
    check_tag_jira_server
    assertEquals "false" "$STATUS_JIRA"
}

testShouldReturnDoYouMeanForExistJiraServerTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "jira:" >> config.yml
    setup_jira_envs
    assertEquals "$(echo -e "\033[33;1mDo you mean? jira_server\033[m")" "$(check_tag_jira_server)"
}

testShouldReturnDoYouMeanForExistJiraUserTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "jira_server:" >> config.yml
    echo "jira_us:" >> config.yml
    setup_jira_envs
    check_tag_jira_server
    assertEquals "$(echo -e "\033[33;1mDo you mean? jira_user\033[m")" "$(check_tag_jira_user)"
}

testErrorDoNotSetJiraUserTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "jira_server:" >> config.yml
    setup_jira_envs
    check_tag_jira_server
    assertEquals "$( echo -e "\033[31;1mYou have set jira server but NOT set jira user! please, set user or remove jira tag from config.yml!\033[m")" "$(check_tag_jira_user)"
}

testShouldReturnDoYouMeanForExistJiraPasswordTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "jira_server:" >> config.yml
    echo "jira_user:" >> config.yml
    echo "jira_pass:" >> config.yml
    setup_jira_envs
    check_tag_jira_server
    check_tag_jira_user
    assertEquals "$(echo -e "\033[33;1mDo you mean? jira_password\033[m")" "$(check_tag_jira_password)"
}

testErrorDoNotSetJiraPasswordTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "jira_server:" >> config.yml
    echo "jira_user:" >> config.yml
    setup_jira_envs
    check_tag_jira_server
    check_tag_jira_user
    assertEquals "$(echo -e "\033[31;1mYou have set jira server/user but NOT set jira password! please, set password or remove jira tag from config.yml!\033[m")" "$(check_tag_jira_password)"
}

tearDown()
{
    rm -rf config.yml
}

# load shunit2
. /usr/local/Cellar/shunit2/2.1.7/bin/shunit2