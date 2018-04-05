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

testShouldGetFeatureNameinPortuguese()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  echo "Funcionalidade: FeatureName" >> $PATH_TO_FEATURES$LINE
  get_feature_name
  assertEquals "FeatureName" "$FEATURE_NAME"
}

testShouldGetFeatureNameinEnglish()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  echo "Feature: FeatureName" >> $PATH_TO_FEATURES$LINE
  get_feature_name
  assertEquals "FeatureName" "$FEATURE_NAME"
}

testShouldGetFeatureNameWithSpaces()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  echo "Feature: Feature de Name" >> $PATH_TO_FEATURES$LINE
  get_feature_name
  assertEquals "Feature de Name" "$FEATURE_NAME"
}

testShouldGetTotalNumberOfScenariosinPortuguese()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  PLATFORM_NAME="android"
  echo "Feature: Feature de Name" >> $PATH_TO_FEATURES$LINE
  echo "@android" >> $PATH_TO_FEATURES$LINE
  echo "Cenário: Exemplo 1 de Cenário" >> $PATH_TO_FEATURES$LINE
  echo "@android" >> $PATH_TO_FEATURES$LINE
  echo "Cenário: Exemplo 2 de Cenário" >> $PATH_TO_FEATURES$LINE
  get_total_number_of_scenarios_by_feature
  assertEquals "2" "$SCENARIOS_TOTAL_BY_FEATURE"
}

testShouldGetTotalNumberOfScenariosinEnglish()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  PLATFORM_NAME="android"
  echo "Feature: Feature de Name" >> $PATH_TO_FEATURES$LINE
  echo "@android" >> $PATH_TO_FEATURES$LINE
  echo "Scenario: Exemplo 1 de Cenário" >> $PATH_TO_FEATURES$LINE
  echo "@android" >> $PATH_TO_FEATURES$LINE
  echo "Scenario: Exemplo 2 de Cenário" >> $PATH_TO_FEATURES$LINE
  get_total_number_of_scenarios_by_feature
  assertEquals "2" "$SCENARIOS_TOTAL_BY_FEATURE"
}

testShouldGetErroForNotFoundPlatformName()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  PLATFORM_NAME="android"
  echo "Feature: Feature de Name" >> $PATH_TO_FEATURES$LINE
  echo "@ios" >> $PATH_TO_FEATURES$LINE
  echo "Cenário: Exemplo 1 de Cenário" >> $PATH_TO_FEATURES$LINE
  echo "@ios" >> $PATH_TO_FEATURES$LINE
  echo "Cenário: Exemplo 2 de Cenário" >> $PATH_TO_FEATURES$LINE
  assertEquals "$(echo -e "\033[31;1mThe Platform name tag: $PLATFORM_NAME was not found in '.feature' files. \nPlease, set correct platform name in config.yml and/or add this tag for all scenarios already implemented!\033[m")" "$(get_total_number_of_scenarios_by_feature)" 
}

testShouldReturnZeroForPlatformNameEmpty()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  PLATFORM_NAME=""
  echo "Feature: Feature de Name" >> $PATH_TO_FEATURES$LINE
  echo "Cenário: Exemplo 1 de Cenário" >> $PATH_TO_FEATURES$LINE
  echo "Cenário: Exemplo 2 de Cenário" >> $PATH_TO_FEATURES$LINE
  get_total_number_of_scenarios_by_feature
  assertEquals "0" "$SCENARIOS_TOTAL_BY_FEATURE"
}

testShouldCreateFileWritingEmptyFile()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  PLATFORM_NAME=""
  get_scenario_names_by_feature
  assertEquals "EmptyFile" "$(cat $FILE_WITH_SCENARIO_NAMES_BY_FEATURE)"
}

testShouldReturnFileWithScenarioNames()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  PLATFORM_NAME="android"
  echo "Feature: Feature de Name" >> $PATH_TO_FEATURES$LINE
  echo "@android" >> $PATH_TO_FEATURES$LINE
  echo "Cenário: Exemplo 1 de Cenário" >> $PATH_TO_FEATURES$LINE
  get_scenario_names_by_feature
  assertEquals "Cenário: Exemplo 1 de Cenário" "$(cat $FILE_WITH_SCENARIO_NAMES_BY_FEATURE)"
}

tearDown()
{
  rm -rf folder_test
  rm -rf $FILE_WITH_ALL_FEATURES
  rm -rf $FILE_WITH_SCENARIO_NAMES_BY_FEATURE
}

# load shunit2
. /usr/local/Cellar/shunit2/2.1.7/bin/shunit2