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
The `CloudConfig` configures various attributes about the cloud provider, we want to use with ops.

#### BucketName {#cloudconfig.bucketname}
Bucket name is used to store Ops built image artifacts.

```json
{
    "CloudConfig": {
        "BucketName": "my-bucket"
    }
}
```
#### DomainName {#cloudconfig.domain_name}
Updates DNS entry with the started instance IP.

```json
{
    "CloudConfig": {
        "DomainName": "ops.city"
    }
}
```

#### Flavor {#cloudconfig.flavor}
Specifies the machine type used to create an instance. Each cloud provider has different types descriptions.

```json
{
    "CloudConfig": {
        "Flavor": "t2.micro"
    }
}
```

#### ImageName {#cloudconfig.imagename}
Specifies the image name in the cloud provider.

```json
{
    "CloudConfig": {
        "ImageName": "web-server"
    }
}
```

#### Platform {#cloudconfig.platform}
Cloud provider we want to use with ops CLI.

Currently supported platforms:
* Google Cloud Platform `gcp`
* AWS `aws`
* Vultr `vultr`
* Vmware `vsphere`
* Azure `azure`
* Openstack `openstack`
* Upcloud `upcloud`
* Hyper-v `hyper-v`
See further instructions about the cloud provider in dedicated documentation page.

```json
{
    "CloudConfig": {
        "Platform": "gcp"
    }
}
```

#### ProjectID {#cloudconfig.projectid}
Project ID is used in some cloud providers to identify a workspace.

```json
{
    "CloudConfig": {
        "ProjectID": "proj-1000"
    }
}
```

#### SecurityGroup {#cloudconfig.security_group}
Allows an instance to use an existing security group in the cloud provider.

```json
{
    "CloudConfig": {
        "SecurityGroup": "sg-1000"
    }
}
```

#### Subnet {#cloudconfig.subnet}
Allows an instance to use an existing subnet in the cloud provider.

```json
{
    "CloudConfig": {
        "Subnet": "sb-1000"
    }
}
```

#### Tags {#cloudconfig.tags}
A list of keys and values to provide more context about an instance or an image. There are a set of pre-defined tags to identify the resources created by `ops`.

```json
{
    "CloudConfig": {
        "Tags": [
            {
                "key": "instance-owner",
                "value": "joe-smith"
            },
            {
                "key": "function",
                "value": "web-server"
            }
        ]
    }
}
```

#### Zone {#cloudconfig.zone}
Zone is used in some cloud providers to identify the location where cloud resources are stored.

```json
{
    "CloudConfig": {
        "Zone": "us-west1-b"
    }
}
```

#### VPC {#cloudconfig.vpc}
Allows instance to use an existing vpc in the cloud provider.

```json
{
    "CloudConfig": {
        "VPC": "vpc-1000"
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

### MapDirs {#mapdirs}
A map of a local directory to a different path on the guest VM. For example the below
adds all files under /etc/ssl/certs on host to /usr/lib/ssl/certs on VM.
```json
{
    "MapDirs": {"/etc/ssl/certs/*": "/usr/lib/ssl/certs" },
}
```

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
The `RunConfig` configures various attributes about the runtime of the ops instance, such as allocated memory and exposed ports.

#### Accel {#runconfig.accel}
Defines whether hardware acceleration should be enabled in qemu. This option is enabled by default.

```json
{
    "RunConfig": {
        "Accel": true
    }
}
```

#### Bridged {#runconfig.bridged}
Connects the unikernel network interface to a bridge with the name `br0`. The bridge name may be overriden with the property [BridgeName](#runconfig.bridge_name).

```json
{
    "RunConfig": {
        "Bridged": true
    }
}
```

#### BridgeName {#runconfig.bridge_name}
Connects the unikernel network interface to a bridge with the name specified. If the bridge does not exist in host machine it is created.

```json
{
    "RunConfig": {
        "BridgeName": "br1"
    }
}
```

#### CPUs {#runconfig.cpus}
Specifies the number of CPU cores the unikernel is allowed to use.

```json
{
    "RunConfig": {
        "CPUs": 2
    }
}
```

#### Debug {#runconfig.debug}
Opens a port in unikernel to allow a connection with the GDB debugger. See further instructions in [Debugging](/ops/debugging). If debug is set to true the hardware acceleration (`accel`) is disabled.

```json
{
    "RunConfig": {
        "Debug": true
    }
}
```



#### Gateway {#runconfig.gateway}
Defines the default gateway IP of the network interface.

```json
{
    "RunConfig": {
        "Gateway": "192.168.1.255"
    }
}
```

#### GdbPort {#runconfig.gdb_port}
Define the gdb debugger port. It only takes effect if debug is enabled. By default the `GdbPort` is `1234`.

```json
{
    "RunConfig": {
        "GdbPort": 1234,
        "Debug": true
    }
}
```

#### Imagename {#runconfig.image}
Sets the name of the image file.

```json
{
    "RunConfig": {
        "Imagename": "web-server"
    }
}
```

#### InstanceName {#runconfig.instance_name}
Sets the name of the instance.

```json
{
    "RunConfig": {
        "InstanceName": "web-server-instance"
    }
}
```

#### IPAddress {#runconfig.ipaddress}
Defines the IP address of the network interface.

```json
{
    "RunConfig": {
        "IPAddress": "192.168.1.75"
    }
}
```

The IP address has to be specified along with the netmask{#runconfig.netmask} and the gateway{#runconfig.gateway}, so the unikernel can assign the IP address to the network interface.

```json
{
    "RunConfig": {
        "IPAddress": "192.168.1.75",
        "NetMask": "255.255.255.0",
        "Gateway": "192.168.1.1"
    }
}
```

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
Defines a list of directories paths in the host machine whose data will be copied to the unikernel.

```json
{
    "RunConfig": {
        "Mounts": ["./files","./assets"]
    }
}
```

#### NetMask {#runconfig.net_mask}
Defines the netmask of the network interface.

```json
{
    "RunConfig": {
        "NetMask": "255.255.255.0"
    }
}
```

#### Background {#runconfig.background}
Starts unikernels in background. You can stop the unikernel using the onprem instances stop command.

```json
{
    "RunConfig": {
        "Background": true
    }
}
```

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



#### ShowDebug {#runconfig.show_debug}
Enables printing more details about what ops is doing at the moment. Also, enables the printing of warnings and errors.

```json
{
    "RunConfig": {
        "ShowDebug": true,
    }
}
```

#### ShowErrors {#runconfig.show_errors}
Enables printing errors with more details.

```json
{
    "RunConfig": {
        "ShowErrors": true,
    }
}
```

#### ShowWarnings {#runconfig.show_warnings}
Enables printing warnings details.

```json
{
    "RunConfig": {
        "ShowWarnings": true,
    }
}
```

#### TapName {#runconfig.tap_name}
Connects the unikernel to a network interface with the name specified. If the `tap` does not exist in host machine it is created.

```json
{
    "RunConfig": {
        "TapName": "tap0"
    }
}
```

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
Opens ports that use UDP protocol.
```json
{
    "RunConfig": {
        "Ports": [60, 6006],
    }
}
```

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
This property is only used by cloud provider openstack and sets the instance volume size. Default size is 1 GB.

```json
{
    "RunConfig": {
        "VolumeSizeInGb": 2
    }
}
```


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
