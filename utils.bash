app_zip() {
    command zip -qr "-${COMPRESSION_LEVEL:-9}" "$@"
}

app_unzip() {
    command unzip -q "$@"
}

app_header_plugin() {
    local -n _="${1:-site_config}"

    if [[ "${verbose:-true}" == 'false' ]]; then
        echo "Plugin: ${_[plugin_name]:-default (zip)}"

        return
    fi

    app_header 'Plugin'

    echo "Name: ${_[plugin_name]:-default (zip)}"
    echo "Path: ${_[plugin]:-~}"
}

app_header_paths() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        return
    fi

    local -n _="${1:-site_config}"

    app_header 'Paths'

    echo "Root:     ${_[root]:-~}"
    echo "Excluded: ${_[exclude_paths]:-~}"
    echo "Included: ${_[include_paths]:-~}"
}

app_header_database() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        return
    fi

    local -n _="${1:-site_config}"

    app_header 'Database'

    local database_password="${_[database_password]:-}"

    if ! [ "${2:-}" = '--show-password' ]; then
        database_password="$(app_repeat_str '*' ${#database_password})"
    fi

    echo "Name:     ${_[database_name]:-~}"
    echo "User:     ${_[database_user]:-~}"
    echo "Password: ${database_password:-~}"
}

app_header_backup() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        return
    fi

    app_header 'Backup'

    echo "File: ${backup_file:-~}"
}

app_header_result() {
    if [[ "${verbose:-true}" == 'false' ]]; then
        echo
    else
        app_header 'Result'
    fi

    command ls -sh "${backup_file}" 2>/dev/null
}

app_header() {
    printf "\n### %s\n\n" "${1}"
}

app_check_site_path_exists_and_readable() {
    if [ ! -r "${1}" ]; then
        app_error "Site path not exists or not readable: ${1}"
    fi
}

app_check_site_path_is_empty_and_writable() {
    local site_path="${1}"

    if ! [[ -d "${site_path}" ]]; then
        app_error "Site path is not exists or not a directory: ${site_path}"
    fi

    if ! [[ -z "$(command ls -A ${site_path})" ]]; then
        app_error "Site path is not empty: ${site_path}"
    fi

    if ! [[ -w "${site_path}" ]]; then
        app_error "Site path is not writable: ${site_path}"
    fi
}

app_detect_site_config() {
    local -n _="${1}"

    local plugin=''
    local config=''

    for plg in $(app_plugins_list); do
        if config="$(${plg})"; then
            plugin="${plg}" && break
        fi
    done

    [[ -z "${plugin}" ]] && return 0

    _[plugin]="${plugin}"
    _[plugin_name]="${plugin##*/}"

    if [[ -n "${site_path:-}" ]]; then
        _[root]="${site_path}"
    fi

    if [[ -n "${backup_file:-}" ]]; then
        _[backup_file]="${backup_file}"
    fi

    echo "${config}" | app_load_config "${1}"

    app_load_site_config_file 'site_config'
}

app_load_site_config_file()
{
    local -n _="${1}"

    local config_file="$(command find ${2:-${PWD}} -maxdepth 1 -type f -name ${app_config_file_pattern})"

    if [[ -z "${config_file}" ]]; then
        return
    fi

    if [[ "$(wc -l <<<${config_file})" -gt 1 ]]; then
        app_error 'More than one site config files present'
    fi

    config_file="$(realpath ${config_file})"

    _[config_file]="${config_file}"

    app_load_config "${1}" < "${config_file}"
}

app_load_config() {
    local -n _="${1}"

    while IFS=': ' read -r key value; do
        case "${key}" in
            plugin_name       ) _[plugin_name]="${value}" ;;
            exclude_paths     ) _[exclude_paths]+="${_[exclude_paths]:+ }${value}" ;;
            include_paths     ) _[include_paths]+="${_[include_paths]:+ }${value}" ;;
            database_name     ) _[database_name]="${value}" ;;
            database_user     ) _[database_user]="${value}" ;;
            database_password ) _[database_password]="${value}" ;;
            * ) app_error "Invalid configuration key: ${key}." ;;
        esac
    done
}

app_dump_database() {
    app_mysqldump --single-transaction --no-tablespaces "${site_config[database_name]}"
}

app_mysqldump() {
    command mysqldump --defaults-file=<(app_mysql_credentials 'mysqldump') "$@"
}

app_mysql() {
    command mysql --defaults-file=<(app_mysql_credentials 'client') "$@"
}

app_mysql_credentials() {
    cat <<EOF
[${1:-client}]
user="${site_config[database_user]}"
password="${site_config[database_password]}"
EOF
}

app_commands_list() {
    for cmd in ${app_base_path}/commands/*; do
        echo "${cmd##*/}"
    done | sort
}

app_plugins_list() {
    command find "${app_plugins_path}" -maxdepth 1 -type f -executable
}

app_error_unknown_command() {
    local message

    printf -v message 'Unknown command: %s.\n\n%s' "${1}" "$(app_available_commands)"

    app_error "${message}"
}

app_error_unknown_option() {
    app_error "Unknown option: ${1}"
}

app_error_missing_argument() {
    app_error "Missing argument${1:+: }${1:-}"
}

app_error_too_many_arguments() {
    app_error "Too many arguments.${1:+ Expected: }${1:-}"
}

app_error() {
    local exit_code=1

    if [ "${1}" = '--exit' ]; then
        exit_code="${2}"

        if [[ "${exit_code}" -lt 1 || "${exit_code}" -gt 255 ]]; then
            app_error "app_error(): invalid exit code: ${exit_code}" && return 1
        fi

        shift 2
    fi

    printf "${app_name}${app_name:+ }ERROR: %s\n" "$@" >&2

    exit "${exit_code}"
}

app_available_commands() {
    printf 'Available commands:\n\n'

    for c in $(app_commands_list); do
        printf '  %s\n' "${c}"
    done
}

app_repeat_str() {
    [[ $# -eq 0 ]] && return

    local result=''
    for (( i = 0; i < "${2:-1}"; i++ )); do
        result="${result}${1}"
    done

    printf '%s' "${result}"
}

app_usage() {
    echo "Usage: ${app_name} $@"
}
