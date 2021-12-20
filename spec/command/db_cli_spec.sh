#shellcheck shell=bash

Describe 'jimbo db:cli'
    It 'fails when invoked without arguments'
        When call jimbo db:cli

        The status should be failure
        The error should include 'Missing argument: path to site or config file'
    End

    It 'fails when invalid option specified'
        When call jimbo db:cli --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call jimbo db:cli foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 1'
    End
End
