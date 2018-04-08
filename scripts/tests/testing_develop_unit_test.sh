#! /bin/sh

echo "\nExecuting Unit Tests ...\n"

source ../develop/unit_test.sh

testShouldReturnTrueForExistIOSUnitTestTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "ios_unit_test_report:" >> config.yml
    setup_develop_envs
    check_tag_for_ios_unit_test
    assertEquals "true" "$IOS_STATUS_UNIT_TEST"
}

testShouldReturnFalseForExistIOSUnitTestTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    setup_develop_envs
    check_tag_for_ios_unit_test
    assertEquals "false" "$IOS_STATUS_UNIT_TEST"
}

testShouldReturnDoYouMeanForExisIOStUnitTestTagPart()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "ios_unit_test_:" >> config.yml
    setup_develop_envs
    assertEquals "$(echo -e "\033[33;1mDo you mean? ios_unit_test_report\033[m")" "$(check_tag_for_ios_unit_test)"
}

testShouldReturnTrueForExistAndroidUnitTestTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "android_unit_test_report:" >> config.yml
    setup_develop_envs
    check_tag_for_android_unit_test
    assertEquals "true" "$ANDROID_STATUS_UNIT_TEST"
}

testShouldReturnFalseForExistAndroidUnitTestTag()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    setup_develop_envs
    check_tag_for_android_unit_test
    assertEquals "false" "$ANDROID_STATUS_UNIT_TEST"
}

testShouldReturnDoYouMeanForExisAndroidtUnitTestTagPart()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "android_unit_test_:" >> config.yml
    setup_develop_envs
    assertEquals "$(echo -e "\033[33;1mDo you mean? android_unit_test_report\033[m")" "$(check_tag_for_android_unit_test)"
}

testNotFoundIOSUnitTestFile()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "ios_unit_test_report: notexistfile.html" >> config.yml
    setup_develop_envs
    echo $IOS_UNIT_TEST_REPORT
    assertEquals "$(echo -e "\033[31;1mFile not found in: '$IOS_UNIT_TEST_REPORT' in tag: 'ios_unit_test_report'. \nPlease, set a correct path to unit test file or remove this tag from config.yml \033[m")" "$(check_file_of_ios_unit_test)"
}

testNotFoundAndroidUnitTestFile()
{
    touch config.yml
    echo "Parameters:" >> config.yml
    echo "android_unit_test_report: notexistfile.html" >> config.yml
    setup_develop_envs
    assertEquals "$(echo -e "\033[31;1mFile not found in: '$ANDROID_UNIT_TEST_REPORT' in tag: 'android_unit_test_report'. \nPlease, set a correct path to unit test file or remove this tag from config.yml \033[m")" "$(check_file_of_android_unit_test)"
}

tearDown()
{
    rm -rf config.yml
}

# load shunit2
. /usr/local/Cellar/shunit2/2.1.7/bin/shunit2