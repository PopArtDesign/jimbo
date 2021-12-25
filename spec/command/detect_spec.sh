#shellcheck shell=bash

Describe 'rambo detect'
    It 'fails when invoked without arguments'
        When call rambo detect

        The status should be failure
        The error should include 'Missing argument: path to site or config file'
    End

    It 'fails when invalid option specified'
        When call rambo detect --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call rambo detect foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 1'
    End

    It 'shows help message if -h option specified'
        When call rambo detect -h

        The status should be success
        The output should start with "Detect site's configuration"
    End

    It 'shows help message if --help option specified'
        When call rambo detect --help

        The status should be success
        The output should start with "Detect site's configuration"
    End
End
