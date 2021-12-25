#shellcheck shell=bash

Describe 'rambo help'
    It 'fails when invalid option specified'
        When call rambo help --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call rambo help foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 0'
    End

    It 'shows help'
        When call rambo help

        The status should be success
        The output should start with 'rambo: simple backup tool for web sites'
    End
End
