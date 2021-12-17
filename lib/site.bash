app::use 'error'
app::use 'plugin'
app::use 'util'

app::site::detect_config() {
    local site_path="${1}"

    if ! [[ -e "${site_path}" ]]; then
        app::error::error "Site root or config file not exist: ${site_path}"
    fi

    site_path=$(app::util::realpath "${site_path}")

    site_config[local_config_file_pattern]='*.jimbo.conf'
    site_config[database_dump_file_suffix]='-dump.sql'

    if [[ -d "${site_path}" ]]; then
        site_config[root]="${site_path}"
    else
        if ! [[ -r "${site_path}" ]]; then
            app::error::error "${site_path}: is not readable"
        fi

        site_config[config_file]="${site_path}"
        app::site::load_config "${site_path}" < "${site_path}"

        if [[ -z "${site_config[root]:-}" ]]; then
            app::error::error "${site_path}: site root is not set"
        fi
    fi

    app::site::detect_plugin

    if [[ -n "${site_config[plugin]:-}" ]]; then
        site_config[plugin_name]="${site_config[plugin]##*/}"

        app::site::load_config "${site_config[plugin]}" <<<"${site_config[plugin_config]}"
    fi

    app::site::find_local_config_file

    if [[ -n "${site_config[local_config_file]:-}" ]]; then
        app::site::load_config "${site_config[local_config_file]}" < "${site_config[local_config_file]}"
    fi
}

app::site::detect_plugin() {
    app::site::site_root_exists_and_readable

    local plg plg_conf

    for plg in $(app::plugin::plugins_list); do
        if plg_conf="$(cd "${site_config[root]}" && "${plg}")"; then
            site_config[plugin]="${plg}"
            site_config[plugin_config]="${plg_conf}"

            return
        fi
    done
}

app::site::find_local_config_file() {
    [[ -z "${site_config[local_config_file_pattern]}" ]] && return

    app::site::site_root_exists_and_readable

    local -a config_files=("${site_config[root]}"/${site_config[local_config_file_pattern]})

    [[ "${#config_files[@]}" -eq 0 ]] && return

    if [[ "${#config_files[@]}" -gt 1 ]]; then
        app::error::error "Multiple site config files found: ${config_files[*]}"
    fi

    site_config[local_config_file]="$(realpath "${config_files[0]}")"
}

app::site::load_config() {
    local src="${1}"

    while IFS=': ' read -r key value; do
        case "${key}" in
            plugin_name )
                site_config[plugin_name]="${value}"
                ;;
            root )
                if [[ -n "${site_config[root]:-}" ]]; then
                    app::error::error "${src}: site root is already set"
                fi

                site_config[root]="${value}"
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
            '' )
                continue
                ;;
            * )
                app::error::error "${src}: invalid key: ${key}"
                ;;
        esac
    done
}

app::site::site_root_exists_and_readable() {
    if [[ ! -r "${site_config[root]}" ]]; then
        app::error::error "Site root not exists or not readable: ${site_config[root]}"
    fi
}
