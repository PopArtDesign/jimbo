app::site::check_site_path_exists_and_readable() {
    if [ ! -r "${1}" ]; then
        app::error::error "Site path not exists or not readable: ${1}"
    fi
}

app::site::check_site_path_is_empty_and_writable() {
    local site_path="${1}"

    if ! [[ -d "${site_path}" ]]; then
        app::error::error "Site path is not exists or not a directory: ${site_path}"
    fi

    if ! [[ -z "$(command ls -A ${site_path})" ]]; then
        app::error::error "Site path is not empty: ${site_path}"
    fi

    if ! [[ -w "${site_path}" ]]; then
        app::error::error "Site path is not writable: ${site_path}"
    fi
}

app::site::detect_site_config() {
    local site_path="${1}"

    local site_plugin=''
    local site_plugin_config=''

    app::site::detect_site_plugin "${site_path}"

    [[ -z "${site_plugin}" ]] && return 0

    site_config[plugin]="${site_plugin}"
    site_config[plugin_name]="${site_plugin##*/}"
    site_config[root]="${site_path}"

    app::site::load_site_config "${site_plugin}" <<<"${site_plugin_config}"

    local site_config_file=''

    app::site::find_site_config_file "${site_path}"

    [[ -z "${site_config_file}" ]] && return 0

    site_config[config_file]="${site_config_file}"

    app::site::load_site_config "${site_config_file}" < "${site_config_file}"
}

app::site::detect_site_plugin() {
    local site_path="${1}"

    local plg plg_conf

    for plg in $(app::plugin::plugins_list); do
        if plg_conf="$(cd "${site_path}" && "${plg}")"; then
            site_plugin="${plg}"
            site_plugin_config="${plg_conf}"

            return
        fi
    done
}

app::site::find_site_config_file() {
    local site_path="${1}"

    local -a config_files=("${site_path}"/${app_config_file_pattern})

    [[ "${#config_files[@]}" -eq 0 ]] && return 0

    if [[ "${#config_files[@]}" -gt 1 ]]; then
        app::error::error "Multiple site config files found: ${config_files[*]}"
    fi

    site_config_file="$(realpath "${config_files[0]}")"
}

app::site::load_site_config() {
    local src="${1}"

    while IFS=': ' read -r key value; do
        case "${key}" in
            plugin_name )
                site_config[plugin_name]="${value}"
                ;;
            exclude_paths )
                site_config[exclude_paths]+="${site_config[exclude_paths]:+ }${value}"
                ;;
            include_paths )
                site_config[include_paths]+="${site_config[include_paths]:+ }${value}"
                ;;
            database_name )
                site_config[database_name]="${value}"
                ;;
            database_user )
                site_config[database_user]="${value}"
                ;;
            database_password )
                site_config[database_password]="${value}"
                ;;
            * )
                app::error::error "${src}: invalid configuration key: ${key}"
                ;;
        esac
    done
}
