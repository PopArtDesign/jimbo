app::plugin::plugins_list() {
    local IFS=':'
    local path

    for path in ${app_plugins_path}; do
        [[ ! -e "${path}" ]] && continue

        command find "${path}" -maxdepth 1 -type f -executable | command sort
    done
}

app::plugin::find_executable() {
    local name="${1}"

    if [[ -f "${name}" && -x "${name}" ]]; then
        printf '%s' "${name}"

        return
    fi

    app::plugin::plugins_list | while read -r plugin; do
        if [[ "$(basename "${plugin}")" == "${1}" ]]; then
            printf '%s' "${plugin}"

            return
        fi
    done

    return 1
}
