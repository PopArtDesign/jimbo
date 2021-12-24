app::util::usage() {
    echo "Usage: ${app_name} $*"
}

app::util::realpath() {
    local -a opts=()
    local working_dir="${PWD}"

    while [[ $# -gt 0 ]]; do
        case "${1}" in
            -w | --working-dir ) working_dir="${2}" && shift ;;
            -- ) shift && break ;;
            -* ) opts+="${1}" ;;
            * ) break
        esac

        shift
    done

    if [[ -p "${1}" ]]; then
        echo "${1}"

        return
    fi

    (cd "${working_dir}" && command realpath "${opts[@]}" "$@")
}

app::util::repeat_str() {
    [[ $# -eq 0 ]] && return

    local result=''
    for (( i = 0; i < "${2:-1}"; i++ )); do
        result="${result}${1}"
    done

    printf '%s' "${result}"
}

app::util::mask_str() {
    app::util::repeat_str '*' "${#1}"
}
