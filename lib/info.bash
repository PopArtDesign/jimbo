app::use 'util'

app::info::plugin() {
    local -n _="${1:-site_config}"

    if [[ "${verbose:-true}" == 'false' ]]; then
        echo "Plugin: ${_[plugin_name]:-default (zip)}"

        return
    fi

    app::info::header 'Plugin'

    echo "Name: ${_[plugin_name]:-default (zip)}"
    echo "Path: ${_[plugin]:-~}"
}

app::info::site() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        return
    fi

    local -n _="${1:-site_config}"

    app::info::header 'Site'

    local config_file="${_[config_file]:-~}"

    echo "Path:        ${_[root]:-~}"
    echo "Config file: ${config_file##*/}"
    echo "Excluded:    ${_[exclude_paths]:-~}"
    echo "Included:    ${_[include_paths]:-~}"
}

app::info::database() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        return
    fi

    local -n _="${1:-site_config}"

    app::info::header 'Database'

    local database_password="${_[database_password]:-}"

    if ! [ "${2:-}" = '--show-password' ]; then
        database_password="$(app::util::mask_str "${database_password}")"
    fi

    echo "Name:     ${_[database_name]:-~}"
    echo "User:     ${_[database_user]:-~}"
    echo "Password: ${database_password:-~}"
}

app::info::backup() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        return
    fi

    app::info::header 'Backup'

    echo "File: ${backup_file:-~}"
}

app::info::result() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        echo
    else
        app::info::header 'Result'
    fi

    command ls -sh "${backup_file}" 2>/dev/null
}

app::info::header() {
    printf "\n### %s\n\n" "${1}"
}
