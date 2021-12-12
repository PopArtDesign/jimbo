app:command:find_executable() {
    local executable="${app_commands_path}/${1}"

    [[ -f "${executable}" ]] && echo "${executable}"
}

app:command:commands_list() {
    for cmd in "${app_commands_path}/"*; do
        echo "${cmd##*/}"
    done | sort
}

app:command:available_commands() {
    printf 'Available commands:\n\n'

    for cmd in $(app:command:commands_list); do
        printf '  %s\n' "${cmd}"
    done
}
