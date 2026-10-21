Volumes
========================

Volumes are one or more drives you can attach to an instance.

## Create Volume

A volume can be created using `ops volume create <vol_name>`.

You can specify the volume size with the flag `-s`. The values should respect the next examples format.
```
* 512 (512 bytes)
* 56k (56 KiloBytes)
* 500m (500 MegaBytes)
* 10g (10 GigaBytes)
```

If you have a directory in your filesystem which you want to access in the unikernel you can use the flag `-d`. Ops will create the volume and copy the directory files to the volume filesystem.

Combining the previous flags a command with the next format.
```sh
$ ops volume create <vol_name> -s <size> -d <path_to_dir>
```

Someone who needs to create a volume to host 9.6 GigaBytes of assets can use the volume create command the next way.
```sh
$ ops volume create my-assets -s 10g -d ./my-assets
```

You can check the existing ops volumes with `ops volume list`.
```sh
$ ops volume list
+--------------------------------------+------+--------+-----------+---------------------------------------------------------------------+--------------------------------+----------+
|                 UUID                 | NAME | STATUS | SIZE (GB) |                              LOCATION                               |            CREATED             | ATTACHED |
+--------------------------------------+------+--------+-----------+---------------------------------------------------------------------+--------------------------------+----------+
| e1a9a40e-8d2b-19b7-61b7-57c43f362aaa | vol  |        | 1.1 GB    | /home/xyz/.ops/volumes/vol:e1a9a40e-8d2b-19b7-61b7-57c43f362aaa.raw | 2021-03-06 09:03:07.21 +0000   |          |
|                                      |      |        |           |                                                                     | GMT                            |          |
+--------------------------------------+------+--------+-----------+---------------------------------------------------------------------+--------------------------------+----------+

```

## Volume Content listing (on-prem)

To display the `tree` output of local (on-prem) volume, use `ops volume tree <volume_name:volume_uuid>`

```sh
$ ops volume tree vol # ops volume tree e1a9a40e-8d2b-19b7-61b7-57c43f362aaa
/
|   .secret
|   db_data
|   |   IDENTITY
|   |   000004.log
|   |   CURRENT
|   |   MANIFEST-000005
|   |   OPTIONS-000055
|   |   LOG
|   |   LOCK
|   |   OPTIONS-000057
```

To display a `ls` style listing of files in a local (on-prem) volume, use `ops volume ls <volume_name:volume_uuid> [<path>]`

```sh
$ ops volume ls vol -l # ops volume ls e1a9a40e-8d2b-19b7-61b7-57c43f362aaa -l
     212 Tue Dec 12 09:17:47 2023 .secret
	 Tue Dec 12 09:17:47 2023 db_data/

$ ops volume ls vol db_data -l # ops volume ls e1a9a40e-8d2b-19b7-61b7-57c43f362aaa db_data -l
       0 Tue Dec 12 09:17:47 2023 LOCK
     193 Tue Dec 12 09:17:48 2023 000004.log
    1683 Tue Dec 12 09:17:49 2023 MANIFEST-000005
  112810 Tue Dec 12 09:17:35 2023 OPTIONS-000055
  167464 Tue Dec 12 09:17:47 2023 LOG
      36 Tue Dec 12 09:17:47 2023 IDENTITY
      16 Tue Dec 12 09:17:49 2023 CURRENT
  112810 Tue Dec 12 09:17:35 2023 OPTIONS-000057
```

## Volume Content copy (on-prem)

To recursively copy the content of a local (on-prem) volume, use `ops volume cp <volume_name:volume_uuid> <src>... <dest>`

```sh
$ ops volume cp vol / . -r -L # ops volume cp e1a9a40e-8d2b-19b7-61b7-57c43f362aaa / . -r -L

$ ops volume cp vol db_data . -r -L
```

## Volume info from raw files (on-prem)

To get some volume information about `label`/`uuid` from a raw volume file, use `ops volume info <volume_file_path>`

```sh
$ ops volume info /tmp/snapshot-vol-01.raw
vol:e1a9a40e-8d2b-19b7-61b7-57c43f362aaa

$ ops volume info /tmp/snapshot-vol-01.raw --json
{
  "label": "vol",
  "uuid": "e1a9a40e-8d2b-19b7-61b7-57c43f362aaa"
}
```

## Setup Mount Path

Mounting a volume in an instance requires an image to know beforehand which volumes it should expect and the directories where the volumes will be mounted. The unikernel recognizes the volume by its name/label, UUID, or virtual id. The virtual id may be used when you wish to have the same volume name or mount a different volume with a different volume name to the same mount point. The virtual id syntax is currently supported on GCP, Azure and AWS.

You can specify mounts details using the command flag or the configuration file.

Using configuration file, you have to set the `Mounts` property.
```JSON
{
  "Mounts": {
    "<vol_uuid_or_vol_name_or_virtual_id>": "<path_in_unikernel_where_vol_will_be_mounted>"
  }
}

// Volume Name Example
{
  "Mounts": {
    "vol": "/files"
  }
}

// Virtual ID Example
{
  "Mounts": {
    "%1": "/files"
  }
}

// VirtFS VirtIO 9p Example
{
  "Mounts": {
    "/path-on-host-dir": "/files"
  }
}

```
And, then you can use the configuration file on creating the image.
```
$ ops image create <image_name> -c <configuration_file>
```

If you want to test quickly you can also use the `mounts` command flag instead.
```sh
$ ops image create <image_name> --mounts <vol_name_or_vol_uuid_or_virtual_id>/<path_to_mount>

// Volume Name Example
$ ops image create webapp --mounts vol:/files

// Virtual ID Example
$ ops image create webapp --mounts %1:/files

// VirtFS VirtIO 9p Example
$ ops image create webapp --mounts /path-on-host-dir:/files
```

The mounts must be specified on creating an image. All commands that require to build an image accept the mounts details.
```sh
$ ops run <...>

$ ops build <...>

$ ops image create <...>

$ ops pkg load <...>

$ ops deploy <...>
```

## Attach

If your image was created with the mounts details specified and you would like to attach a volume to a running instance use next command.
```
$ ops volume attach <instance_name> <volume_name>
```

Locally you can attach volumes at instance boot using --mounts with `ops run`, `ops pkg load`, or `ops instance create`.

If you wish to dynamically attach and detach volumes locally you'll need
to create the instance with QMP support enabled:

```
{
  "RunConfig": {
    "QMP": true
  }
}
```

You should note that this opens a local mgmt port that uses the
instance id's last 4 digits as the port. (This is only for local
hotplug.)

## Detach

You can detach a volume from one instance using `ops detach <instance_name> <volume_name>`

## Read Only

You can set a volume as read-only in your manifest like this:

```
"Mounts": {
        "%1": "/files1:ro",
}
```

or if you are passing via the cli flags:

```
--mounts "%1:/files1:ro"
```

If you wish to make the root/base volume readonly you can do so by
passing the manifest config like so:

```
"ManifestPassthrough": {
  "readonly_rootfs": "true"
}
```

Note: Read-only in this context applies to the actual volume mount not
user filesystem access as Nanos doesn't have the notion of users.

## Cloud Providers

All mounting volumes requirements applies to the cloud providers.

Ops uses cloud providers APIs to execute volumes operations on their infrastructure.

The commands format is the same, we just need to add the target cloud provider flag.
```sh
$ ops volume create <vol_name> -t <cloud_provider>

$ ops image create <image_name> --mounts <vol_name>:<mount_path> -t <cloud_provider>

$ ops instance create <image_name> --instance-name <instance_name> -t <cloud_provider>

$ ops volume attach <instance_name> <vol_name> -t <cloud_provider>
```

You can create arbitrarily large empty volumes on providers such as AWS
by specifying the requested size. AWS will re-size the volume to
whatever you set it as.

Sometimes it might be helpful to know when a volume is attached and
detached at run-time as AWS supports attaching/detaching volumes at
run-time.

You can look at the pseudo-file of ```/proc/mounts``` to determine
whether or not the volume is available. For instance:

Using this config file:
```
➜  g cat config.json
{
  "Mounts": {
    "bob": "/bob"
  }
}
```

and this program:

```
➜  g cat main.go
package main

import (
        "fmt"
        "os"
)

func main() {
        body, err := os.ReadFile("/proc/mounts")
        if err != nil {
                fmt.Println(err)
        }
        fmt.Print(string(body))
}
```

## Hot-Plugging Support

OPS supports hot-plugging volumes on GCP, AWS, Azure, and onprem allowing you
to, at runtime, attach and detach volumes and mount/unmount filesystems.

Today there is no support for hot-plugging virtfs shares, however, since
it is a share one can simply change the contents on the host.

## Accessing host filesystem from nanos guest using 9p

When running `onprem`, `Ops` contains logic to detect whether a mount directive is for a host directory (as opposed to a pre-made volume), and set up the configuration so that:

 1. Qemu properly exports the directory as a virtfs share, and
 2. the guest can mount that share as a 9P filesystem.

You can run multiple virt-fs shares locally.

- sample go http server

```go
package main

import (
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("static/"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))
	http.ListenAndServe(":8080", nil)
}
```

- build `my_server` binary

```sh
$ go build
```

- create __host__ folder to be shared with __guest__

```sh
$ mkdir /tmp/vfs9p
$ touch /tmp/vfs9p/index.html
```

- `config.json` ops config file

```json
{
  "Mounts": {
    "/tmp/vfs9p": "/static"
  },
  "RunConfig": {
    "Ports": [
      "8080"
    ]
  }
}
```

- run `ops` with `config.json` file

```sh
$ ops run -c config.json my_server -f
```

- or run `ops` without using `config.json` file

```sh
$ ops run my_server --mounts /tmp/vfs9p:/static -p 8080 -f
```

- modify content on the host and check that guest has the updates available

```sh
$ echo "1." >> /tmp/vfs9p/index.html

$ curl -L localhost:8080/static/
1.

$ echo "2." >> /tmp/vfs9p/index.html

$ curl -L localhost:8080/static/
1.
2.
```

One can use virtual identifiers on virt-fs shares, to for instance build
images on a different host and use them elsewhere:

```
ops image create -t onprem -c imgcreate.json my_server
```

imgcreate.json:

```
{
  "Mounts": {
    "%1": "/static"
  },
  "RunConfig": {
    "Ports": [
      "8080"
    ]
  }
}
```

However, at instance creation time you still need to provide the host
mount point using a different configuration:

```
ops instance create -t onprem -c instcreate.json my_server
```

```
➜  vfs cat instcreate.json
{
  "Mounts": {
    "/tmp/vfs9p": "/static"
  }
}
```

- Read more in our [9p tutorial](https://nanovms.com/dev/tutorials/accessing-host-filesystem-from-nanos-guest-using-9p)

## Wrap-up

Mounting volumes require us to create an image with the mounts details, launch an instance using the image and attaching a volume. Locally, you are able to mount a volume with 2 commands.
```sh
$ ops volume create vol -s 1g -d ./files

$ ops run webapp --mounts vol:/assets
```

As mentioned above you can mount multiple volumes with the config.json
or pass multiple mounts flags like so:

```
$ ops run g --mounts vol1:/vol1 --mounts vol2:/vol2
```

See an example in our [tutorial](https://nanovms.com/dev/tutorials/working-with-unikernel-volumes-in-nanos).
