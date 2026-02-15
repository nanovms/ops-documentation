Getting Started
===============

## Installing OPS
```sh
$ curl https://ops.city/get.sh -sSfL | sh
```

If that works you can try this simple hello world example. You don't
need Node installed for this as ops will automatically download a Node
package for you:

```sh
$ ops pkg load eyberg/node:20.5.0 -p 8083 -f -n -a hi.js
```

Note: We have a list of pre-made Node packages on the
[repo](https://repo.ops.city/) if you are looking for a different
version or need a different architecture (eg: arm64 for Macs).

Put this in your hi.js:

```sh
var http = require('http');
http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello World\n');
}).listen(8083, "0.0.0.0");
console.log('Server running at http://127.0.0.1:8083/');
```

If the script complains about missing Homebrew on Mac, please install it
from [https://brew.sh/](https://brew.sh/) and re-run the command above.

On Linux and Mac ensure that you have QEMU version 2.5 or greater installed. The latest QEMU version is 10.2 so if you are using something older - it's really old.

##### Debian / Ubuntu (apt-get) {#qemu-debian}
To install `QEMU`, run

```sh
$ sudo apt-get install qemu-kvm qemu-utils
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

##### macOS (brew)

```sh
$ brew install qemu
```

## Verify the OPS Installation
```sh
$ ops version
```

**Note:** During the installation `$PATH` will be configured, and 
already opened shell windows may not be updated with these
`$PATH` modifications until the console is restarted or the user has logged
out and in again.

If running `ops version` in the console fails, try `source ~/.bash_profile`
or open a new terminal.
