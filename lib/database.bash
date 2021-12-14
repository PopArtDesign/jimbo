app::database::dump() {
    app::database::mysqldump --single-transaction --no-tablespaces "${site_config[database_name]}"
}

app::database::cli() {
    app::database::mysql "${site_config[database_name]}"
}

app::database::mysqldump() {
    command mysqldump --defaults-file=<(app::database::mysql_credentials 'mysqldump') "$@"
}

app::database::mysql() {
    command mysql --defaults-file=<(app::database::mysql_credentials 'client') "$@"
}

app::database::mysql_credentials() {
    cat <<EOF
[${1:-client}]
user="${site_config[database_user]}"
password="${site_config[database_password]}"
EOF
}
