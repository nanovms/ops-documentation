Amazon Web Services (AWS) Integration
========================

Ops can integrate with your existing Amazon Web Services (AWS) account. You can use the Ops CLI to create and upload an image in your AWS account.
Once, you have uploaded the image, you can also create an instance with a particular image using CLI.

We currently automate installing a [vmimport role](https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-troubleshooting.html).
It needs to be tied to the bucket you use and uses an unique name. If
you are having trouble you might wish to see if you have an existing
vmimport role defined already. You can also bypass this
verification/creation step by turning on the SkipImportVerify flag as
such:

```json
{
    "CloudConfig": {
        "SkipImportVerify": true
    }
}
```

## Instance type Support

Nanos supports running on many of the AWS instance types including
normal instance types like t2 and the newer Nitro based instances such as t3, c5, etc.

We recently introduced support for ARM based instances in the form of
AWS Graviton instances 2 and 3. We also support SMP there.

## Pre-requisites

1. Ensure your ~/.aws/credentials file is setup correctly - you can use
   the 'aws ec2' cli tools to verify this.

4. Create a bucket in S3 storage for ami creation.


## Image Operations
### Create Image

If you have already created an Ops project, you can update your existing `config.json`.
You need to add [CloudConfig](configuration.md#cloudconfig) which mentions specific details like `BucketName`.

```json
{
  "CloudConfig" :{
    "Zone": "us-west-1",
    "BucketName":"my-s3-bucket"
  }
}
```

Once, you have updated `config.json` you can create an image in AWS with the following command:

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ ops image create -t aws -c config.json -p node_v14.2.0 -a ex.js
```

### List Images

You can list existing images on AWS with `ops image list`.

```sh
$ ops image list -t aws -z us-west-1

+----------------+-----------+--------------------------+
|      NAME      |  STATUS   |         CREATED          |
+----------------+-----------+--------------------------+
| nanos-webg-ata | available | 2019-07-16T05:56:06.000Z |
+----------------+-----------+--------------------------+
| will-00        | available | 2019-08-07T20:21:19.000Z |
+----------------+-----------+--------------------------+
| nanos-webg     | available | 2019-07-16T05:01:44.000Z |
+----------------+-----------+--------------------------+
| node-image     | available | 2019-08-15T22:31:03.000Z |
+----------------+-----------+--------------------------+
```

### Delete Image

`ops image delete -i <imagename>` can be used to delete an image from AWS.

```sh
$ ops delete image -i nanos-main-image
```

## Instance Operations
### Create Instance

After the successful creation of an image in AWS, we can create an instance from an existing image.

```sh
$ ops instance create <image_name>
```

Alternatively, you can pass project-id and zone with cli options.

```sh
$ ops instance create <image_name> -p prod-1000 -z us-west-2
```

You can also pass config, if you have mentioned project-id and zone in project's config.json.

```sh
$ ops instance create <image_name> -c config.json
```

You can provide list of ports to be exposed on aws instance via config and command line.

CLI example:

``` sh
$ ops instance create <image_name> -p prod-1000 -z us-west-2 --port 80 --port 443
```

Sample config

```json
{
  "CloudConfig" :{
    "Platform" :"aws",
    "Zone": "us-west-1",
    "BucketName":"my-s3-bucket"
  },
  "RunConfig": {
    "Ports" : [80, 443]
  }
}
```

If you need to specify a specific zone when creating the instance use
the [Subnet config var](https://nanovms.gitbook.io/ops/configuration#cloudconfig.subnet).

This is necessary for certain operations such as when you want to mount
a volume to an instance.

#### VPC and Security Group

By default, ops uses the first VPC found in aws and creates a security group per instance.

You can select a different VPC or use a existing security group using the configuration file. The keys to set are `RunConfig.VPC` and `RunConfig.SecurityGroup`.

```json
{
  "RunConfig":{
    "VPC": "vpc-name",
    "SecurityGroup": "sg-name"
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

__Note__: You must choose an __available IP__ that is _within your chosen/default VPC_.

### List Instances

You can list instance on AWS using `ops instance list` command.

```sh
$ ops instance list -p prod-1033 -t aws -z us-west-2

$ ops instance list
+------+----+--------+---------+-------------+------------+
| NAME | ID | STATUS | CREATED | PRIVATE IPS | PUBLIC IPS |
+------+----+--------+---------+-------------+------------+
```

Alternatively you can pass project-id and zone with cli options.

```sh
$ ops instance list -p prod-1000 -z us-west1-b
```

### Get Logs for Instance

You can get logs from serial console of a particular instance using `ops instance logs` command.

```sh
$ ops instance logs <instance_name>
```

Alternatively you can pass project-id and zone with cli options.

```sh
$ ops instance logs -t aws -p prod-1033 -z us-west-2 i-08815dc4b29b44294
```

On Nitro based systems the serial console will only show output when you are connected to it.

For production use we recommend shipping your logs to
[syslog](https://docs.ops.city/ops/klibs#syslog) or using cloudwatch.

To utilize cloudwatch you need to specify an IAM role (`CloudConfig.InstanceProfile`), include the `cloudwatch` and `tls` klibs and
specify your log group and log stream like so:

```json
{
  "Klibs": ["cloudwatch", "tls"],
  "RunConfig": {
    "Ports": ["8080"]
  },
  "CloudConfig" :{
    "BucketName":"nanos-test",
    "InstanceProfile": "CloudWatchAgentServerRole"
  },
  "ManifestPassthrough": {
    "cloudwatch": {
      "mem_metrics_interval": "5",
      "logging": {
        "log_group": "my-log-group",
        "log_stream":"my_log_stream"
      }
    }
  }
}
```

Then you can tail your logs in real-time:

```sh
aws logs tail my-log-group --follow
```

Furthermore, it should be stated that shipping a lot of output through
the serial console is going to degrade performance. You can explicitly disable both serial and vga using the following config:

```json
{
  "ManifestPassthrough": {
    "consoles": {"-serial", "-vga"}
  }
}
```

### Delete Instance

`ops instance delete` command can be used to delete instance on AWS.

```sh
$ ops instance delete my-instance-running
```

Alternatively you can pass project-id and zone with cli options.

```sh
$ ops instance delete -p prod-1000 -z us-west1-b my-instance-running
```

### Create Instance with Instance Group

OPS has initial support for putting an instance into an AWS auto scaling group.
This allows you to load balance a handful of instances and scale up/down
on demand.

The instance group must already be created to use this feature. When
deploying through 'instance create' OPS will create a new launch
template, apply it to the AWS auto scaling group, and then attach it to the instance when creating.

```sh
$ ops instance create <image_name> -t aws -z us-west1-a --instance-group my-instance-group
```

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

IPV6 support differs from cloud to cloud. On AWS DHCPV6 is used. You can
have an ip auto-assigned or you can set one yourself but you must be
aware that a subnet must have IPv6 enabled.

A sample config for assigning an ip:

```json
➜  g cat config.json
{
  "CloudConfig" :{
    "Zone": "us-west-1",
    "BucketName":"my-bucket",
    "EnableIPv6": true,
    "VPC":"test-ipv6-test-2"
  },
  "RunConfig": {
    "IPv6Address": "2600:1f1c:604:9a00:7a34:8c37:5b08:f104",
    "Ports": [
      "80",
      "8080",
      "443"
    ]
  }
}
```

To test:

```sh
[ec2-user@ip-172-33-75-200 ~]$ ping6 2600:1f1c:604:9a00:7a34:8c37:5b08:f104
PING 2600:1f1c:604:9a00:7a34:8c37:5b08:f104(2600:1f1c:604:9a00:7a34:8c37:5b08:f104) 56 data bytes
64 bytes from 2600:1f1c:604:9a00:7a34:8c37:5b08:f104: icmp_seq=1 ttl=255 time=0.573 ms
64 bytes from 2600:1f1c:604:9a00:7a34:8c37:5b08:f104: icmp_seq=2 ttl=255 time=0.419 ms
^C
```

Be aware that you might not have IPV6 connectivity from the
laptop/server you are testing from. You can verify within an instance on
AWS to test connectivity.

### Volumes

When you mount a volume to an AWS instance you must specify the zone
modifier for the region. So instead of using:

```json
"Zone": "us-west-1",
```

Use

```json
"Zone": "us-west-1c",
```

OPS will strip the zone 'c' from other operations that only require/desire region.
