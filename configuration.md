Configuration
=============
The configuration file used by `ops` specifies various options and attributes
of code execution, such as files to include, arguments, and environment
variables. This file follow the standard json format.

For a complete sample of a configuration, see our
[sample](configuration.md#sample)

### Configuration Attributes

#### Files {#files}
An array of file locations to include into the image

```json
{
    "Files": ["ex.js"]
}
```

#### Dirs {#dirs}
An array of directory locations to include into the image

```json
{
    "Dirs": ["myapp/static"]
}
```

_File layout on local host machine_
```
-myapp
    app
    -static
        -example.html
        -stylesheet 
            -main.css
```

_File  layout on VM_
```
/myapp
    app
    /static
        -example.html
        /stylesheet
            -main.css
```

#### Args {#args}
The command to execute when running the image. The expected format is an
array.

```json
{
    "Args": ["ex.js"]
}
```

#### Env {#env}
A dictionary/object of environment variables.

```json
{
    "Env": {
        "Environment": "development",
        "NODE_DEBUG": "*"
    }
}
```

#### MapDirs {#mapdirs}
This maps directories from a local source to a destination within the instance of your choosing.

```json
{
    MapsDirs: {
        "src": "/myapp/code"
    }
}
```

#### Debugflags {#debugflags}
TODO

_**NOTE** is there a place where there is a list of debug flags people can put
in somewhere?_

_Also, the debug flags seems to have it harded coded to a value of 't'. Is that
correct? See https://github.com/nanovms/ops/blob/master/lepton/image.go#L144_

#### Program {#program}
TODO

_**NOTE** Tried testing this, couldn't get it to work. I specified a program
in the config for a golang application, and when i print the manifest, it
doesn't change the "program" name._

#### Version {#version}
_Not Implemented_

#### Boot {#boot}
Define the boot image to be used. By default, it utilizes `.staging/boot.img`
in the `pwd`.

```json
{
    "Boot": "./staging/boot2.img"
}
```

#### Kernel {#kernel}
Define the kernel image to be used. By default, it utilizes
`.staging/stage3.img` in the `pwd`.

```json
{
    "Kernel": "./staging/stage4.img"
}
```

#### DiskImage {#diskimage}
Define the output file name for the generated disk image. By default, it is
`image`.

```json
{
    "DiskImage": "disk-image"
}
```

#### Mkfs {#mkfs}
Define the mkfs to be used. By default, it utilizes `.staging/mkfs` in the
`pwd`.

```json
{
    "Mkfs": "./staging/mkfs"
}
```

#### NameServer {#nameserver}
The DNS server to use for DNS resolution. By default it is Google's `8.8.8.8`.

```json
{
    "NameServer": "10.8.0.1"
}
```

#### RunConfig {#runconfig}
The `RunConfig` configures various attributes about the runtime of the ops
instance, such as allocated memory and exposed ports.

##### RunConfig.Imagename {#runconfig.image}
_Not Implemented_

##### RunConfig.Ports {#runconfig.ports}
A list of ports to expose. Alternatively, you can also use `-p` in the command
line.

```json
{
    "RunConfig": {
        "Ports": [80, 8008],
    }
}
```

##### RunConfig.Verbose {#runconfig.verbose}
Enables verbose logging for the runtime environment. As of now, it prints the
command used to start `qemu`.

```json
{
    "RunConfig": {
        "Verbose": true
    }
}
```

##### RunConfig.Memory {#runconfig.memory}
Configures the amount of memory to allocated to `qemu`. Default is 128 MiB.
Optionally, a suffix of "M" or "G" can be used to signify a value in megabytes
or gigabytes respectively.

```json
{
    "RunConfig": {
        "Memory": "2G"
    }
}
```

##### RunConfig.Bridged {#runconfig.bridged}
Enables the use of bridged networking mode. This also enables KVM
acceleration.

```json
{
    "RunConfig": {
        "Bridged": true
    }
}
```

### Sample Configuration File {#sample}
Below is a sample configuration file for a nodejs application.

```json
{
	"Files": ["ex.js"],
	"Dirs": ["src"],
	"Args": ["ex.js "],
	"Env": {
		"NODE_DEBUG": "*",
		"NODE_DEBUG_NATIVE": "*"
	},
	"MapsDirs": {
		"src": "/myapp/code"
	},
	"Boot": "./staging/boot2.img",
	"Kernel": "./staging/stage4.img",
	"Mkfs": "./staging/mkfs",
	"DiskImage": "disk-image",
	"NameServer": "10.8.0.1",
	"RunConfig": {
		"Verbose": true,
		"Bridged": true,
		"Ports": [8008],
		"Memory": "2G"
	}
}
```
