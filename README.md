# Jimbo

[![CI](https://github.com/PopArtDesign/jimbo/actions/workflows/ci.yaml/badge.svg)](https://github.com/PopArtDesign/jimbo/actions/workflows/ci.yaml)

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

## Uninstall

Local (`~/.local`):

```sh
unlink ~/.local/bin/jimbo; rm -rf ~/.local/lib/jimbo
```

Global (`/opt`):

```sh
sudo unlink /usr/local/bin/jimbo; sudo rm -rf /opt/jimbo
```
