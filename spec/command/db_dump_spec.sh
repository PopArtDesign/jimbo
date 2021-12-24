#shellcheck shell=bash

Describe 'jimbo db:dump'
    It 'fails when invoked without arguments'
        When call jimbo db:dump

        The status should be failure
        The error should include 'Missing argument: path to site or config file'
    End

    It 'fails when invalid option specified'
        When call jimbo db:dump --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call jimbo db:dump foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 1'
    End

    It 'shows help message if -h option specified'
        When call jimbo db:dump -h

        The status should be success
        The output should start with "Dump site's database"
    End

    It 'shows help message if --help option specified'
        When call jimbo db:dump --help

        The status should be success
        The output should start with "Dump site's database"
    End
End
