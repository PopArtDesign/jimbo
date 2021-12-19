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

    It 'saves config values to special variable "site_config"'
        Data:raw
            #|root: /tmp
            #|exclude: /cache
            #|include: index.html
        End

        When call app::site::load_config 'site.conf' 'main'

        The status should be success
        The value "${#site_config[@]}" should equal 3
        The value "${site_config[root]:-}" should equal '/tmp'
        The value "${site_config[exclude]:-}" should equal '/cache'
        The value "${site_config[include]:-}" should equal 'index.html'
    End

    It 'appends "include" and "exclude"'
        load_config() {
            app::site::load_config 'site.conf' 'main' <<CONFIG
exclude: /cache .cache
include: index.html
CONFIG

            app::site::load_config 'joomla' 'plugin' <<CONFIG
exclude: *.zip .git
include: *.php
CONFIG
        }

        When call load_config

        The status should be success
        The value "${site_config[exclude]:-}" should equal '/cache .cache *.zip .git'
        The value "${site_config[include]:-}" should equal 'index.html *.php'
    End

    It 'ignores empty lines'
        Data:raw
            #|
            #|root: /tmp
            #|   
            #|
            #|exclude: .git
            #|
        End

        When call app::site::load_config 'site.conf' 'main'

        The status should be success
        The value "${site_config[*]}" should equal '.git /tmp'
    End

    It 'ignores comments'
        Data:raw
            #|#
            #|# Site's root
            #|#
            #|root: /tmp
            #|# Exclude GIT repos
            #|exclude: .git
        End

        When call app::site::load_config 'site.conf' 'main'

        The status should be success
        The value "${site_config[*]}" should equal '.git /tmp'
    End

    It 'fails when invalid key is encountered'
        Data:raw
            #|root: /tmp
            #|foo: bar
        End

        When call app::site::load_config '/usr/local/etc/jimbo/cool-site.conf' 'main'

        The status should be failure
        The error should include '/usr/local/etc/jimbo/cool-site.conf: invalid key: foo'
    End
End
