# Jimbo

[![CI](https://github.com/PopArtDesign/jimbo/actions/workflows/ci.yaml/badge.svg)](https://github.com/PopArtDesign/jimbo/actions/workflows/ci.yaml)
[![GitHub license](https://img.shields.io/github/license/PopArtDesign/jimbo)](https://github.com/PopArtDesign/jimbo/blob/main/LICENSE)

Simple backup tool for web sites (Joomla!, WordPress and etc.)

## Install

Local (`~/.local`):

```sh
git clone --depth=1 https://github.com/PopArtDesign/jimbo ~/.local/lib/jimbo && ln -s ~/.local/lib/jimbo/bin/jimbo ~/.local/bin/jimbo
```

Global (`/opt`):

```sh
sudo git clone --depth=1 https://github.com/PopArtDesign/jimbo /opt/jimbo && sudo ln -s /opt/jimbo/bin/jimbo /usr/local/bin/jimbo
```

## Usage

Jimbo backups all site's data into a one `.zip` archive. Thanks to it's [plugins](./plugin) it can detect site's configuration like database, cache folders and etc. and include or exclude some data from the final backup.

In simple case you can just run:

```sh
jimbo backup /path/to/site /path/to/backup.zip
```

To get more information about available commands try `--help`

```sh
jimbo --help
```

## Uninstall

Local (`~/.local`):

```sh
unlink ~/.local/bin/jimbo; rm -rf ~/.local/lib/jimbo
```

Global (`/opt`):

```sh
sudo unlink /usr/local/bin/jimbo; sudo rm -rf /opt/jimbo
```

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
