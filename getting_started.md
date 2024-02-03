Getting Started
===============

## Installing OPS
```sh
$ curl https://ops.city/get.sh -sSfL | sh
```

If that works you can try this simple hello world example. You don't
need node installed for this as ops will automatically download a node
package for you:

```sh
$ ops pkg load eyberg/node:20.5.0 -p 8083 -f -n -a hi.js
```

Put this in your hi.js:

```sh
var http = require('http');
http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello World\n');
}).listen(8083, "0.0.0.0");
console.log('Server running at http://127.0.0.1:8083/');
```

If the script complain about missing HomeBrew on Mac, please install it
from https://brew.sh/ and re-run the command above.

On Linux flavors ensure that you have QEMU version 2.5 or greater installed. It should be noted that the latest qemu version is 6.1 so if you are using something older - it's really old.

##### Debian / Ubuntu (apt-get) {#qemu-debian}
 To install `QEMU`, run the following command:

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
