Configuration
=============
The configuration file used by `ops` (such as one passed as a parameter, 
e.g. `ops --config myconfig.json`) specifies various options and attributes
of code execution, such as files to include, arguments, and environment
variables. This file follows the standard json format.

For a complete sample of a configuration, see our
[sample](configuration.md#sample).

## Configuration Attributes

### Args {#args}
An array of commands to execute when running the image:
```json
{
    "Args": ["ex.js"]
}
```

### BaseVolumeSz {#base_volume_size}
The `BaseVolumeSz` is an optional parameter you can pass to specify
the size of the base volume. By default the size is the end of blocks
written by TFS.

To specify 100 megabytes:
```json
{
    "BaseVolumeSz": "100m"
}
```

To specify 1 gigabyte:
```json
{
    "BaseVolumeSz": "1g"
}
```

### Boot {#boot}
_TODO_

### BuildDir {#build_dir}
_TODO_

### CloudConfig {#cloudconfig}
The `CloudConfig` configures various attributes about the cloud provider, we want to use
with ops.

#### BucketName {#cloudconfig.bucketname}
Bucket name is used to store Ops built image artifacts.
```json
{
    "CloudConfig": {
        "BucketName": "my-bucket"
    }
}
```

#### Flavor {#cloudconfig.flavor}
_TODO_

#### ImageName {#cloudconfig.imagename}
_TODO_

#### Platform {#cloudconfig.platform}
Cloud provider we want to use with ops CLI.

Currently supported platforms:
* Google Cloud Platform `gcp`
* AWS `aws`

```json
{
    "CloudConfig": {
        "Platform": "gcp"
    }
}
```

#### ProjectID {#cloudconfig.projectid}
Project ID in case of Google Cloud Platform provider.
```json
{
    "CloudConfig": {
        "ProjectID": "proj-1000"
    }
}
```

#### Zone {#cloudconfig.zone}
Zone in case of Google Cloud Platform provider.
```json
{
    "CloudConfig": {
        "Zone": "us-west1-b"
    }
}
```

### Debugflags {#debugflags}
_TODO_

### Dirs {#dirs}
An array of directory locations to include into the image:
```json
{
    "Dirs": ["myapp/static"]
}
```

_File layout on local host machine:_
```
-myapp
    app
    -static
        -example.html
        -stylesheet 
            -main.css
```

_File  layout on VM:_
```
/myapp
    app
    /static
        -example.html
        /stylesheet
            -main.css
```

### Env {#env}
A map of environment variables:
```json
{
    "Env": {
        "Environment": "development",
        "NODE_DEBUG": "*"
    }
}
```

### Files {#files}
An array of file locations to include into the image:
```json
{
    "Files": ["ex.js"]
}
```

### Force {#force}
_TODO_

### Kernel {#kernel}
_TODO_

### ManifestName {#manifest_name}
_TODO_

### MapDirs {#mapdirs}
A map of a local directory to a different path on the guest VM. For example the below
adds all files under /etc/ssl/certs on host to /usr/lib/ssl/certs on VM.
```json
{
    "MapDirs": {"/etc/ssl/certs/*": "/usr/lib/ssl/certs" },
}
```

### Mkfs {#mkfs}
_TODO_

### Mounts {#mounts}
_TODO_

### NameServer {#nameserver}
The DNS server to use for DNS resolution. By default it is Google's `8.8.8.8`.
```json
{
    "NameServer": "10.8.0.1"
}
```

### NightlyBuild {#nightly_build}
_TODO_

### NoTrace {#no_trace}
_TODO_

### Program {#program}
_TODO_

### ProgramPath {#program_path}
_TODO_

### RebootOnExit
There is an option to reboot your application immediately if it crashes that is turned off by default, but you can enable it.
```json
{
    "RebootOnExit": true
}
```

### RunConfig {#runconfig}
The `RunConfig` configures various attributes about the runtime of the ops
instance, such as allocated memory and exposed ports.

#### Accel {#runconfig.accel}
_TODO_

#### BaseName {#runconfig.base_name}
_TODO_


#### Bridged {#runconfig.bridged}
Enables the use of bridged networking mode. This also enables KVM
acceleration.
```json
{
    "RunConfig": {
        "Bridged": true
    }
}
```

#### CPUs {#runconfig.cpus}
_TODO_

#### Debug {#runconfig.debug}
_TODO_

#### DomainName {#runconfig.domain_name}
_TODO_

#### Gateway {#runconfig.gateway}
_TODO_

#### GdbPort {#runconfig.gdb_port}
_TODO_

#### Imagename {#runconfig.image}
_Not Implemented_

#### InstanceName {#runconfig.instance_name}
_TODO_

#### IPAddr {#runconfig.ip_addr}
_TODO_

#### Klibs {#runconfig.klibs}

For example to run the NTP klib (eg: ntpd):

{
  "RunConfig":{
    "Klibs":["ntp"]
  }
}

#### Memory {#runconfig.memory}
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

#### Mounts {#runconfig.mounts}
_TODO_

#### NetMask {#runconfig.net_mask}
_TODO_

#### OnPrem {#runconfig.on_prem}
_TODO_

#### Ports {#runconfig.ports}
A list of ports to expose. Alternatively, you can also use `-p` in the command
line.

```json
{
    "RunConfig": {
        "Ports": [80, 8008],
    }
}
```

#### SecurityGroup {#runconfig.security_group}
_TODO_

#### ShowDebug {#runconfig.show_debug}
_TODO_

#### ShowErrors {#runconfig.show_errors}
_TODO_

#### ShowWarnings {#runconfig.show_warnings}
_TODO_

#### Subnet {#runconfig.subnet}
_TODO_

#### Tags {#runconfig.tags}
_TODO_

#### TapName {#runconfig.tap_name}
_TODO_

#### UDP {#runconfig.udp}
UDP is off by default. You can toggle UDP on via:
```json
{
    "RunConfig": {
        "UDP": true
    }
}
```

#### UDPPorts {#runconfig.udp_ports}
_TODO_

#### Verbose {#runconfig.verbose}
Enables verbose logging for the runtime environment. As of now, it prints the
command used to start `qemu`.
```json
{
    "RunConfig": {
        "Verbose": true
    }
}
```

#### VolumeSizeInGb {#runconfig.volume_size_in_gb}
_TODO_

#### VPC {#runconfig.vpc}
_TODO_

### TargetRoot {#target_root}
_TODO_

### Version {#version}
_TODO_

## Sample Configuration File {#sample}
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
