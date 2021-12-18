#shellcheck shell=bash

app_name=jimbo
app_libs_path=./lib

Include ./common.bash
Include ./lib/site.bash

Describe 'app::site::load_config'
    beforeEach() {
        declare -gA site_config=()
    }

    BeforeEach 'beforeEach'

    It 'fails when invalid key is encountered'
        Data:raw
            #|root: /tmp
            #|foo: bar
        End

        When call app::site::load_config 'base'

        The status should be failure
        The error should include 'base: invalid key: foo'
    End
End
