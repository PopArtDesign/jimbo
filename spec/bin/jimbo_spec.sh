#shellcheck shell=bash

Describe 'jimbo'
    It 'fails when invoked without arguments'
        When call jimbo

        The status should be failure
        The error should include 'Missing argument: command. Try --help for more information'
    End

    It 'fails when command not found'
        When call jimbo hello

        The status should be failure
        The error should include 'Unknown command: hello'
    End

    It 'fails when invalid option specified'
        When call jimbo --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'shows help when -h option specified'
        When call jimbo -h

        The status should be success
        The output should start with 'jimbo: simple backup tool for web sites'
    End

    It 'shows help when --help option specified'
        When call jimbo --help

        The status should be success
        The output should start with 'jimbo: simple backup tool for web sites'
    End

    It 'executes specified command'
        When call jimbo help

        The status should be success
        The output should start with 'jimbo: simple backup tool for web sites'
    End
End
