Getting Started
===============

## Supported Operating Systems
Currently, Ops support various forms of UNIX operating systems.
 * MacOS
 * Debian
 * Ubuntu
 * Fedora
 * Centos

## Installing OPS
```sh
$ curl https://ops.city/get.sh -sSfL | sh
```

If the script complain about missing HomeBrew on Mac, please install it
from https://brew.sh/ and re-run the command above.

On Linux flavors ensure that you have QEMU version 2.5 or greater installed.

##### Debian / Ubuntu (apt-get) {#qemu-debian}
 To install `QEMU`, run the following command:

```sh
$ sudo apt-get install qemu
```

##### Fedora (dnf/yum) {#qemu-fedora}
```sh
$ sudo dnf update
$ sudo dnf install qemu-kvm qemu-img
```

Or:

```sh
$ sudo yum update
$ sudo yum install qemu-kvm qemu-img
```

## Verify the OPS Installation
```sh
$ ops version
```

**Note:** During the installation setup the PATH will be configured, and 
already open command shell windows may not be updated with these
PATH modifications until the console is restarted or the user has logged
out and in again.

If running `ops version` in the console fails, try `source ~/.bash_profile`
or open a new terminal.
