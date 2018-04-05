#! /bin/sh
# file: tests/functional_tests_datas.sh
 
source ../functional_tests_datas.sh

echo "\nExecuting Unit Tests ...\n"

testDoNotExistFolder()
{
 
  PATH_TO_FEATURES="folder_test"  
  assertEquals "$(echo -e "\033[31;1mDo not exist any folder: $PATH_TO_FEATURES \nPlease, set correct folder in config.yml!\033[m")" "$(get_all_features_from_testing_project)"
}

testDoNotExistFeatureInFolder()
{
  mkdir folder_test
  PATH_TO_FEATURES="folder_test"  
  assertEquals "$(echo -e "\033[31;1mDo not exist any feature in folder: $PATH_TO_FEATURES \nPlease, set correct folder in config.yml!\033[m")" "$(get_all_features_from_testing_project)" 
  rm -rf folder_test
}

testFolderWithFeatureIsCreated()
{
    mkdir folder_test
    touch folder_test/file_test.feature
    get_all_features_from_testing_project
    assertTrue "[ -r $FILE_WITH_ALL_FEATURES ]"
}

tearDown()
{
  rm -rf folder_test
  rm -rf $FILE_WITH_ALL_FEATURES
}

# load shunit2
. /usr/local/Cellar/shunit2/2.1.7/bin/shunit2