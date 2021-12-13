app_zip() {
    command zip -qr "-${COMPRESSION_LEVEL:-9}" "$@"
}

app_unzip() {
    command unzip -q "$@"
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

app_usage() {
    echo "Usage: ${app_name} $@"
}
