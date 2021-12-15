app::use 'error'
app::use 'plugin'

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

    site_config[root]="${site_path}"
    site_config[cofig_file_pattern]='*.jimbo.conf'
    site_config[database_dump_file_suffix]='-dump.sql'

    app::site::detect_site_plugin

    [[ -z "${site_config[plugin]:-}" ]] && return 0

    site_config[plugin_name]="${site_config[plugin]##*/}"

    app::site::load_site_config "${site_config[plugin]}" <<<"${site_config[plugin_config]}"

    app::site::find_site_config_file

    [[ -z "${site_config[config_file]:-}" ]] && return 0

    app::site::load_site_config "${site_config[config_file]}" < "${site_config[config_file]}"
}

app::site::detect_site_plugin() {
    local plg plg_conf

    for plg in $(app::plugin::plugins_list); do
        if plg_conf="$(cd "${site_config[root]}" && "${plg}")"; then
            site_config[plugin]="${plg}"
            site_config[plugin_config]="${plg_conf}"

            return
        fi
    done
}

app::site::find_site_config_file() {
    local -a config_files=("${site_config[root]}"/${site_config[cofig_file_pattern]})

    [[ "${#config_files[@]}" -eq 0 ]] && return 0

    if [[ "${#config_files[@]}" -gt 1 ]]; then
        app::error::error "Multiple site config files found: ${config_files[*]}"
    fi

    site_config[config_file]="$(realpath "${config_files[0]}")"
}

app::site::load_site_config() {
    local src="${1}"

    while IFS=': ' read -r key value; do
        case "${key}" in
            plugin_name )
                site_config[plugin_name]="${value}"
                ;;
            exclude )
                site_config[exclude]+="${site_config[exclude]:+ }${value}"
                ;;
            include )
                site_config[include]+="${site_config[include]:+ }${value}"
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
