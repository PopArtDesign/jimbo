app::plugin::plugins_list() {
    command find "${app_plugins_path}" \
        -maxdepth 1 \
        -type f \
        -executable \
        | command sort
}
