#shellcheck shell=bash

backup_file_name() {
    TMPDIR="${SHELLSPEC_TMPBASE}" mktemp --dry-run --suffix '.zip'
}

backup_content() {
    zipinfo -1 "${backup_file}" | sort
}

Describe 'jimbo backup'
    It 'fails when invoked without arguments'
        When call jimbo backup

        The status should be failure
        The error should include 'Missing argument: path to site or config file'
    End

    It 'fails when invalid option specified'
        When call jimbo backup --hello

        The status should be failure
        The error should include 'Unknown option: --hello'
    End

    It 'fails when too many arguments specified'
        When call jimbo backup foo bar baz

        The status should be failure
        The error should include 'Too many arguments. Expected: 2'
    End

    It 'fails when backup file has no .zip extension'
        When call jimbo backup my-site my-backup

        The status should be failure
        The error should match pattern '*Backup file must have .zip extension: */my-backup*'
    End

    It 'fails when backup file already exists'
        When call jimbo backup ./lib ./fixture/empty.zip

        The status should be failure
        The error should match pattern '*Backup file already exists: */fixture/empty.zip*'
    End

    It 'shows help message if -h option specified'
        When call jimbo backup -h

        The status should be success
        The output should start with 'Backup site'
    End

    It 'shows help message if --help option specified'
        When call jimbo backup --help

        The status should be success
        The output should start with 'Backup site'
    End

    It "backups all site's files if no configuration provided"
        backup_file="$(backup_file_name)"

        When call jimbo backup ./fixture/simple-site "${backup_file}"

        The status should be success
        The output should end with "Done: ${backup_file}"
        The file "${backup_file}" should be file
        The result of "backup_content()" should equal $'css/\ncss/style.css\nindex.html'
    End

    It "excludes specified site's files"
        backup_file="$(backup_file_name)"

        Data:expand
            #|root: ${SHELLSPEC_PROJECT_ROOT}/fixture/simple-site
            #|exclude: *.css
        End

        When call jimbo backup /dev/stdin "${backup_file}"

        The status should be success
        The output should end with "Done: ${backup_file}"
        The file "${backup_file}" should be file
        The result of "backup_content()" should equal $'css/\nindex.html'
    End
End
