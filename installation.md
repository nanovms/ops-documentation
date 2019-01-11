Installation
============

To install Ops, you will first need to [install
prerequisites](getting_started.md#install-prerequisites).

## Easy Install
The fastest and easiest way to install Ops is running the installation script
as shown below.

TODO: update url here to script inside ops repo. Waiting until ops repo is
public.
```sh
curl -s https://gist.githubusercontent.com/tijoytom/076dbf088549844692c883539de4260e/raw | sh
```

Once you have run this, you will need to refresh your terminal window or start
a new shell session.

## Install from Source

### Getting the Source Code

To get the source code, clone it from the official github repo, which can be
found [here](https://github.com/nanovms/ops)

```sh
$ git clone git@github.com:nanovms/ops.git $GOPATH/src/github.com/nanovms/ops
```

Once you've clone the repo, `cd` into the `ops` directory.

```sh
$ cd $GOPATH/src/github.com/nanovms/ops
```

### Installing dependencies

Use the `make` command to install the various dependencies of Ops.

```sh
$ make deps
```

### Build the Executable

To compile the source code into an executable, use the `make` command.

```sh
$ make build
```
