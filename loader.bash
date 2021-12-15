if ! [[ -v app_libs_loaded ]]; then
    declare -gA app_libs_loaded=()

    app::use() {
        local lib="${1}"
        local path="${app_libs_path}/${lib}.bash"

        [[ -n "${app_libs_loaded[${lib}]:-}" ]] && return

        source "${path}"

        app_libs_loaded["${lib}"]="${path}"
    }
fi
