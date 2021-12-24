#shellcheck shell=bash

Describe 'jimbo restore'
    It 'fails when invoked without arguments'
        When call jimbo restore

        The status should be failure
        The error should include 'Missing argument: path to site or config file'
    End

    It 'fails when invalid option specified'
        When call jimbo restore --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call jimbo restore foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 2'
    End

    It 'fails when path to backup file not specified'
        When call jimbo restore foo

        The status should be failure
        The error should include 'Missing argument: path to backup file'
    End

    It 'fails when backup file not exists'
        When call jimbo restore ./fixture /i/hope/this/file/not/exists.zip

        The status should be failure
        The error should match pattern '*Backup file not exists or not readable: */i/hope/this/file/not/exists.zip*'
    End

    It 'shows help message if -h option specified'
        When call jimbo restore -h

        The status should be success
        The output should start with 'Restore site'
    End

    It 'shows help message if --help option specified'
        When call jimbo restore --help

        The status should be success
        The output should start with 'Restore site'
    End
End
