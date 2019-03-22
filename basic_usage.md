Basic Usage
================

## Build and Deploy Nanos Unikernel

### **Running [Golang](https://golang.org) hello world**
* Create a file called `main.go` with below content

	```golang
	package main

	import "fmt"

	func main() {
		fmt.Println("Hello World!")
	}
	```

* Build it

	```sh
	$ GOOS=linux go build main.go
	```

* Package and deploy

	```sh
	$ ops run main
	```
	For more examples using Golang, visit our [examples
	repository](https://github.com/nanovms/ops-examples/tree/master/golang)

### **Running PHP hello world**
* Create a file called `ex.php` with below content

	```php
		<?php
		phpinfo();
		?>
	```
* Package and deploy

	```sh
	$ ops load php_7.2.13 -a ex.php
	```

### **Running a NodeJS script**

* Create a file called `ex.js` with below content
	```node
	console.log("Hello World!");
	```
* Package and deploy

	```sh
	$ ops load node_v11.5.0 -a ex.js
	```
You should see "Hello World!" printed on your screen and then the ops command
exits. For more examples using NodeJS, visit our [examples
repository](https://github.com/nanovms/ops-examples/tree/master/nodejs)

#### Load vs Run
While both of these commands are used to execute code, there is a big
difference when you would choose to run one rather than the other. For `ops
run`, you would use this command to run compiled code (executable machine
code). So, for example, any golang code that you may run, you'd use this
command. Any code that is compiled at runtime, you would use `ops load`. An
example of languages where you'd use this are nodejs or php. Each supported
language for `ops load`, will have a corresponding package. To see a list of
available packages, run `ops list`.

### Nightly vs. Main
Right now we have 2 release channels. If you run ops as is you are
tracking the main release channel. There is no update frequency
associated with it just whenever we deem significant work has been done
and we aren't horribly breaking anything.

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
