Configuration
=============
The configuration file used by `ops` specifies various options and attributes
of code execution, such as files to include, arguments, and environment
variables. This file follows the standard json format.

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
Maps a local directory to a different path on guest VM. For example the below
adds all files under /etc/ssl/certs on host to /usr/lib/ssl/certs on VM.
```json
{
    "MapDirs": {"/etc/ssl/certs/*": "/usr/lib/ssl/certs" },
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

#### CloudConfig {#cloudconfig}
The `CloudConfig` configures various attributes about the cloud provider, we want to use
with ops.

##### CloudConfig.Platform {#cloudconfig.platform}
Cloud provider we want to use with ops CLI.

Currently supported platforms,
* Google Cloud Platform `gcp`

```json
{
    "CloudConfig": {
        "Platform": "gcp"
    }
}
```

##### CloudConfig.ProjectID {#cloudconfig.projectid}
Project ID in case of Google Cloud Platform provider.
```json
{
    "CloudConfig": {
        "ProjectID": "proj-1000"
    }
}
```

##### CloudConfig.Zone {#cloudconfig.zone}
Zone in case of Google Cloud Platform provider.
```json
{
    "CloudConfig": {
        "Zone": "us-west1-b"
    }
}
```

##### CloudConfig.BucketName {#cloudconfig.bucketname}
Bucket name is used to store Ops built image artifacts.

```json
{
    "CloudConfig": {
        "BucketName": "my-bucket"
    }
}
```

##### CloudConfig.ArchiveName {#cloudconfig.archivename}
_Not Implemented_

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
