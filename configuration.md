Configuration
=============

The configuration file used by `ops` (such as one passed as a parameter,
e.g. `ops --config myconfig.json`) specifies various options and attributes
of code execution, such as files to include, arguments, and environment
variables. This file follows the standard json format.

For a complete sample of a configuration, see our
[sample](configuration.md#sample).

You can also enable config interpolation for things like secrets, hosts
or other configuration that you would like to inject from your
environment. This is helpful to reduce duplicate config:

For example:

```sh
secret=test ops_render_config=true ops run -c config.json
```

Will populate 'secret' with 'test':

```json
{
  "Env": {
    "secret": "$secret"
  }
}
```

## Configuration Attributes

### OPS_HOME

The OPS_HOME environment variable points to the location of where ops
will store build images and releases locally. By default it is set to
~/.ops . However there are some use-cases where you might want it set to
something else like so:

```bash
OPS_HOME=/opt/ops
```

### Args {#args}

`Args` is an array of arguments passed to your program to execute when running the image. Most programs will consider the program name as arg[0] but not all.

```json
{
    "Args": ["--report-on-fatalerror", "ex.js"]
}
```

### DisableArgsCopy {#disable_args_copy}

`DisableArgsCopy`, when set to _true_, disables the auto copy of files from host to image when present in args.

```json
{
    "Args": ["ex.js"],
    "DisableArgsCopy": true
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

`Boot` sets the path of bootloader file.

```json
{
    "Boot": "nanos/output/platform/pc/boot/boot.img"
}
```

### Uefi {#uefi}

`Uefi` indicates whether image should support booting via UEFI. Default is `false`.

```json
{
    "Uefi": true
}
```

### UefiBoot {#uefi_boot}

`UefiBoot` sets the path of UEFI bootloader file.

```json
{
    "UefiBoot": "nanos/output/platform/pc/boot/bootx64.efi"
}
```

### BuildDir {#build_dir}

`BuildDir` path to the temporary directory used during image build.

```json
{
    "BuildDir": "/tmp/my_app_build_dir"
}
```

### CloudConfig {#cloudconfig}

The `CloudConfig` configures various attributes about the cloud provider, we want to use with ops.

#### BucketName {#cloudconfig.bucket_name}

`BucketName` specifies the bucket to store the Ops built image artifacts.

```json
{
    "CloudConfig": {
        "BucketName": "my-bucket"
    }
}
```

#### BucketNamespace {#cloudconfig.bucket_namespace}

`BucketNamespace` is required on uploading files to cloud providers as oci.

```json
{
    "CloudConfig": {
        "BucketNamespace": "my-namespace"
    }
}
```

#### DedicatedHostId {#cloudconfig.dedicated_hostid}

This option is supported on [**AWS**](https://aws.amazon.com/ec2/dedicated-hosts/pricing/#Dedicated_Hosts_Configuration_Table) only.
Please keep in mind that, depending on the dedicated host type, only some instance flavors may be available.

`DedicatedHostId` is used to specify the dedicated host id placement on cloud provider.

```json
{
  "CloudConfig" : {
      "DedicatedHostId": "h-deadbeefdeadbeef1",
      "Flavor": "c4.large",
      "BucketName":"my-bucket"
  }
}
```

#### DomainName {#cloudconfig.domain_name}

This option is supported on **AWS**, **GCP** and **Vultr**.

`DomainName` is used to update a A record DNS entry with the started instance IP.

```json
{
    "CloudConfig": {
        "DomainName": "ops.city"
    }
}
```

#### StaticIP {#cloudconfig.static_ip}

This option is only supported on **AWS**, **GCP**.

`StaticIP` by cloud provider to assign a public static IP to a NIC.

```json
{
    "CloudConfig": {
        "StaticIP": "1.2.3.4"
    }
}
```

#### EnableIPv6 {#cloudconfig.enable_ipv6}

This option is only supported on **AWS**, **GCP**.

If `EnableIPv6` is set to true and a VPC is created, the new VPC will have ipv6 support. Otherwise, it doesn't affect the selected VPC ipv6 support.

```json
{
    "CloudConfig": {
        "EnableIPv6": true
    }
}
```

#### Flavor {#cloudconfig.flavor}

`Flavor` specifies the machine type used to create an instance. Each cloud provider has different types descriptions.

```json
{
    "CloudConfig": {
        "Flavor": "t2.micro"
    }
}
```

#### ImageType {#cloudconfig.image_type}

`ImageType` allows the user to specify an image type (whose possible values are target platform-specific) when creating an image.
Can be used to create images for Hyper-V generation 2 instances.

```json
{
    "CloudConfig": {
        "ImageType": "gen2"
    }
}
```

#### ImageName {#cloudconfig.image_name}

`ImageName` specifies the image name in the cloud provider.

It might be used by _ops_ to set `"IMAGE_NAME"` and `"RADAR_IMAGE_NAME"` environment variables.

```json
{
    "CloudConfig": {
        "ImageName": "web-server"
    }
}
```

#### InstanceProfile

`InstanceProfile` sets up an IAM role for an instance. Currently, this is only used for **AWS** but, in the future, it might be used to set roles for other cloud providers.

```json
{
    "CloudConfig": {
        "InstanceProfile": "my-iam-rolename"
    }
}
```

#### KMS

`KMS` optionally encrypts AMIs if set. 'default' may be used for the default key or a KMS arn may be specified. This is only used for **AWS**.

```json
{
    "CloudConfig": {
        "KMS": "default"
    }
}
```


#### Platform {#cloudconfig.platform}

`Platform` defines the cloud provider to use with the ops CLI.

Currently supported platforms:

* Default `onprem`
* Google Cloud Platform `gcp`
* AWS `aws`
* Vultr `vultr`
* Vmware `vsphere`
* Azure `azure`
* Openstack `openstack`
* Upcloud `upcloud`
* Hyper-v `hyper-v`
* DigitalOcean `do`
* OpenShift `openshift`
* Oracle Cloud Infrastructure `oci`
* Oracle VM VirtualBox `vbox`
* Proxmox VE `proxmox`

See further instructions about the cloud provider in dedicated documentation page.

```json
{
    "CloudConfig": {
        "Platform": "gcp"
    }
}
```

#### ProjectID {#cloudconfig.projectid}

`ProjectID` is used in some cloud providers to identify a workspace.

```json
{
    "CloudConfig": {
        "ProjectID": "proj-1000"
    }
}
```

#### RootVolume {#cloudconfig.root_volume}

`RootVolume` is an optional set of options one can apply to the
root/base volume of an instance on AWS. These settings include the name,
typeof, iops, size, and throughput.

For more information see the [AWS](aws.md) page.

```json
{
    "CloudConfig": {
        "RootVolume": {
            "Name": "my-root-volume",
            "Typeof":"gp3",
            "Size": 10
        }
    }
}
```

#### SecurityGroup {#cloudconfig.security_group}

`SecurityGroup` allows an instance to use an existing security group in the cloud provider.

On **AWS**, both the name and the id of the security group may be used as value.

```json
{
    "CloudConfig": {
        "SecurityGroup": "sg-1000"
    }
}
```

#### Subnet {#cloudconfig.subnet}

`Subnet` allows an instance to use an existing subnet in the cloud provider.

On **AWS**, both the _name_ and the _id_ of the subnet may be used as value.

```json
{
    "CloudConfig": {
        "Subnet": "sb-1000"
    }
}
```

#### Tags {#cloudconfig.tags}

`Tags` is a list of keys and values to provide more context about an instance or an image. There are a set of pre-defined tags to identify the resources created by `ops`.

The following example demonstrates the default format used when deploying on different cloud providers.

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

On **GCP** (_only_) there is also an extended configuration `attribute` that can be used to detail/control the purpose and destination of the tag

```json
{
    "CloudConfig": {
        "Tags": [
            {
                "key": "instance-owner",
                "value": "joe-smith",
                "attribute": {
                    "image_label": false,
                    "instance_label": true,
                    "instance_network": false,
                    "instance_metadata": false
                }
            },
            {
                "key": "function",
                "value": "web-server",
                "attribute": {
                    "image_label": true,
                    "instance_label": true,
                    "instance_network": false,
                    "instance_metadata": false
                }
            },
            {
                "key": "network-tag",
                "value": "http",
                "attribute": {
                    "image_label": false,
                    "instance_label": false,
                    "instance_network": true, // will use the tag value
                    "instance_metadata": false
                }
            }
        ]
    }
}
```

### UserData {#cloudconfig.userdata}

`UserData` allows you to populate data from the IMDS datastore at instance creation time.
This allows to create a single image and deliver specific configuration data to each deployed instance.

__Note__: cloud providers have different endpoints for IMDS, even though the data is always served from the 169.254.169.254 address which is *only* reachable from the instance. Since nanos does not have any concept of users or other processes running on an instance this can be used to deliver configuration data safely to an instance.

There is also klib (`userdata_env`) that can set the environment variables on an instance, taking care of the specifics for most cloud providers such as the endpoint to use and whether to base64 decode the data.

```json
{
    "CloudConfig": {
        "UserData": "BOB=something\nTOM=something-else"
    },
    "Klibs": ["userdata_env", "tls"]
}
```

Example setting a json configuration fragment as `UserData`, the application must fetch it from the IMDS endpoint and parse it:

```json
{
    "CloudConfig":{
        "UserData":"{\"Port\":8080,\"Endpoint\":\"/my/api/endpoint\"}"
    }
}
```

#### VPC {#cloudconfig.vpc}

`VPC` allows instance to use an existing vpc in the cloud provider.

On AWS and DO, both the _name_ and the _id_ of the vpc may be used as value. On DO setting the _id_ (uuid) avoids an extra call to the api at the cost of readability.

```json
{
    "CloudConfig": {
        "VPC": "vpc-1000"
    }
}
```

#### Zone {#cloudconfig.zone}

`Zone` is used in some cloud providers to identify the location where cloud resources are stored.

```json
{
    "CloudConfig": {
        "Zone": "us-west1-b"
    }
}
```

### Dirs {#dirs}

`Dirs` defines an array of directory locations to include into the image.

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

`Env` defines a map of environment variables to specify for the image runtime.

```json
{
    "Env": {
        "Environment": "development",
        "NODE_DEBUG": "*"
    }
}
```

### Files {#files}

`Files` defines an array of file locations to include into the image.

```json
{
    "Files": ["ex.js"]
}
```

### Kernel {#kernel}

`Kernel` sets the path of kernel image file.

```json
{
    "Kernel": "nanos/output/platform/pc/bin/kernel.img"
}
```

### KlibDir {#klib_dir}

`KlibDir` sets the host directory where kernel libs are located.

```json
{
    "KlibDir": "nanos/output/klib/bin"
}
```

#### Klibs {#klibs}
Defines a list of klibs to include. For example to run the NTP klib (eg: ntpd):

```json
{
    "Klibs":["ntp"]
}
```

### MapDirs {#mapdirs}

`MapDirs` sets map of a local directory to a different path on the guest VM. For example the below
adds all files under `/etc/ssl/certs` on host to `/usr/lib/ssl/certs` on VM.

```json
{
    "MapDirs": {"/etc/ssl/certs/*": "/usr/lib/ssl/certs" },
}
```

### Mounts {#mounts}

`Mounts` is used to mount a volume in an instance.

```json
{
    "Mounts": {
        "vol": "/files"
    }
}
```

In the case of `onprem` provider, the _volume_ can be a __host directory__ (as opposed to a _pre-made volume_)
that the guest will mount as a __9P filesystem__.

```json
{
    "Mounts": {
        "/tmp/files": "/files"
    }
}
```

See further instructions about volumes in dedicated [documentation](volumes.md) page.

### NameServers {#nameservers}

`NameServers` is an array of DNS servers to use for DNS resolution. By default it is Google's `8.8.8.8`.

```json
{
    "NameServers": ["10.8.0.1"]
}
```

### NanosVersion {#nanos_version}

`NanosVersion` sets nanos version to be used on image manifest.

```json
{
    "NanosVersion": "nightly"
}
```

### NightlyBuild {#nightly_build}

`NightlyBuild` flag forces the use of latest dev builds.

```json
{
    "NightlyBuild": true
}
```

### NoTrace {#no_trace}

`NoTrace` is an array of syscalls to mute tracing for.

```json
{
    "NoTrace": ["syscall-here"]
}
```

### Program {#program}

`Program` specifies the path of the program to refer to on attach/detach.

```json
{
    "Program":"lua_5.2.4/lua"
}
```

### ProgramPath {#program_path}

`ProgramPath` specifies the original path of the program to refer to on attach/detach.

```json
{
    "Program":"/ops_apps/lua_5.2.4/lua"
}
```

### RebootOnExit

`RebootOnExit` reboot your application immediately if it crashes (_exit code is not 0_). Is turned off by default, but you can enable it.

```json
{
    "RebootOnExit": true
}
```

same as

```json
{
    "Debugflags": ["reboot_on_exit"]
}
```

### LocalFilesParentDirectory

`LocalFilesParentDirectory` is the parent directory of the files/directories specified in Files and Dirs.
The default value is the directory from where the ops command is running

```json
{
    "LocalFilesParentDirectory": "."
}
```

### TargetRoot {#target_root}

`TargetRoot` _TODO_

```json
{
    "TargetRoot": "unix"
}
```

### VolumesDir

`VolumesDir` is the directory used to store and fetch volumes.

```json
{
    "VolumesDir": ""
}
```

### PackageBaseURL

`PackageBaseURL` provides the URL for downloading the packages.

```json
{
    "PackageBaseURL": "https://repo.ops.city/v2/packages"
}
```

### PackageManifestURL

`PackageManifestURL` provides the URL to download the manifest file that stores info about all packages.

```json
{
    "PackageManifestURL": "https://repo.ops.city/v2/manifest.json"
}
```

### Version {#version}

`Version` ops package version. Like docker if the user doesn't provide version of the image we consider "latest" as the version.

```json
{
    "Version": "v18.9.0"
}
```

### Language

`Language` ops package language.

```json
{
    "Language": "javascript"
}
```

### Runtime

`Runtime` ops package runtime.

```json
{
    "Runtime": "node"
}
```

### Description

`Description` ops package description.

```json
{
    "Description": "node.js runtime"
}
```

### TargetConfig {#target_config}

`TargetConfig` provides a limited support to adding cloud provider specific config.
This is done as to not overload the other configuration settings.

Currently only the `proxmox` target has support here. For example:

```json
{
  "TargetConfig": {
    "isoStorageName": "local",
    "Arch": "x86_64",
    "Machine": "q35",
    "Sockets": "1",
    "Cores": "1",
    "Numa": "0",
    "Memory": "512M",
    "StorageName": "local-lvm",
    "BridgePrefix": "vmbr",
    "Onboot": "0",
    "Protection": "0"
  }
}
```

### RunConfig {#runconfig}

The `RunConfig` configures various attributes about the runtime of the ops instance, such as allocated memory and exposed ports.

#### Accel {#runconfig.accel}

Defines whether hardware acceleration should be enabled in qemu. This option is enabled by default, but will be disabled when [Debug](#runconfig.debug) is set to true.

```json
{
    "RunConfig": {
        "Accel": true
    }
}
```

#### AtExit {#runconfig.at_exit}

Defines hooks to be ran after instance stops.

```json
{
    "RunConfig": {
        "AtExit": "echo `date` - START; sh shell_script.sh; echo `date` - DONE"
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

#### CanIPForward {#runconfig.can_ip_forward}

Enable IP forwarding when creating an instance. Only **GCP**, **Azure** provider.

```json
{
    "RunConfig": {
        "CanIPForward": true
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

#### GPUs {#runconfig.gpus}

Specifies the number of GPUs the unikernel is allowed to use. Only **GCP** provider.

```json
{
    "RunConfig": {
        "GPUs": 1,
        "GPUType": "nvidia-tesla-t4"
    }
}
```

#### GPUType {#runconfig.gputype}

Specifies the type of GPU available. Only **GCP** provider.

```json
{
    "RunConfig": {
        "GPUs": 1,
        "GPUType": "nvidia-tesla-t4"
    }
}
```

#### Debug {#runconfig.debug}

Opens a port in unikernel to allow a connection with the GDB debugger. See further instructions in [Debugging](debugging.md). If debug is set to true the hardware acceleration [Accel](#runconfig.accel) is disabled.

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

#### InstanceGroup {#runconfig.instance_group_}

Sets the group of the instance.

```json
{
    "RunConfig": {
        "InstanceGroup": "my-autoscale-service"
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

The IP address has to be specified along with the [netmask](#runconfig.netmask) and the [gateway](#runconfig.gateway), so the unikernel can assign the IP address to the network interface.

```json
{
    "RunConfig": {
        "IPAddress": "192.168.1.75",
        "NetMask": "255.255.255.0",
        "Gateway": "192.168.1.1"
    }
}
```

#### IPv6Address {#runconfig.ipv6address}

Defines the static IPv6 address of the network interface.

```json
{
    "RunConfig": {
        "IPv6Address": "FE80::46F:65FF:FE9C:4861"
    }
}
```


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

### Vga {#runconfig.vga}

Defines whether to emulate a VGA output device in `qemu`.

```json
{
    "RunConfig": {
        "Vga": false
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

### Nics {#runconfig.nics}

Is a list of pre-configured network cards.Meant to eventually deprecate the existing single-nic configuration.
Currently only supported for **Proxmox**

```json
{
    "Nics": [
        {
            "IPAddress": "192.168.1.75",
            "NetMask": "255.255.255.0",
            "Gateway": "192.168.1.1",
            "BridgeName": "br1"
        }
    ]
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
        "Ports": ["80", "8008"],
    }
}
```

#### QMP {#runconfig.qmp}

Enables the QMP monitor for onprem targets. This must be enabled for
various operations such as stats, volumes and rebooting when running
against the onprem target.

```json
{
    "RunConfig": {
        "QMP": true
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

#### UDPPorts {#runconfig.udp_ports}

Opens ports that use UDP protocol.

```json
{
    "RunConfig": {
        "UDPPorts": ["60", "70-80", "6006"],
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

This property is only used by cloud provider **openstack** and sets the instance volume size. Default size is 1 GB.

```json
{
    "RunConfig": {
        "VolumeSizeInGb": 2
    }
}
```

#### AttachVolumeOnInstanceCreate {#runconfig.attach_volume_on_instance_create}

This property is only used by cloud provider **gcp** to attach an existing cloud disk/volume to the instance being created.

```json
{
    "RunConfig": {
        "AttachVolumeOnInstanceCreate": true
    }
}
```

### ManifestPassthrough {#manifestpassthrough}

There is the concept of the [manifest](https://nanos.org/thebook#manifest) in Nanos where there exists many other config options that don't boil up to ops configuration, however, sometimes you still wish to pass these settings down to the manifest. Certain klibs, in particular, have variables that need to be set. To set them do this:

```json
{
    "ManifestPassthrough": {
        "my_manifest_setting": "some_value"
    }
}
```

#### Consoles {#consoles}

Nanos offers a 'consoles' feature that allows multiple methods for monitoring a running unikernel.
By default, the 'serial' and 'vga' consoles are enabled for testing purposes. However, in a production
environment, it is highly advised against using these consoles as they significantly slow down the unikernel,
rendering it nearly non-functional.

To activate or deactivate consoles, you can use the '+' or '-' symbols. Here is an example configuration:

```json
"ManifestPassthrough": {
  "consoles": [
    "+net",
    "-serial",
    "-vga"
  ]
}
```

In the above example, `+net` enables the net console locally for debugging purposes. The net console
is faster than 'serial' when it comes to testing performance.

The net console also provides two options: `netconsole_port` and `netconsole_ip`. These options allow
you to send logs to a remote machine for debugging. However, it is advisable to use 'syslog' instead
of net console for production workloads.

#### Exec Protection {#exec_protection}

Nanos has an 'exec protection' feature that prevents the kernel from
executing any code outside the main executable and other 'trusted' files
explicitly marked. The program is further limited from modifying the
executable file and creating new ones. This flag may also be used on
individual files within the children tuple. This prevents the
application from exec-mapping anything that is not explicitly mapped as
executable.

This is not on by default, however, as many JITs won't work with it
turned on.

```json
{
    "ManifestPassthrough": {
        "exec_protection": "t"
    }
}
```


#### CWD {#manifestpassthrough.cwd}

Some applications expect to have a working directory in a different
place than where they have been placed. You can adjust this via the
manifest variable 'cwd':

```json
{
    "ManifestPassthrough": {
        "cwd": "/my_new/path"
    }
}
```

#### Exec Wait For IPv4 {#manifestpassthrough.exec_wait_for_ipv4}

This is an optional configuration setting that allows Nanos to wait for a valid ipv4 address to become available via DHCP using the timeout of 'exec_wait_for_ip4_secs'. If static ip is set than there is no effect. This configuration is not on by default.

```json
{
    "ManifestPassthrough": {
        "exec_wait_for_ip4_secs": "5"
    }
}
```

This configuration can also be associated to a specific network interface, i.e:

```json
{
    "ManifestPassthrough": {
        "en2": {
            "exec_wait_for_ip4_secs": "5"
        }
    }
}
```

#### Exec Wait For IPv6 {#manifestpassthrough.exec_wait_for_ipv6}

This is an optional configuration setting that allows Nanos to wait for a valid ipv6 address to become available via DHCP using the timeout of 'exec_wait_for_ip6_secs'. If static ip is set than there is no effect. This configuration is not on by default.

```json
{
    "ManifestPassthrough": {
        "exec_wait_for_ip6_secs": "5"
    }
}
```
This configuration can also be associated to a specific network interface, i.e:

```json
{
    "ManifestPassthrough": {
        "en2": {
            "exec_wait_for_ip6_secs": "5"
        }
    }
}
```

#### expected_exit_code {#manifestpassthrough.expected_exit_code}

This is an optional configuration setting that changes the program _exit code_ to _0_, if a match is found on the configuration.

Some possible configurations:

```json
{
    "ManifestPassthrough": {
        "expected_exit_code": "1"
    }
}
```

```json
{
    "ManifestPassthrough": {
        "expected_exit_code": "!6"
    }
}
```

```json
{
    "ManifestPassthrough": {
        "expected_exit_code": ["1", "6"]
    }
}
```

```json
{
    "ManifestPassthrough": {
        "expected_exit_code": "*"
    }
}
```

#### Mmap Min Address {#manifestpassthrough.mmap_min_addr}

This is an optional configuration setting that defines the minimum virtual address that a process is allowed to mmap. If set to zero, allow zero-page mappings to occur.

```json
{
    "ManifestPassthrough": {
        "mmap_min_addr": "0"
    }
}
```

#### Program Overwrite Protection {#program_overwrite}

By default, the user application is not allowed to overwrite the **program** binary file (and **interpreter**, if present).
This default behavior can be overridden by inserting a `program_overwrite` attribute in the root tuple of the manifest.

```json
{
    "ManifestPassthrough": {
        "program_overwrite": "t"
    }
}
```


#### ltrace {#manifestpassthrough.ltrace}

This enables tracing calls made by the application binary to dynamic library functions.
It works on both _pie_ and _no-pie_ programs, and also works with _aslr_.

```json
{
    "ManifestPassthrough": {
        "ltrace": {}
    }
}
```

#### log_level {#manifestpassthrough.log_level}

Setting a different log level will print to the console if the level is
equal to or lower than the user-provided setting.

The default log level is 'err'. You may adjust this to 'err', 'warn', or
'info'.

```json
{
    "ManifestPassthrough": {
        "log_level": "info"
    }
}
```

#### mtu {#manifestpassthrough.mtu}

This is an optional configuration setting that changes the _MTU_ (Maximum Transmission Unit) size of the network interface(s).
This **doesn't** affect _TUN_ interface(s).

```json
{
    "ManifestPassthrough": {
        "mtu": "1420"
    }
}
```

#### so_rcvbuf {#manifestpassthrough.so_rcvbuf}

This is an optional configuration setting used to manage the size (in bytes) of the socket receive buffer.
The default buffer size is _208 KB_, so to change the size to, say, _512 KB_, you could use the following config:

```json
{
    "ManifestPassthrough": {
        "so_rcvbuf": "524288"
    }
}
```

#### static_map_program {#manifestpassthrough.static_map_program}

This is an optional configuration setting that will disable demand
paging. This is overriden when ltrace is in use.

```json
{
  "ManifestPassthrough": {
    "static_map_program": "t"
  }
}
```

#### trace {#manifestpassthrough.trace}

This is an optional configuration setting that allows specifying trace flags (i.e. a comma-delimited set of trace message types) in the `trace` symbol of the root tuple.
_A given trace message is output only if its message type is enabled in the trace flags._

* `pf` - page-fault-related messages - sets `TRACE_PAGE_FAULT`
* `threadrun` - messages output when returning to user threads - sets `TRACE_THREAD_RUN`
* `all` - all tracing messages are enabled
* for backward compatibility, **any unknown trace flag** _enables all messages output via calls to thread_log()_. - sets `TRACE_OTHER`

_Example_: a `"trace:pf,other"` value in the manifest enables page-fault-related messages and messages classified as "other".

```json
{
    "ManifestPassthrough": {
        "trace:pf,threadrun,all": {}
    }
}
```

#### reboot_on_exit {#manifestpassthrough.reboot_on_exit}

This is an optional configuration setting that reboots your application immediately if it stops with an _exit code that matches the configuration_.

This is checked after `manifestpassthrough.expected_exit_code` execution (when both configured).

__Note__: `poweroff/stop` operations work normally, regardless of the presence and value of the `reboot_on_exit` option, and regardless of the application exit code.

Some possible configurations:

```json
{
    "ManifestPassthrough": {
        "reboot_on_exit": "!0"
    }
}
```

```json
{
    "ManifestPassthrough": {
        "reboot_on_exit": "1"
    }
}
```

```json
{
    "ManifestPassthrough": {
        "reboot_on_exit": ["0", "1", "6"]
    }
}
```

```json
{
    "ManifestPassthrough": {
        "reboot_on_exit": "*"
    }
}
```

#### idle_on_exit {#manifestpassthrough.idle_on_exit}

This is an optional configuration setting that keeps a VM running after the user program exits with an _exit code that matches the configuration_. The VCPUs remain halted.

Some possible configurations:

```json
{
    "ManifestPassthrough": {
        "idle_on_exit": "0"
    }
}
```

```json
{
    "ManifestPassthrough": {
        "idle_on_exit": "!0"
    }
}
```

```json
{
    "ManifestPassthrough": {
        "idle_on_exit": ["0", "1", "6"]
    }
}
```

```json
{
    "ManifestPassthrough": {
        "idle_on_exit": "*"
    }
}
```

#### io-queues {#manifestpassthrough.io-queues}

By default the virtio-net driver utilizes as many tx/rx queues as supported by
the attached device but limited to the number of cpus exposed to the
instance. This setting may be changed via the following config for the
guest:

```
"ManifestPassthrough": {
  "en1": {
    "io-queues": "2"
  }
}
```

#### uname {#manifestpassthrough.uname}

This is an optional configuration that will make the kernel return your
chosen strings in the sysname and release fields of the uname syscall.
Several programs expect known names or versions, to for example, enable
certain features.

The default is set to "Nanos" for the sysname field, and
"5.0-<NANOS_VERSION>" for the release.

```json
"ManifestPassthrough": {
  "uname": {
    "sysname": "Linux",
    "release": "5.0.5"
  }
}
```

#### transparent_hugepage {#manifestpassthrough.transparent_hugepage}

Transparent HugePage Support (THP) is *enabled* by default on nanos.

To *disable* THP support set `"transparent_hugepage"` to `"never"`.
Any other value, will keep THP *enabled*.

```json
{
  "ManifestPassthrough": {
    "transparent_hugepage": "never"
  }
}
```

### Debugflags {#debugflags}

`Debugflags` adds additional debug flags to the runtime.

```json
{
    "Debugflags": ["trace:pf,threadrun,all", "debugsyscalls"]
}
```

#### idle_on_exit {#debugflags.idle_on_exit}

`idle_on_exit` keeps a VM running after the user program exits successfully (_exit code is 0_). The VCPUs remain halted.

```json
{
    "Debugflags": ["idle_on_exit"]
}
```

#### reboot_on_exit {#debugflags.reboot_on_exit}

`reboot_on_exit` reboot your application immediately if it crashes (_exit code is not 0_). Is turned off by default, but you can enable it.

```json
{
    "Debugflags": ["reboot_on_exit"]
}
```

### Force {#force}

_TODO_
