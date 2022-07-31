### Vim Configuration Playground

Author: Ben Lewington
Email: ben.lewington91@ntlworld.com

## Description

The purpose of this repository is to build vim configuration outside of your own machine, without
having to disable your existing configuration.

I came in to vim and was initially overwhelmed with the configuration and setup. I starting using
LunarVim (https://www.lunarvim.org), which is a great pre-built configuration setup, whereby you
get a lot of what you need out of the box. However, like most who are attracted to such editors,
I am also opinionated on what I want, and I wanted to build my own configuration.

## Prerequisites

- Docker is used to run an container.
- The utility Just (https://github.com/casey/just) is used to provide a nice interface for running
  build commands. This can be installed via `cargo install just`, if you have cargo installed.

## Usage

To build the container for the first time, or for rebuilding the container, use:
```bash
just restart-into
nvim
```
This will bring up the docker container, and then run bash in the container. To run the same command
without rebuilding the container, use:
```bash
just start-into
nvim
```
with the src folder, there are `.config` and `.local` folders which contain the main configuration
files. These are both mounted into the container, however the contents of .local is not tracked. 
This is so that configuration can be persisted across container (re)builds if required, but testing
bootstrapping the configuration can easily be conducted by clearing down the .local folder:
```bash
rm -Rf .local/* 2> /dev/null
```

Neovim uses `.config/nvim/` as an entrypoint for configuration, expecting either an `init.vim` or
an `init.lua` as an entrypoint.

The folder `.local/share/nvim` is used to persist data across sessions, as well as manage packages.
The current setup uses packer (https://github.com/wbthomason/packer.nvim) as a plugin manager.

