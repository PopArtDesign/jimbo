#shellcheck shell=bash

Describe 'jimbo detect'
    It 'fails when invoked without arguments'
        When call jimbo detect

        The status should be failure
        The error should include 'Missing argument: path to site or config file'
    End

    It 'fails when invalid option specified'
        When call jimbo detect --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call jimbo detect foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 1'
    End

    It 'shows help message if -h option specified'
        When call jimbo detect -h

        The status should be success
        The output should start with "Detect site's configuration"
    End

    It 'shows help message if --help option specified'
        When call jimbo detect --help

        The status should be success
        The output should start with "Detect site's configuration"
    End
End
