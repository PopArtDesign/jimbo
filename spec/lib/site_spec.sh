#shellcheck shell=bash

app_name=jimbo
app_libs_path=./lib

Include ./common.bash
Include ./lib/site.bash

Describe 'app::site::load_config'
    Set 'errexit:on'

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

        When run app::site::load_config '/usr/local/etc/jimbo/cool-site.conf' 'main'

        The status should be failure
        The error should include '/usr/local/etc/jimbo/cool-site.conf: invalid key: foo'
    End

    It "doesn't allow \"plugin_name\" key in main config"
        Data:raw
            #|plugin_name: Hey!
            #|exclude: .git
        End

        When run app::site::load_config '/usr/local/etc/jimbo/cool-site.conf' 'main'

        The status should be failure
        The error should include '/usr/local/etc/jimbo/cool-site.conf: key "plugin_name" allowed only for plugins'
    End

    It "doesn't allow \"root\" key in plugin config"
        Data:raw
            #|root: /tmp
            #|exclude: .git
        End

        When run app::site::load_config 'joomla' 'plugin'

        The status should be failure
        The error should include 'joomla: key "root" allowed only in main config file'
    End

    It "doesn't allow \"plugin\" key in plugin config"
        Data:raw
            #|plugin: /bin/true
            #|plugin_name: True Plugin
            #|exclude: *
        End

        When run app::site::load_config 'true-plugin' 'plugin'

        The status should be failure
        The error should include 'true-plugin: key "plugin" not allowed for plugins'
    End

    It "doesn't allow \"local_config_pattern\" key in plugin config"
        Data:raw
            #|plugin_name: True Plugin
            #|local_config_pattern: xxx.jimbo.conf
            #|exclude: *
        End

        When run app::site::load_config 'true-plugin' 'plugin'

        The status should be failure
        The error should include 'true-plugin: key "local_config_pattern" allowed only in main config file'
    End

    It "doesn't allow \"root\" key in local config file"
        Data:raw
            #|root: /tmp
            #|exclude: .git
        End

        When run app::site::load_config '/var/www/mysite/xxx.jimbo.conf' 'local'

        The status should be failure
        The error should include '/var/www/mysite/xxx.jimbo.conf: key "root" allowed only in main config file'
    End

    It "doesn't allow \"plugin_name\" key in local config"
        Data:raw
            #|plugin_name: Hey!
            #|exclude: .git
        End

        When run app::site::load_config '/var/www/mysite/xxx.jimbo.conf' 'local'

        The status should be failure
        The error should include '/var/www/mysite/xxx.jimbo.conf: key "plugin_name" allowed only for plugins'
    End

    It "doesn't allow \"local_config_pattern\" key in local config file"
        Data:raw
            #|exclude: .git
            #|local_config_pattern: *.jumbo.conf
        End

        When run app::site::load_config '/var/www/mysite/xxx.jimbo.conf' 'local'

        The status should be failure
        The error should include '/var/www/mysite/xxx.jimbo.conf: key "local_config_pattern" allowed only in main config file'
    End
End
