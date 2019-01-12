Basic Usage
================

When using `ops`, there are two basic commands that are used to execute some
code. Those are `ops load` and `ops run`.

#### Load vs Run
While both of these commands are used to execute code, there is a big
difference when you would choose to run one rather than the other. For `ops
run`, you would use this command to run compiled code. So, for example, any
golang code that you may run, you'd use this command. Any code that is
compiled at runtime, you would use `ops load`. An example of this is nodejs or
python.

## Run a NodeJS script

Now we run a basic "Hello World" example using NodeJS. Create a file called
`ex.js` and edit the file.

Add the following to the contents of that file...

```node
console.log("Hello World!");
```

Once you've done that, execute that NodeJS file with the following command.

```sh
$ ops load node_v11.15.0 -a ex.js
```

You should see "Hello World!" printed on your screen and then the ops command
exits.

## Run a Golang script

Next, we are going to run a basic golang script. Create a file called
`main.go` and edit the file.

Add the following to the contents of that file...

```golang
package main

import "fmt"

func main() {
	fmt.Println("Hello World!")
}
```

Once you have done that, you will need to build your executable. One thing to
keep in mind is that we always want to build for linux, and not the local host
machine. This ensures we building for it to be run within `ops`.

```sh
$ GOOS=linux go build main.go
```

That would of created a executable binary file called `main`. We can then
execute that binary within `ops` with the following command...

```sh
$ ops run main
```
