app::site::check_site_path_exists_and_readable() {
    if [ ! -r "${1}" ]; then
        app:error:error "Site path not exists or not readable: ${1}"
    fi
}

app::site::check_site_path_is_empty_and_writable() {
    local site_path="${1}"

    if ! [[ -d "${site_path}" ]]; then
        app:error:error "Site path is not exists or not a directory: ${site_path}"
    fi

    if ! [[ -z "$(command ls -A ${site_path})" ]]; then
        app:error:error "Site path is not empty: ${site_path}"
    fi

    if ! [[ -w "${site_path}" ]]; then
        app:error:error "Site path is not writable: ${site_path}"
    fi
}

app::site::detect_site_config() {
    local site_path="${1}"
    local -n _site_config="${2}"

    local plugin=''
    local config=''

    app::site::detect_site_plugin "${site_path}" 'plugin' 'config'

    [[ -z "${plugin}" ]] && return 0

    _site_config[plugin]="${plugin}"
    _site_config[plugin_name]="${plugin##*/}"
    _site_config[root]="${site_path}"

    app::site::load_site_config "${2}" "${plugin##*/}" <<<"${config}"

    app::site::load_site_config_file "${site_path}" 'site_config'
}

app::site::detect_site_plugin() {
    local site_path="${1}"

    local -n _plugin="${2}"
    local -n _plugin_config="${3}"

    local plg plg_conf

    for plg in $(app:plugin:plugins_list); do
        if plg_conf="$(cd "${site_path}" && "${plg}")"; then
            _plugin="${plg}"
            _plugin_config="${plg_conf}"

            return
        fi
    done
}

app::site::load_site_config_file()
{
    local site_path="${1}"
    local -n _site_config="${2}"

    local config_file="$(command find "${site_path}" -maxdepth 1 -type f -name "${app_config_file_pattern}")"

    if [[ -z "${config_file}" ]]; then
        return
    fi

    if [[ "$(wc -l <<<${config_file})" -gt 1 ]]; then
        app:error:error 'More than one site config files present'
    fi

    config_file="$(realpath "${config_file}")"

    _site_config[config_file]="${config_file}"

    app::site::load_site_config "${2}" "${config_file##*/}" < "${config_file}"
}

app::site::load_site_config() {
    local -n _site_config="${1}"
    local src="${2}"

    while IFS=': ' read -r key value; do
        case "${key}" in
            plugin_name )
                _site_config[plugin_name]="${value}"
                ;;
            exclude_paths )
                _site_config[exclude_paths]+="${_site_config[exclude_paths]:+ }${value}"
                ;;
            include_paths )
                _site_config[include_paths]+="${_site_config[include_paths]:+ }${value}"
                ;;
            database_name )
                _site_config[database_name]="${value}"
                ;;
            database_user )
                _site_config[database_user]="${value}"
                ;;
            database_password )
                _site_config[database_password]="${value}"
                ;;
            * )
                app:error:error "${src}: invalid configuration key: ${key}"
                ;;
        esac
    done
}
