#shellcheck shell=sh

Describe 'jimbo'
    It 'shows error message when invoked without arguments'
        When call jimbo

        The status should be failure
        The error should start with 'jimbo ERROR: Missing argument: command. Try --help for more information'
    End

    It 'shows error message when command not found'
        When call jimbo hello

        The status should be failure
        The error should start with 'jimbo ERROR: Unknown command: hello'
    End

    It 'shows error message when invalid option specified'
        When call jimbo --hello

        The status should be failure
        The error should start with 'jimbo ERROR: Unknown option: --hello'
    End

    It 'shows help when --help option specified'
        When call jimbo -h

        The status should be success
        The output should start with 'jimbo: simple backup tool for web sites'
    End

    It 'shows help when --help option specified'
        When call jimbo --help

        The status should be success
        The output should start with 'jimbo: simple backup tool for web sites'
    End

    It 'shows help when help command specified'
        When call jimbo help

        The status should be success
        The output should start with 'jimbo: simple backup tool for web sites'
    End
End
