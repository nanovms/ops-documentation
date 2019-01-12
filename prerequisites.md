Getting Started
===============

### Supported Operating Systems

Currently Ops support various forms of linux operating systems.
 * MacOS
 * Debian
 * Ubuntu
 * Fedora
 * Centos

## Install Prerequisites
If you plan on installing Ops using the install script vs source code, you
only need to install QEMU. All other prerequisite installs can be skipped on
this page.

### Install QEMU {#qemu}

##### MacOS (homebrew) {#qemu-macos}
If you're running on a Mac, you do need to install QEMU. The easiest way to
install QEMU is via homebrew.

```sh
$ brew install qemu
```

For alternate ways of installing QEMU, see their
[website](https://www.qemu.org/). 

##### Debian / Ubuntu (apt-get)

 1. To install `QMEU`, run the following command...

```sh
$ sudo apt-get install qemu
```

##### Fedora (dnf/yum)

 1. To install `qemu`, run the following command...

```sh
$ sudo dnf update
$ sudo dnf install qemu
```

Or...

```sh
$ sudo yum update
$ sudo yum install qemu
```

### Install Make {#make}
You'll also need to install the `make` command line tool. Various Linux
distributions have different methods for doing so.

#### MacOS

 1. To install `make`, run the following command line command...

```sh
$ xcode-select --install
```

#### Debian / Ubuntu (apt-get)

 1. To install `make`, run the following command...

```sh
$ sudo apt-get install build-essential
```

 2. Check that `make` is properly installed by running the following
    command...

```sh
$ make --version
```

#### Fedora (dnf/yum)

 1. To install `make`, run the following command...

```sh
$ sudo dnf update
$ sudo dnf install "Development Tools"
```

Or...

```sh
$ sudo yum update
$ sudo yum groupinstall "Development Tools"
```

 2. Check that `make` is properly installed by running the following
    command...

```sh
$ make --version
```

### Install Git {#git}
First we need to make sure you have `git` installed. You can find the official
`git` installation instructions
[here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

TODO: Write up git install directions for major versions of linux

#### MacOS (homebrew)

 1. To install `git`, run the following command. Make sure you have
    [homebrew](https://brew.sh/) installed first.

```sh
$ brew install git
```

#### Debian / Ubuntu (apt-get)

 1. To install `git` on a Debian or Ubuntu instance, run the following command...

```sh
$ sudo apt-get update
$ sudo apt-get install git
```

 2. Next verify that `git` is installed by running the following command...

```sh
$ git --version
git version 2.18.0
```

 3. Configure your `git` username and email address. These details will be
associated with any commit that may be made.

```sh
$ git config --global user.name "Emma Paris"
$ git config --global user.email "eparis@atlassian.com"
```

#### Fedora (dnf/yum)

 1. To install `git` on a Fedora instance, run the following command...

```sh
$ sudo dnf install git
```

Or...

```sh
$ sudo yum install git
```

 2. Next verify that `git` is installed by running the following command...

```sh
$ git --version
git version 2.18.0
```

 3. Configure your `git` username and email address. These details will be
associated with any commit that may be made.

```sh
$ git config --global user.name "Emma Paris"
$ git config --global user.email "eparis@atlassian.com"
```

#### Build from Source

##### Debian / Ubuntu

 1. There are a few dependencies that are needed to build `git` from source on
Debian / Ubuntu. You can install them with the following command...

```sh
$ sudo apt-get update
$ sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev asciidoc xmlto docbook2x
```

 2. To get the `git` source code, [download and extract
it](https://www.kernel.org/pub/software/scm/git/).

 3. Use the `make` command to build and install `git`.

```sh
$ make all doc info prefix=/usr
$ sudo make install install-doc install-html install-info install-man prefix=/usr
```

##### Fedora

 1. There are a few dependencies that are needed to build `git` from source on
Fedora. You can install them with the following command...

```sh
$ sudo dnf install curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel asciidoc xmlto docbook2X
```

For installing via `yum`, you need to install the Extra Packages for
Enterprise Linux (EPEL) repository first:

```sh
$ sudo yum install epel-release
$ sudo yum install curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel asciidoc xmlto docbook2X
```

 2. Symlink `docbook2X` to the filename that `git` build expects...

```sh
$ sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
```

 3. To get the `git` source code, [download and extract
it](https://www.kernel.org/pub/software/scm/git/).

 4. Use the `make` command to build and install `git`.

```sh
$ make all doc info prefix=/usr
$ sudo make install install-doc install-html install-man prefix=/usr
```

### Install Go {#go}

It is a requirement to have go installed on your system. To do so, follow the
documentation below.

#### Build from Source

 1. First pull the source and extract it.

```sh
$ curl -O https://storage.googleapis.com/golang/go1.11.2.linux-amd64.tar.gz
$ tar -xvf go1.11.2.linux-amd64.tar.gz
$ sudo mv go /usr/local
```

 2. Next, we need to setup your Go path. Open up the following file with your
    editor of choice.

```sh
$ nano ~/.profile
```

    Add the following lines...

```sh
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
```

    Once the file is edited, source it to load the new environment variables.

```sh
$ source ~/.profile
```

 3. Now that go is installed, let's check and make sure it is working
    properly.

```sh
$ go version
```

## Next Steps

Now that we have the prerequisites installed, the next step is to install Ops.
Go to the [installation instructions](installation.md).
