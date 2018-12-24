Installation
============

To install Ops, you will first need to [install
prerequisites](getting_started.md#install-prerequisites).

## Getting the Source Code

To get the source code, clone it from the official github repo, which can be
found [here](https://github.com/nanovms/ops)

```sh
$ git clone git@github.com:nanovms/ops.git $GOPATH/src/github.com/nanovms/ops
```

Once you've clone the repo, `cd` into the `ops` directory.

```sh
$ cd $GOPATH/src/github.com/nanovms/ops
```

## Installing dependencies

Use the `make` command to install the various dependencies of Ops.

```sh
$ make deps
```

## Build the Executable

To compile the source code into an executable, use the `make` command.

```sh
$ make build
```

## Setup Network

To setup the network for Ops to utilize, use the following command...

```sh
$ sudo ./ops net setup
```

