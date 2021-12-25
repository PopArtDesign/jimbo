#shellcheck shell=bash

Describe 'rambo plugins'
    It 'fails when invalid option specified'
        When call rambo plugins --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call rambo plugins foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 0'
    End

    It 'shows help message if -h option specified'
        When call rambo plugins -h

        The status should be success
        The output should start with 'Show available plugins'
    End

    It 'shows help message if --help option specified'
        When call rambo plugins --help

        The status should be success
        The output should start with 'Show available plugins'
    End

    It 'shows plugins list'
        When call rambo plugins

        The status should be success
        The output should include 'joomla'
    End
End
