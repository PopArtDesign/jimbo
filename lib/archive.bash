app::archive::zip() {
    command zip -qr "-${COMPRESSION_LEVEL:-9}" "$@"
}

app::archive::unzip() {
    command unzip -q "$@"
}
