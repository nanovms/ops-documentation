Basic Usage
================

## Build and Deploy Nanos Unikernel

### **Running GoLang hello world**
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
### **Run a NodeJS script**

* Create a file called `ex.php` with below content
	```node
	console.log("Hello World!");
	```
* Package and deploy

	```sh
	$ ops load node_v11.15.0 -a ex.js
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