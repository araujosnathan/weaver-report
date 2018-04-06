#! /bin/sh
 
source ../functional/testing_data.sh

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

testShouldFalseforNotExistFeatureNameInOfficialDocument()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  echo "Feature: Feature de Name" >> $PATH_TO_FEATURES$LINE
  get_feature_name
  PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS="official_document.txt"
  touch $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "ID  Funcionalidade  Cenario" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "1 RightFeature  Scenario1" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "2 RightFeature  Scenario2" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "3 AnyFeature  Scenario3" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  check_feature_name_in_official_document
  assertEquals "false" "$STATUS"
}

testShouldTrueforNotExistFeatureNameInOfficialDocument()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test/"
  LINE="file_test.feature"
  echo "Feature: AnyFeature" >> $PATH_TO_FEATURES$LINE
  get_feature_name
  PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS="official_document.txt"
  touch $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "ID  Funcionalidade  Cenario" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "1 RightFeature  Scenario1" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "2 RightFeature  Scenario2" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "3 AnyFeature  Scenario3" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  check_feature_name_in_official_document
  assertEquals "true" "$STATUS"
}


testShouldErrorForNotExistFile()
{
  mkdir folder_test
  touch folder_test/file_test.feature
  PATH_TO_FEATURES="folder_test"
  LINE="file_test.feature"
  assertEquals "$(echo -e "\033[31;1mThis file: '$PATH_TO_FEATURES$LINE' do not exist. Please check this path!\033[m")" "$(get_feature_name)"
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
  get_total_number_of_scenarios_by_feature
  assertEquals "0" "$SCENARIOS_TOTAL_BY_FEATURE"
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

testShouldWarningThatFeatureNotFoundInOfficialDocument()
{
  FEATURE_NAME="WrongFeature"
  PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS="official_document.txt"
  touch $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "ID  Funcionalidade  Cenario" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "1 RightFeature  Scenario1" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  get_total_number_of_scenarios_from_official_document_by_feature
  assertEquals "0" "$TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE"
}

testShoulReturnTotalNumberOfScenariosInOfficialDocumentByFeature()
{
  FEATURE_NAME="RightFeature"
  PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS="official_document.txt"
  touch $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "ID  Funcionalidade  Cenario" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "1 RightFeature  Scenario1" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "2 RightFeature  Scenario2" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  echo "3 AnyFeature  Scenario3" >> $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
  get_total_number_of_scenarios_from_official_document_by_feature
  assertEquals "2" "$TOTAL_NUMBER_OF_SCENARIOS_FROM_OFFICIAL_DOCUMENT_BY_FEATURE"
}

tearDown()
{
  rm -rf folder_test
  rm -rf $FILE_WITH_ALL_FEATURES
  rm -rf $FILE_WITH_SCENARIO_NAMES_BY_FEATURE
  rm -rf $PATH_TO_OFFICIAL_DOCUMENT_OF_SCENARIOS
}

# load shunit2
. /usr/local/Cellar/shunit2/2.1.7/bin/shunit2