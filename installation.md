Installation
============

To install Ops, you will first need to install prerequisites.

## Install Prerequisites

### Install Git
First we need to make sure you have `git` installed. You can find the official
`git` installation instructions
[here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

TODO: Write up git install directions for major versions of linux

### Install Make
You'll also need to install the `make` command line tool. Various linux
distributions have different methods for doing so.

TODO: Write up git install directions for major versions of linux

### Install Go
TODO: Write up git install directions for major versions of linux

## Getting the Source Code

To get the source code, clone it from the official github repo, which can be
found [here](https://github.com/nanovms/ops)

TODO: you need to clone this into your proper go path

```sh
git clone git@github.com:nanovms/ops.git
```

Once you've clone the repo, `cd` into the `ops` directory.

```sh
cd ops
```

## Installing dependencies

Use the `make` command to install the various dependencies of Ops.

```sh
make deps
```

## Build the Executable

To compile the source code into an executable, use the `make` command.

```sh
make build
```

