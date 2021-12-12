app:plugin:plugins_list() {
    command find "${app_plugins_path}" \
        -maxdepth 1 \
        -type f \
        -executable \
        | command sort
}

app:plugin:detect_plugin() {
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
