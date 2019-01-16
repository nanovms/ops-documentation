Getting Started
===============

### Supported Operating Systems

Currently Ops support various forms of linux operating systems.
 * MacOS
 * Debian
 * Ubuntu
 * Fedora
 * Centos

## Installing OPS
```sh
$ curl https://ops.city/get.sh -sSfL | sh
```
If the script complain about missing HomeBrew on Mac, please install it from https://brew.sh/ and re-run the above command.

On Linux flavors ensure that you have QEMU version 2.5 or greater installed.

##### Debian / Ubuntu (apt-get) {#qemu-debian}

 To install `QEMU`, run the following command...

```sh
$ sudo apt-get install qemu
```

##### Fedora (dnf/yum) {#qemu-fedora}

```sh
$ sudo dnf update
$ sudo dnf install qemu-kvm qemu-img
```

Or...

```sh
$ sudo yum update
$ sudo yum install qemu-kvm qemu-img
```
## Verify OPS installation.
```sh
ops version
```

During installation setup will attempt to configure the PATH. 
Because of differences between platforms, command shells the modifications to PATH may not take effect until the console is restarted, or the user is logged out, or it may not succeed at all.
If after installation, running ops version in the console fails, try 
```source ~/.bash_profile``` or open a new terminal.