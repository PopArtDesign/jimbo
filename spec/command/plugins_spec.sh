#shellcheck shell=bash

Describe 'jimbo plugins'
    It 'fails when invalid option specified'
        When call jimbo plugins --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call jimbo plugins foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 0'
    End

    It 'shows plugins list'
        When call jimbo plugins

        The status should be success
        The output should include 'joomla'
    End
End
