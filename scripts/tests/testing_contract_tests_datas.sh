#! /bin/sh

echo "\nExecuting Unit Tests ...\n"

source ../contract/endpoints_data.sh

testShouldReturnTrueForExistContractTestTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "path_to_contract_test:" >> config.yml
    setup_contract_envs
    check_tag_for_contract_test
    assertEquals "true" "$STATUS_CONTRACT_TESTING"
}

testShouldReturnFalseForExistContractTestTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    setup_contract_envs
    check_tag_for_contract_test
    assertEquals "false" "$STATUS_CONTRACT_TESTING"
}

testShouldReturnDoYouMeanForExistContractTestTagPart()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "path_to_contract_t:" >> config.yml
    setup_contract_envs
    assertEquals "$(echo -e "\033[33;1mDo you mean? path_to_contract_test\033[m")" "$(check_tag_for_contract_test)"
}

testErrorForNotExistFolderOfContractTest()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "path_to_contract_test: folder/" >> config.yml
    setup_contract_envs
    assertEquals "$(echo -e "\033[31;1mFolder not found in: '$PATH_TO_CONTRACT_TEST' in tag: 'path_to_contract_test'. \nPlease, set a correct path to contract test or remove this tag from config.yml \033[m")" "$(check_folder_of_contract_test)"
}

testErrorDoNotExistFileNamesWithTesting()
{
    mkdir folder_test
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "path_to_contract_test: folder_test" >> config.yml
    setup_contract_envs
    touch testin.js
    cp testin.js $PATH_TO_CONTRACT_TEST
    assertEquals "$(echo -e "\033[31;1mIt was not found any file named with 'testing' in folder: '$PATH_TO_CONTRACT_TEST' \nPlease set correct folder with contrac tests or add 'testing' in all contract test file names!\033[m")" "$(get_testing_files_name)"   
}

testReturnFileWithContractTestFileNames()
{
    mkdir folder_test
    touch config.yml
    FILE_WITH_TESTING_FILES_NAMES="tests.txt"
    echo "Parameters:" >> config.yml
    echo "path_to_contract_test: folder_test" >> config.yml
    setup_contract_envs
    touch testing.js
    cp testing.js $PATH_TO_CONTRACT_TEST
    get_testing_files_name
    assertEquals "testing.js" "$(cat $FILE_WITH_TESTING_FILES_NAMES)"
}

tearDown()
{
    rm -rf config.yml
    rm -rf folder_test
    rm -rf testin.js
    rm -rf testing.js
    rm -rf $FILE_WITH_TESTING_FILES_NAMES
}


# load shunit2
. /usr/local/Cellar/shunit2/2.1.7/bin/shunit2