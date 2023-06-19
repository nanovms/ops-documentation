Google Cloud Integration
========================

Ops can integrate with your existing Google Cloud Platform (GCP) account. You can use Ops CLI to create and upload an image in GCP account.
Once, you have uploaded image, you can also create an instance with a particular image using CLI.

By using the __gcp__ _klib_ it is possible to send `memory usage metrics` to the GCP monitoring service, thus emulating the __GCP ops agent__.

## Pre-requisites

1. Create a Service Account (SA) in your GCP account and download the Service Account key json file.
2. Please make sure your Service Account has access to the Google Compute Engine and Google Storage.
3. Get the name of your Google Cloud account project where you would be creating images and instances.
4. Create a bucket in Google Cloud storage for image artifacts storage.
5. Please make sure you export `GOOGLE_APPLICATION_CREDENTIALS` with the Service Account key json file path, before invoking below commands.

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=~/service-key.json
```

## Image Operations
### Create Image

If you have already created an Ops project, you can update your existing `config.json`.
You need to add [CloudConfig](configuration.md#cloudconfig) which mentions specific details like `ProjectID`, `BucketName`.

```json
{
  "CloudConfig": {
    "ProjectID": "prod-1000",
    "Zone": "us-west1-b",
    "BucketName":"my-deploy"
  },
  "RunConfig": {
    "Memory": "2G"
  }
}
```

Once, you have updated `config.json` you can create an image in Google Cloud with the following command.

```sh
$ ops image create <elf_file|program> -c config.json -i <image_name> -t gcp
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ ops image create -c config.json -p node_v14.2.0 -a ex.js -i <image_name> -t gcp
```

Nanos supports running ARM payloads on ARM instances but in order to do
so you must build your image with an ARM instance type:

```json
{
  "CloudConfig": {
    "Flavor":"t2a-standard-1"
  }
}
```

Also note that this instance type is not supported in every region. You
can try us-central1-a.

### List Images

You can list existing images on Google cloud with `ops image list`.

```sh
$ ops image list
+--------------------+--------+-------------------------------+
|        NAME        | STATUS |            CREATED            |
+--------------------+--------+-------------------------------+
| nanos-main-image   | READY  | 2019-03-21T15:06:17.567-07:00 |
+--------------------+--------+-------------------------------+
| nanos-node-image   | READY  | 2019-04-16T23:16:03.145-07:00 |
+--------------------+--------+-------------------------------+
| nanos-server-image | READY  | 2019-03-21T15:50:04.456-07:00 |
+--------------------+--------+-------------------------------+
```

### Delete Image

`ops image delete <imagename>` can be used to delete an image from Google Cloud.

```sh
$ ops delete image nanos-main-image
```

## Instance Operations
### Create Instance

After the successful creation of an image in Google Cloud, we can create an instance from an existing image.

You need to export `GOOGLE_APPLICATION_CREDENTIALS` and pass project-id and zone with cli options.

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=<credentials_file_path>
$ ops instance create <image_name> -g prod-1000 -z us-west1-b -t gcp
```

Alternatively, you can pass config, if you have mentioned project-id and zone in project's config.json.

```sh
$ ops instance create <image_name> -t gcp -c config.json
```

You can provide list of ports to be exposed on gcp instance via config and command line.

CLI example

``` sh
$ ops instance create <image_name> -t gcp -p prod-1000 -z us-west1-a --port 80 --port 443
```

Sample config

```json
{
  "CloudConfig" :{
    "Platform" :"gcp",
    "ProjectID" :"prod-1000",
    "Zone": "us-west1-a",
    "BucketName":"my-s3-bucket",
    "InstanceProfile":"default"
  },
  "RunConfig": {
    "Ports" : ["80", "443"]
  },
  "Klibs": ["gcp", "tls"],
  "ManifestPassthrough": {
    "gcp": {
      "metrics": {"interval":"120"}
    }
  }
}
```

#### Spot Provisioning

You maybe enable spot provisioning using the following config:

```json
{
  "CloudConfig": {
    "Spot": true
  }
}
```

#### Private Static IP

By default, ops uses will rely on DHCP.

If you would like to set a static private ip you can use the following:

```json
{
  "RunConfig":{
    "IPAddress": "172.31.33.7"
  }
}
```

Note: You must choose an available IP that is within your chosen/default VPC.

#### IP Forwarding

By default, IP forwarding is `disabled` on GCP.

If you would like to enable IP forwarding when creating the instance you can use the following:

```json
{
  "RunConfig":{
    "CanIPForward": true
  }
}
```

#### GCP metrics - memory

The __gcp__ _klib_ emulates some functions of GCP ops agent to send __memory usage metrics__ to the __GCP monitoring service__.

Example Ops configuration to enable sending memory metrics every `2 minutes`:

```json
{
  "CloudConfig" :{
    "Platform" :"gcp",
    "ProjectID" :"prod-1000",
    "Zone": "us-west1-a",
    "BucketName":"my-s3-bucket",
    "InstanceProfile":"default"
  },
  "Klibs": ["gcp", "tls"],
  "ManifestPassthrough": {
    "gcp": {
      "metrics": {
        "interval":"120"
      }
    }
  }
}
```

#### GCP logging - console

The __gcp__ _klib_ implements a _console driver_ that sends _console output_ to GCP logs.

```json
{
  "CloudConfig" :{
    "Platform" :"gcp",
    "ProjectID" :"prod-1000",
    "Zone": "us-west1-a",
    "BucketName":"my-s3-bucket",
    "InstanceProfile":"default"
  },
  "Klibs": ["gcp", "tls"],
  "ManifestPassthrough": {
    "gcp": {
      "logging": {
        "log_id": "my_log"
      }
    }
  }
}
```


### List Instances

You can list instance on Google Cloud using `ops instance list` command.

You need to export `GOOGLE_APPLICATION_CREDENTIALS`, `GOOGLE_CLOUD_PROJECT` and `GOOGLE_CLOUD_ZONE` before firing command.

```sh
$ export GOOGLE_CLOUD_PROJECT=prod-1000
$ export GOOGLE_CLOUD_ZONE=us-west1-b
$ ops instance list
+-----------------------------+---------+-------------------------------+-------------+--------------+
|            NAME             | STATUS  |            CREATED            | PRIVATE IPS |  PUBLIC IPS  |
+-----------------------------+---------+-------------------------------+-------------+--------------+
| nanos-main-image-1556601450 | RUNNING | 2019-04-29T22:17:34.609-07:00 | 10.240.0.40 | 34.83.204.40 |
+-----------------------------+---------+-------------------------------+-------------+--------------+
```

Alternatively you can pass project-id and zone with cli options.

```sh
$ ops instance list -g prod-1000 -z us-west1-b
```

### Get Logs for Instance

You can get logs from serial console of a particular instance using `ops instance logs` command.

You need to export `GOOGLE_APPLICATION_CREDENTIALS`, `GOOGLE_CLOUD_PROJECT` and `GOOGLE_CLOUD_ZONE` before firing command.

```sh
$ export GOOGLE_CLOUD_PROJECT=prod-1000
$ export GOOGLE_CLOUD_ZONE=us-west1-b
$ ops instance logs <instance_name> -t gcp
```

Alternatively you can pass project-id and zone with cli options.

```sh
$ ops instance logs -g prod-1000 -z us-west1-b
```

### Delete Instance

`ops instance delete` command can be used to delete instance on Google Cloud.

You need to export `GOOGLE_APPLICATION_CREDENTIALS`, `GOOGLE_CLOUD_PROJECT` and `GOOGLE_CLOUD_ZONE` before firing command.

```sh
$ export GOOGLE_CLOUD_PROJECT=prod-1000
$ export GOOGLE_CLOUD_ZONE=us-west1-b
$ ops instance delete my-instance-running
```

Alternatively you can pass project-id and zone with cli options.

```sh
$ ops instance delete -g prod-1000 -z us-west1-b my-instance-running
```

### Create Instance with Instance Group

OPS has initial support for putting an instance into an instance group.
This allows you to load balance a handful of instances and scale up/down
on demand.

The instance group must already be created to use this feature. When
deploying through 'instance create' OPS will create a new instance
template, apply it to the instance group, and then force re-create all
the instances with the new instance template. The instance template will
track any firewall rule changes (such as ports).

```sh
$ ops instance create <image_name> -t gcp -p prod-1000 -z us-west1-a --port 80 --port 443 --instance-group my-instance-group
```

## Volume Operations
### Create Volume

You need to set the `BucketName`, `ProjectID` and `Zone` in the `CloudConfig` section of your configuration file and export `GOOGLE_APPLICATION_CREDENTIALS` before firing the command.

```json
{
  "CloudConfig" :{
    "ProjectID" :"prod-1000",
    "Zone": "us-west1-b",
    "BucketName":"my-deploy"
  }
}
```

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=<credentials_file_path>
$ ops volume create <volume_name> -t gcp -c <configuration_file_path>
```

For create a volume with existing files you can add the `-d` flag and the directory path.
```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=<credentials_file_path>
$ ops volume create <volume_name> -t gcp -c <configuration_file_path> -d <directory_path>
```

### List Volumes

You can list volumes on Google Cloud using `ops volume list -t gcp -c <configuration_file_path>` command.

You need to set the `ProjectID` and `Zone` in the `CloudConfig` section of your configuration file and export `GOOGLE_APPLICATION_CREDENTIALS` before firing the command.

```sh
$ ops instance list -t gcp -c <configuration_file_path>
+-----------------------------+---------+-------------------------------+-------------+--------------+
|            NAME             | STATUS  |            CREATED            | PRIVATE IPS |  PUBLIC IPS  |
+-----------------------------+---------+-------------------------------+-------------+--------------+
| nanos-main-image-1556601450 | RUNNING | 2019-04-29T22:17:34.609-07:00 | 10.240.0.40 | 34.83.204.40 |
+-----------------------------+---------+-------------------------------+-------------+--------------+
```


### Delete Volume

`ops volume delete` command can be used to delete an instance on Google Cloud.

You need to set the `ProjectID` and `Zone` in the `CloudConfig` section of your configuration file and export `GOOGLE_APPLICATION_CREDENTIALS` before firing the command.

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=<credentials_file_path>
$ ops volume delete <volume_name> -t gcp -c <configuration_file_path>
```

### Attach Volume

For attaching a volume you need a running instance using a image configured with a mount point. This means you have to create a volume before running the instance. After the volume created you have to specify the volume label with the same name of the volume created. You can create the image running the next command.

```sh
$ ops image create <elf_file|program> -i <image_name> -c config.json  --mounts <volume_label>:<mount_path>
```

After having the instance running you can attach a volume using `ops volume attach <instance_name> <volume_name> <volume_name> -t gcp -c <configuration_file_path>`.

**Note:** You need to stop and start the instance to see the changes applied.

### Detach Volume

You can detach a volume from a running instance using `ops volume detach <instance_name> <volume_name> -t gcp -c <configuration_file_path>`.

## Networking Considerations

If you specify a port in your config you are stating you wish the public
ip associated with the instance to be exposed with that port. If you
don't specify the port by default the private ip allows any instance in
the same vpc to talk to it.

### Elastic IP:

If you have already provisioned an elastic ip you may use it by setting
it in the Cloud Config:

```json
{
  "CloudConfig" :{
    "StaticIP": "1.2.3.4"
  }
}
```

### IPV6 Networking

IPV6 support differs from cloud to cloud.

To use IPv6 on Google Cloud you must create a VPC and a subnet with IPv6
enabled. You can not use the legacy network nor can you use an
auto-created subnet.

After you create a new VPC and subnet you can adjust the subnet to be
dual stack like so:

```sh
$ gcloud compute networks subnets update mysubnet \
  --stack-type=IPV4_IPV6 --ipv6-access-type=EXTERNAL --region=us-west2
```

When you create it you won't see in the UI that it is IPv6 enabled but
you can click the 'REST' button to see it.

A sample config:

```json
{
  "CloudConfig" :{
    "ProjectID": "my-project",
    "Zone": "us-west2-a",
    "BucketName":"nanos-test",
    "EnableIPv6": true,
    "VPC": "ipv6-test",
    "Subnet": "ipv6-test"
  },
  "RunConfig": {
    "Ports": [
      "80",
      "8080",
      "443"
    ]
  }
}
```
Be aware that you might not have IPV6 connectivity from the
laptop/server you are testing from. You can verify within an instance on
Google or some other IPv6 capable machine via telnet:

```sh
$ telnet 2600:1900:4120:1235:: 8080
```

or ping:

```sh
$ ping6 2600:1900:4120:1235::
```

Also, keep in mind that when you create a new VPC by default there are
no firewall rules so things like ICMP (ping) won't work without adding
them manually nor would ssh'ing into a test instance work without a
corresponding rule on the new VPC for ssh (22).
