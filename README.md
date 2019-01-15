# Ops Documentation
Documentation for [Nano VMs Ops](https://github.com/nanovms/ops)

To view the full documentation online, visit
[https://nanovms.gitbook.io/ops](https://nanovms.gitbook.io/ops/)

## Setup
To setup your development environment to write documentation, you'll need to
install the `gitbook` cli. The simple way to do this is run 

```sh
$ npm install gitbook-cli -g
```

## Serving local documentation
To view the documentation in the browser run the following command...

```sh
$ make serve
```

Then open up your browser to `http://localhost:4000`

For more information on how to use the `gitbook` cli tool as well as
documentation on formating, configuration, etc, visit [their
documentation](https://toolchain.gitbook.com/)

## Sandbox Environments

We have a `Vagrantfile` that is used to create temporary sandbox environments
to test various installation instructions and configurations. This makes it
easier for us to test that the instructions are accurate and work correctly.


#### Test Ubuntu 16 (Xenial)

```sh
$ make test OS=ubuntu16
```

#### Test Ubuntu 18 (Bionic)

```sh
$ make test OS=ubuntu18
```

#### Test Debian 8 (Jessie)

```sh
$ make test OS=debian8
```

#### Test Centos 7

```sh
$ make test OS=centos7
```

#### Test Fedora 28

```sh
$ make test OS=fedora28
```

