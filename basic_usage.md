Basic Usage
================

## Build and Deploy Nanos Unikernel

### [Golang](https://golang.org) Example
Create a file called `main.go` with the content below:
```golang
package main

import "fmt"

func main() {
	fmt.Println("Hello World!")
}
```

Build it:
```sh
$ GOOS=linux go build main.go
```

Package and deploy:
```sh
$ ops run main
```

For more examples using Golang, visit our
[examples repository](https://github.com/nanovms/ops-examples/tree/master/golang).

### [PHP](https://www.php.net/) Example
Create a file called `ex.php` with  the content below:
```php
<?php
phpinfo();
?>
```

Package and deploy:
```sh
$ ops pkg load eyberg/php:7.2.13 -a ex.php
```

### [NodeJS](https://nodejs.org/en/) Example
Create a file called `ex.js` with  the content below:
```node
console.log("Hello World!");
```

Package and deploy:
```sh
$ ops pkg load eyberg/node:14.2.0 -a ex.js
```

You should see "Hello World!" printed on your screen and then the ops command
exits. For more examples using NodeJS, visit our [examples
repository](https://github.com/nanovms/ops-examples/tree/master/nodejs).

### Run and Pass an Environment Variable
This can be done via the configuration file but if you want to
dynamically inject without having to rely on the configuration file this
is the way:

```go
package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {

	fmt.Println("FOO:", os.Getenv("FOO"))
	fmt.Println("BAR:", os.Getenv("BAR"))

	fmt.Println()
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		fmt.Println(pair[0])
	}
}
```

```sh
$ GOOS=linux go build
$ ops run -e FOO=1 tea
```

#### Load vs Run
While both of these commands are used to execute code, there is a big
difference when you would choose to run one rather than the other. For `ops
run`, you would use this command to run compiled code (executable machine
code). So, for example, any golang code that you may run, you would use this
command. Any code that is compiled at runtime, you would use `ops pkg load`.
Example of languages where you would use this are NodeJS or PHP. Each supported
language for `ops pkg load`, will have a corresponding package. To see a list of
available packages, run `ops pkg list`.

### Nightly vs. Main
Right now we have two release channels. If you run ops as is you are
tracking the main release channel. There is no update frequency
associated with it just whenever we deem significant work has been done
and we are not horribly breaking anything.

The other channel you can track is the nightly channel. This is
populated every night via the build system with whatever is in master.
So if you want bleeding edge you can utilize that.

The magic incantation for tracking this channel is simply to switch the
`-n` or `--nightly` flag on.

For example:

```sh
$ ops -n run main
```

If there are already cached images you can use the `--force` or `-f` flag to
replace them with the lastest images from a given channel. For example, the
following command will both track the nightly channel and replace any cached
images with the lastest from that channel:

```sh
$ ops -nf run main
```

OPS itself also tracks nightly builds.

## Supported Operating Systems

OPS can run on many different Unix based environments.

 * [MacOS](https://github.com/nanovms/homebrew-ops)
 * Debian
 * Ubuntu
 * [Arch](https://aur.archlinux.org/packages/ops/)
 * Fedora
 * Centos
 * WSL2
