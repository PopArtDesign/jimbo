app::util::usage() {
    echo "Usage: ${app_name} $*"
}

app::util::realpath() {
    if [[ -p "${1}" ]]; then
        echo "${1}"
    else
        command realpath "$@"
    fi
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
