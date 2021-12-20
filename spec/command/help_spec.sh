#shellcheck shell=bash

Describe 'jimbo help'
    It 'fails when invalid option specified'
        When call jimbo help --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call jimbo help foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 0'
    End

    It 'shows help'
        When call jimbo help

        The status should be success
        The output should start with 'jimbo: simple backup tool for web sites'
    End
End
