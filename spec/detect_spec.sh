#shellcheck shell=sh

Describe 'jimbo detect'
    It 'shows error message when invoked without arguments'
        When call jimbo detect

        The status should be failure
        The error should start with 'jimbo ERROR: Missing argument: path to site or config file'
    End

    It 'shows error message when invalid option specified'
        When call jimbo detect --hello

        The status should be failure
        The error should start with 'jimbo ERROR: Unknown option: --hello'
    End

    It 'shows error message when too many arguments specified'
        When call jimbo detect foo bar baz

        The status should be failure
        The error should start with 'jimbo ERROR: Too many arguments. Expected: 1'
    End

    It 'shows error message when specified site path not exists'
        When call jimbo detect /this/path/is/not/exist

        The status should be failure
        The error should start with 'jimbo ERROR: Site root or config file not exist: /this/path/is/not/exist'
    End
End
