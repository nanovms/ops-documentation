Installation
============

To install Ops, you will first need to [install
prerequisites](prerequisites.md#install-prerequisites).

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

First you need to generate some go code from Protocol Buffers included in ops source repository.
If you don't have the needed tools, you can install them by issuing the following commands:

```sh
$ go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
$ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
$ go install github.com/bufbuild/buf/cmd/buf@latest
```

Once ready you can generate the necessary code by using:

```sh
$ make generate
```

Finally you can build the `ops` binary by using:

```sh
$ make build
```

#### Build the Executable including specified providers only

By default, when running `make build`, all providers are included and available.

However you can select a subset of provider(s) to be included if required (except `onprem` that is always built).

- the following command builds only `onprem` and all other providers are disabled.

```sh
$ go build -tags onlyprovider
```

- the following command builds only `aws` and all other providers are disabled (except `onprem` that is always built).

```sh
$ go build -tags onlyprovider,aws
```

To select the providers to build you need to always use `onlyprovider` tag accompanied with desired provider tags:

```sh
$ go build -tags onlyprovider,aws,azure,do,gcp,ibm,linode,upcloud,vultr
```

available tags:
- **onlyprovider**
  - **aws**
  - **azure**
  - **digitalocean** (or **do**)
  - **gcp**
  - **hyperv**
  - **ibm**
  - **linode**
  - **oci**
  - **openshift**
  - **openstack**
  - **proxmox**
  - **upcloud**
  - **vbox**
  - **vsphere**
  - **vultr**
