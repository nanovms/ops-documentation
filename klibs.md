Klibs
=======

Klibs are plugins which provide extra functionality to unikernels.

As of Nanos [b66be2b](https://github.com/nanovms/nanos/commit/b66be2b642069519a14ea321d9bf5843921c08ab) there are 13 klibs in the kernel source tree:

* __cloud_init__ - used for Azure && env config init
  * __cloud_azure__ - use to check in to the Azure meta-data service - not available in config (auto-included by __cloud_init__)
* __cloudwatch__ - use to implement cloudwatch agent for AWS
  * __aws__ - not available in config (auto-included by __cloudwatch__)
* __firewall__ - use to implement network firewall
* __gcp__ - logging and memory metrics for GCP
* __ntp__ - used for clock syncing
* __radar__ - telemetry/crash data report using the external [Radar](https://nanovms.com/radar) APM service
* __sandbox__ - provides OpenBSD-style [pledge](https://man.openbsd.org/pledge.2) and [unveil](https://man.openbsd.org/unveil.2) syscalls
* __special_files__ provides nanos-specific pseudo-files
* __syslog__ - used to ship stdout/stderr to an external syslog - useful if you can't/won't modify code
* __tls__ - used for radar/ntp and other klibs that require it
* __tun__ - supports tun devices (eg: vpn gateways)
* __test__ - a simple test/template klib

Not all of these are available to be included in your config (__cloud_azure__, __aws__).
Only the ones found in your `~/.ops/NANOS-VERSION/klibs` folder can be specified,
where `NANOS-VERSION` is the version of nanos you are using, ie:

- **0.1.48**  - `~/.ops/0.1.48/klibs`
- **nightly** - `~/.ops/nightly/klibs`

Some of these are auto-included as they provide support that is required
by certain clouds/hypervisors. You should only include a klib if you
think you need it. The ones that are required for certain functionality
will be auto-included by ops. For instance if you are deploying to Azure
we'll auto-include the cloud_init and tls klibs.

## Cloudwatch

The `cloudwatch` klib implements two functionalities that can be used on AWS cloud:

1. `logging` - __console driver__ that sends __console output__ to __AWS CloudWatch__
2. `metrics` - emulates some functions of AWS CloudWatch agent to send __memory utilization metrics__ to __AWS CloudWatch__

### Cloudwatch logging

The __cloudwatch__ _klib_ implements a console driver that sends log messages to AWS CloudWatch when Nanos runs on an AWS instance.
This feature is enabled by loading the cloudwatch and tls klibs and adding a `"logging"` tuple to the `"cloudwatch"` tuple in the root tuple.
The `"logging"` tuple may contain the following attributes:

- `"log_group"`: specifies the CloudWatch log group to which log messages should be sent; if not present, the log group is derived from the image name (taken from the environment variables),
                 or from the name of the user program if no IMAGE_NAME environment variable is present
- `"log_stream"`: specifies the CloudWatch log stream to which log messages should be sent; if not present, the log stream is derived from an instance identifier (e.g. 'ip-172-31-23-224.us-west-1.compute.internal')

The __log group__ and the __log stream__ are automatically created if not existing.

In order for the cloudwatch klib to retrieve the appropriate credentials needed to communicate with the CloudWatch Logs server, the AWS instance on which it runs must be associated to an IAM role with the `CloudWatchAgentServerPolicy`,
which must grant permissions for the following actions, as described in https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-access-control-overview-cwl.html :

 - `logs:PutLogEvents`
 - `logs:CreateLogGroup`
 - `logs:CreateLogStream`

Example contents of Ops configuration file:

```json
{
  "Klibs": ["cloudwatch", "tls"],
  "ManifestPassthrough": {
    "cloudwatch": {
      "logging": {
        "log_group": "my_log_group",
        "log_stream": "my_log_stream"
      }
    }
  }
}
```

__Note__: If `log_group` is not set, the `"IMAGE_NAME"` environment variable, if present, will be used to set the `log_group`,
while the _program name_ is used as a _fallback_ setting for `log_group`.

### Cloudwatch metrics

The __cloudwatch__ _klib_ implements sending __memory utilization metrics__ to __AWS CloudWatch__.
Analogously to the implementation in the Linux CloudWatch agent, the metrics being sent are under the __"CWAgent"__ namespace, and have
an associated dimension whose name is "host" and whose value is an instance identifier formatted as in the following example: `"ip-111-222-111-222.us-west-1.compute.internal"`.

The list of supported metrics is:
- __mem_used__
- __mem_used_percent__
- __mem_available__
- __mem_available_percent__
- __mem_total__
- __mem_free__
- __mem_cached__

A description for each of these metrics can be found at https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html, in the section for the Linux CloudWatch agent.
In order for the cloudwatch klib to retrieve the appropriate credentials needed to communicate with the CloudWatch server,
the AWS instance on which it runs must be associated to an IAM role with the CloudWatchAgentServerPolicy, as described in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent.html.
Memory metrics are defined as standard-resolution metrics, i.e. _they are stored with a resolution of 60 seconds_.

The __cloudwatch__ _klib_ is configured via a `cloudwatch` tuple in the image manifest.
Sending of memory metrics is enabled by specifying a sending interval (expressed in seconds) via a `mem_metrics_interval` attribute inside the `cloudwatch` tuple.
The `cloudwatch` klib depends on the `tls` klib for cryptographic operations (which are needed in order to sign the requests being sent to the CloudWatch server).

Example Ops configuration to send memory metrics with a `60-second` interval:

```json
{
  "Klibs": ["cloudwatch", "tls"],
  "ManifestPassthrough": {
    "cloudwatch": {
      "mem_metrics_interval": "60"
    }
  }
}
```

## GCP

The `gcp` klib implements two functionalities that can be used on GCP cloud:

1. `logging` - _console driver_ that sends __console output__ to __GCP logs__
2. `metrics` - emulates some functions of GCP ops agent to send __memory usage metrics__ to the __GCP monitoring service__

__Note:__ When executing the ops instance create command to create a GCP instance, if the `CloudConfig.InstanceProfile` configuration parameter is a non-empty string,
the instance being created is associated to the service account identified by this string, with cloud-platform access scope.
GCP service accounts are identified by an email address; the special string "default" indicates the default service account for a given project.
The service account specified in the configuration must exist in the GCP project when an instance is being created, otherwise an error is returned.
For more information about GCP service accounts, see https://cloud.google.com/compute/docs/access/service-accounts.

### GCP logging

The __gcp__ _klib_ implements a _console driver_ that sends _console output_ to GCP logs.
Instance-specific information that needs to be known in order to interface with the GCP logging API is retrieved from the instance metadata server, which is reachable at address `169.254.169.254`.
GCP logging is enabled by loading the gcp and tls klibs and adding to the root tuple a `"gcp"` tuple that contains a `"logging"` tuple.
The `"logging"` tuple may optionally contain a `"log_id"` attribute that specifies the __[LOG_ID]__ string that is sent in the __"logName"__ parameter (which is formatted as `"projects/[PROJECT_ID]/logs/[LOG_ID]"`)
associated to GCP log entries; __if not present__, the _log ID is derived from the instance hostname as retrieved from the metadata server_.

In order for the GCP klib to retrieve the appropriate credentials needed to communicate with the GCP logging server,
the instance on which it runs must be associated to a service account (see https://cloud.google.com/compute/docs/access/service-accounts).

Instances created by Ops are associated to a service account via the `CloudConfig.InstanceProfile` configuration parameter.

Example contents of Ops configuration file:

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

### GCP metrics

The __gcp__ _klib_ can be configured for sending `memory` and `disk` usage metrics to the __GCP monitoring service__, thus emulating the __GCP ops agent__.
The `ID` of the running instance and the `zone` where it is running (which are necessary to be able to send API requests to the monitoring server) are retrieved from the instance _metadata server_.

- __memory__ usage metrics being sent (see https://cloud.google.com/monitoring/api/metrics_opsagent#agent-memory),
are the `bytes_used` and `bytes_percent` metric types; for each type, a value is sent for each of the __"cached"__, __"free"__ and __"used"__ states.

- __disk__ usage metrics being sent (see https://cloud.google.com/monitoring/api/metrics_opsagent#agent-disk),
are the `bytes_used` and `bytes_percent` metric types; for each type, a value is sent for each of the __"free"__ and __"used"__ states.

In order for the gcp klib to retrieve the appropriate credentials needed to communicate with the GCP monitoring server,
the instance on which it runs must be associated to a service account (see https://cloud.google.com/compute/docs/access/service-accounts).

Instances created by Ops are associated to a service account via the `CloudConfig.InstanceProfile` configuration parameter.

The allowed configuration properties are:
- `metrics` - enable metrics. By default, only __memory__ metrics are sent, __disk__ metrics are disabled.
  - `interval` -  value expressed in __seconds__ to modify the time interval at which metrics are sent. The default (and minimum allowed) value is `60 seconds`.
  - `disk` - enable disk metrics. By default, only __read-write__ mounted disk(s) metrics are sent, __read-only__ disk metrics are disabled.
    - `include_readonly` - enable also __read-only__ disk metrics.

Example Ops configuration to enable sending __memory__ only metrics every `2 minutes`:

```json
{
  "CloudConfig": {
    "Platform": "gcp",
    "ProjectID": "prod-1000",
    "Zone": "us-west1-a",
    "BucketName": "my-s3-bucket",
    "InstanceProfile": "default"
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

Example Ops configuration to enable sending __memory__ metrics and __disk__ metrics (_read-write_ only) every `2 minutes`:

```json
{
  "CloudConfig": {
    "Platform": "gcp",
    "ProjectID": "prod-1000",
    "Zone": "us-west1-a",
    "BucketName": "my-s3-bucket",
    "InstanceProfile": "default"
  },

  "Klibs": ["gcp", "tls"],
  "ManifestPassthrough": {
    "gcp": {
      "metrics": {
        "interval": "120",
        "disk": {}
      }
    }
  }

}
```

Example Ops configuration to enable sending __memory__ metrics and __disk__ metrics (_read-write_ and _read-only_) every `2 minutes`:

```json
{
  "CloudConfig": {
    "Platform": "gcp",
    "ProjectID": "prod-1000",
    "Zone": "us-west1-a",
    "BucketName": "my-s3-bucket",
    "InstanceProfile": "default"
  },

  "Klibs": ["gcp", "tls"],
  "ManifestPassthrough": {
    "gcp": {
      "metrics": {
        "interval": "120",
        "disk": {
          "include_readonly": "true"
        }
      }
    }
  }

}
```

## NTP

The `ntp` klib allows to set the configuration properties to synchronize the unikernel clock with a ntp server.

The allowed configuration properties are:
- `ntp_servers` - array of ntp servers, with each server specified using the format `<address>[:<port]`.
                  The `<address>` string can contain an IP address or a fully qualified domain name;
                  if it contains a numeric IPv6 address, it must be enclosed in square brackets, as per RFC 3986 (example: `"ntp_servers": ["[2610:20:6f97:97::4]", "[2610:20:6f97:97::5]:1234"]`).
                  The default value is **pool.ntp.org:123**.
- `ntp_poll_min` - the minimum poll time is expressed as a power of two.
                   The default value is **4**, corresponding to 16 seconds (2^4 = 16).
                   The minimum value is **4**, corresponding to 16 seconds (2^4 = 16).
- `ntp_poll_max` - the maximum poll time is expressed as a power of two.
                   The default value is **10**, corresponding to 1024 seconds (2^10 = 1024).
                   The maximum value is **17**, corresponding to 131072 seconds (2^17 = 131072 = ~36.4 hours).
- `ntp_reset_threshold` - This is a difference threshold expressed in **seconds** to use _step/jump_ versus _smearing_ on ntp - the default is set to **0** _meaning it will never step/jump_.
                          If the difference is over this threshold then step/jump will be used allowing correction over much longer periods.
- `ntp_max_slew_ppm` - maximum slewing rate for clock offset error correction, expressed in PPM; default value: **83333**
- `ntp_max_freq_ppm` - maximum clock frequency error rate, expressed in PPM; default value: **25000**

When running on AWS, the Elastic Network Adapter (ENA) interface driver on Nanos, has support for retrieving the current time from a _PTP hardware clock_, when supported by the network interface.

 `ntp` klib is able to retrieve time from the _PTP clock_ **alternatively** to _using NTP_, by using the following configuration:
 - `"chrony":{"refclock": "ptp"}`
   - the ntp klib _attempts_ to use the PTP clock for synchronizing the system time
   - if a _PTP clock_ is **not available**, the klib _falls back to NTP_

The `ntp` klib needs to collect some data samples from ntp server(s) before deciding the actions needed to update the clock (if any).
- It needs a minimum of **4** _samples_ to analyze the needed changes - `MIN_SAMPLES 4`
- It keeps a maximum of **30** _samples_ to analyze the needed changes - `MAX_SAMPLES 30`

It is important to understand that until `ntp` has collected at least 4 samples, no actions will be taken to update the clock.
During that time the system will operate under the clock value provided by the hypervisor, which may or may not be correct.
This means that, with default config setup and no ntp request failures, it will take about **53** _seconds_ after boot for the klib to update the system clock if needed.

This can be observed from a debug build of the klib:

```
en1: assigned 10.0.2.15
[0.319779, 0, ntp] adding server 0.us.pool.ntp.org (port 123)
en1: assigned FE80::447A:E3FF:FECF:B36F
[5.697626, 0, ntp] selecting 0.us.pool.ntp.org as current server
[5.700948, 0, ntp] insert 0: 1618876805.261140, off=67692786.324026320, rtd=0.317320199, jit=67692786.324026320
[21.595184, 0, ntp] insert 1: 1618876821.208357, off=67692786.382279612, rtd=0.211364274, jit=0.058253291
[37.591244, 0, ntp] insert 2: 1618876837.206483, off=67692786.380658678, rtd=0.207233731, jit=-0.001620934
[53.585795, 0, ntp] insert 3: 1618876853.203833, off=67692786.377978558, rtd=0.201635557, jit=-0.002680119
[53.591257, 0, ntp] packet offset=67692786.377978558 est_offset(total)=67692786.376225217(67692786.376225217) est_freq(total)=0.000087361(0.000087361) offset_sd=0.008933535 skew=0.118788699
[69.587293, 0, ntp] insert 4: 1686569655.580903, off=0.000968804, rtd=0.202942327, jit=-0.000793821
[69.592481, 0, ntp] packet offset=0.000968804 est_offset(total)=0.003349950(0.003349950) est_freq(total)=-0.000005103(0.000082258) offset_sd=0.009849557 skew=0.040548864
[85.590427, 0, ntp] insert 5: 1686569671.587333, off=-0.001286386, rtd=0.205845955, jit=0.001095304
[85.595407, 0, ntp] packet offset=-0.001286386 est_offset(total)=-0.000979362(-0.000979362) est_freq(total)=-0.000023029(0.000059228) offset_sd=0.007714219 skew=0.012092993
...
[758.312460, 0, ntp] insert 28: 1686570344.311070, off=-0.011912567, rtd=0.269852664, jit=-0.002127423
[758.318662, 0, ntp] packet offset=-0.011912567 est_offset(total)=-0.000798835(-0.000798835) est_freq(total)=-0.000001312(0.000040926) offset_sd=0.003480576 skew=0.000028015
[774.309514, 0, ntp] insert 29: 1686570360.309574, off=-0.010015399, rtd=0.266696978, jit=0.001098517
[774.312045, 0, ntp] packet offset=-0.010015399 est_offset(total)=-0.000703166(-0.000703166) est_freq(total)=-0.000001130(0.000039796) offset_sd=0.003435532 skew=0.000027003
[790.313905, 0, ntp] insert 0: 1686570376.311817, off=-0.006775507, rtd=0.270922496, jit=0.002536878
[790.315987, 0, ntp] packet offset=-0.006775507 est_offset(total)=-0.001349425(-0.001349425) est_freq(total)=-0.000003542(0.000036254) offset_sd=0.002574216 skew=0.000019820
[806.313070, 0, ntp] insert 1: 1686570392.310801, off=-0.005923203, rtd=0.269834293, jit=-0.000496634
[806.316524, 0, ntp] packet offset=-0.005923203 est_offset(total)=-0.000628994(-0.000628994) est_freq(total)=-0.000001222(0.000035031) offset_sd=0.002575573 skew=0.000019651
...
```
Use the configuration file to enable the `ntp` klib and setup the settings.
```json
{
  "Klibs": ["ntp"],
  "ManifestPassthrough": {
    "ntp_servers": ["127.0.0.1:1234"],
    "ntp_poll_min": "5",
    "ntp_poll_max": "10",
    "ntp_reset_threshold": "0",
    "ntp_max_slew_ppm": "83333",
    "ntp_max_freq_ppm": "25000",
    "chrony": {
      "refclock": "ptp"
    }
  }
}
```

### Verifying your NTP is working:

To verify that NTP is working you can run this sample go program and
then manually adjust the clock on qemu:

```json
➜  g cat config.json
{
  "Klibs": ["ntp"],
  "ManifestPassthrough": {
    "ntp_servers": ["0.us.pool.ntp.org:123"],
    "ntp_poll_min": "4",
    "ntp_poll_max": "6"
  }
}
```

```go
➜  g cat main.go
package main

import (
	"fmt"
	"time"
)

func main() {
	for i := 0; i < 10; i++ {
		fmt.Println("Current Time in String: ", time.Now().String())
		time.Sleep(8 * time.Second)
	}
}
```

Run it once to build the image:

```bash
GOOS=linux go build
ops run -c config.json g
```

Then you can grep the ps output of the 'ops run' command which should
look something like this:

and tack on the clock modifier to the end of the command:
```bash
-rtc base="2021-04-20",clock=vm
```

```bash
➜  g qemu-system-x86_64 -machine q35 -device
pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x3
-device pcie-root-port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x3.0x1
-device pcie-root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x3.0x2
-device virtio-scsi-pci,bus=pci.2,addr=0x0,id=scsi0 -device
scsi-hd,bus=scsi0.0,drive=hd0 -vga none -smp 1 -device isa-debug-exit -m
2G -accel hvf -cpu host,-rdtscp -no-reboot -cpu max,-rdtscp -drive
file=/Users/eyberg/.ops/images/g.img,format=raw,if=none,id=hd0 -device
virtio-net,bus=pci.3,addr=0x0,netdev=n0,mac=e6:44:9c:ca:fd:ca -netdev
user,id=n0,hostfwd=tcp::8080-:8080 -display none -serial stdio  -rtc base="2021-04-20",clock=vm
en1: assigned 10.0.2.15
Current Time in String:  2021-04-20 00:00:00.093924867 +0000 UTC
m=+0.001076816
en1: assigned FE80::E444:9CFF:FECA:FDCA
Current Time in String:  2021-04-22 12:06:53.91767521 +0000 UTC
m=+8.008671695
```

## Radar

The `radar` klib allows to send telemetry/crash data to an external [Radar](https://nanovms.com/radar) APM service.

The actual __radar__ _klib_ is pre-configured to send data to `https://radar.relayered.net:443` and requires an api key `Radar-Key` that can be provided as an environment variable.
The available configuration items that can be passed as envs are:

- `RADAR_KEY` - mandatory, used to set `Radar-Key` and enable `radar` klib fuctionality
- `RADAR_IMAGE_NAME` - optional, used to set an `"imageName"` that will be sent to the APM

The `radar` klib depends on the `tls` klib for cryptographic operations.

Sample config to activate the klib functionality:

```json
{
  "Env": {
    "RADAR_KEY": "RADAR_KEY_xyz",
    "RADAR_IMAGE_NAME": "RADAR_IMAGE_NAME_xyz"
  },
  "Klibs": ["radar", "tls"]
}
```

### Radar boot report

Upon boot, the `radar` klib will send some initial data to the Radar server and expects to get back a numeric `"id"` that will be assigned to this boot event as `"bootID"`.

The information sent looks like this:

```
POST /api/v1/boots HTTP/1.1
Host: radar.relayered.net
Content-Length: 116
Content-Type: application/json
Radar-Key: RADAR_KEY_xyz
```

```json
{
  "privateIP": "10.0.2.15",
  "nanosVersion": "0.1.45",
  "opsVersion": "master-dc83aee",
  "imageName": "RADAR_IMAGE_NAME_xyz"
}
```

The radar server should return back an unique id:

```json
{"id":1234}
```

__Note__: If there is a __crash dump__ to be sent, it will be sent **before** sending the _boot report_.

### Radar metrics report

The `radar` klib retrieves from the kernel ifromation about:

- __memory usage__ - retrieved from the kernel _total memory usage in bytes_ __every minute__, and sends retrieved data to the server every __5 minutes__.
                     The __5 samples__ are sent under `"memUsed"` attribute.

- __disk usage__ - retrieved and sent every __5 minutes__. Data is sent under ``"diskUsage"`` attribute whose value is an array of JSON objects (one for each disk mounted by the instance).
                   Each array element contains 3 attributes:

  - `"volume"`: a string that identifies the volume.
                For the root volume, the string value is "root",
                for any additional volumes, the string value is the volume label if present, or the volume UUID if the label is not present
  - `"used"`: the number of bytes used by the filesystem (file contents and meta-data) in the volume
  - `"total"`: the total number of bytes in the storage space of the volume, i.e. the upper limit for the "used" attribute value

The information sent looks like this:

```
POST /api/v1/machine-stats HTTP/1.1
Host: radar.relayered.net
Content-Length: 138
Content-Type: application/json
Radar-Key: RADAR_KEY_xyz
```

```json
{
  "bootID": 1234,
  "memUsed": [
    68329472,
    68329472,
    68329472,
    68329472,
    68329472
  ],
  "diskUsage": [
    {
      "volume": "root",
      "used": 5516288,
      "total": 39779328
    },
    {
      "volume": "2375a5a1-2d36-15cf-ea6b-2fa01df2ccde",
      "used": 12345,
      "total": 39779328
    }
  ]
}
```

### Radar crash report

A __"crash"__ is defined as either a user application fatal error (e.g. anything that causes the application to terminate with a non-zero exit code), or a kernel fatal error.
When any of these happens, before shutting down the VM the kernel dumps on disk a trace of log messages (printed by both the user application and the kernel).
At the next boot, the `radar` klib detects the log dump and sends it to the radar server as a crash report.
The value of the __"id"__ field of a crash report is the same as the __"boot id"__ (sent right after each boot), so that a crash can be unequivocally associated to a boot.

__Note__: The log dump is saved in a section of the disk that is being carved between _stage2_ and the _boot_ filesystem.

The information sent looks like this:

```
POST /api/v1/crashes HTTP/1.1
Host: radar.relayered.net
Content-Length: 213
Content-Type: application/json
Radar-Key: RADAR_KEY_xyz
```

```json
{
  "bootID":1234,
  "nanosVersion":"0.1.45",
  "opsVersion":"master-dc83aee",
  "imageName":"RADAR_IMAGE_NAME_xyz",
  "dump":"en1: assigned 10.0.2.15\nen1: assigned FE80::2885:1DFF:FE7E:9D71\nProcess crash message in here\n"
}
```

__Note__: In order for the submission to be considered successful, radar server needs to respond with a __"specific" confirmation message__, otherwise the crash dump submit will be attempted over and over.

## SpecialFiles

The 'special_files' klib provides a set of pseudo-files that are Nanos
specific.

In particular the config below will populate the path of
`/sys/devices/disks` with the name of each disk attached with the volume
name and UUID of the disk:

```json
{
  "RunConfig": {
    "QMP": true
  },
  "Klibs": ["special_files"],
  "ManifestPassthrough": {
    "special_files": {
      "disks": {}
    }
  },
  "Mounts": {
    "bob": "/bob"
  }
}
```

You can test this behavior with the below program:

```go
package main

import (
        "fmt"
        "os"
        "time"
)

func main() {
        for i := 0; i < 30; i++ {
                body, err := os.ReadFile("/proc/mounts")
                if err != nil {
                        fmt.Println(err)
                }
                fmt.Print(string(body))

                body, err = os.ReadFile("/sys/devices/disks")
                if err != nil {
                        fmt.Println(err)
                }
                fmt.Print(string(body))

                time.Sleep(2 * time.Second)
        }
}
```

This functionality provides similar lsblk like functionality you might
find on linux, however, different cloud providers do not put the same uniquely identifiable
information into the serial/id of the device so we implemented this instead.

## Syslog

If you can point your app at a syslog we encourage you to do that:

https://nanovms.com/dev/tutorials/logging-go-unikernels-to-papertrail

However, if you have no control over the application than you can direct
Nanos to use the syslog klib and it will ship everything over.

Just pass in the desired syslog server along with the syslog
klib in your config.

If the `"IMAGE_NAME"` environment variable is present, it is used to populate the `APP_NAME` field in syslog messages,
while the `program` _name_ is used as a _fallback_.

For example, if running locally via user-mode you can use 10.0.2.2:

```json
{
  "Env": {
    "IMAGE_NAME": "app-name-in-syslog-msg"
  },
  "ManifestPassthrough": {
    "syslog": {
      "server": "10.0.2.2",
      "server_port": "514"
    }
  },
  "Klibs": ["syslog"]
}
```

If you need the logs to be also stored in a file:

```json
{
  "Env": {
    "IMAGE_NAME": "app-name-in-syslog-msg"
  },
  "ManifestPassthrough": {
    "syslog": {
      "server": "10.0.2.2",
      "server_port": "514",
      "file": "/tmp/sys.log",
      "file_max_size": "8M",
      "file_rotate": "9"
    }
  },
  "Klibs": ["syslog"]
}
```

If you are running on Linux you can use rsyslogd for this. By default
rsyslogd will not listen on UDP 514 so you can un-comment the lines in
/etc/rsyslog.conf:

```
module(load="imudp")
input(type="imudp" port="514")
```

and restart:

```
sudo service rsyslog restart
```

also you can disable the dupe filter or add a timetstamp to skirt around
that.

## TUN

The `tun` klib is used to create TUN interfaces, namely _network TUNnel_, that simulate a network layer device operating in __layer 3__ of OSI Model carrying IP packets.

Can be used when running vpn gateways (i.e userspace wireguard).

The allowed configuration properties for the tun interface(s) are:
- `interface base name` - i.e `wg`, `tun`
  - `ipaddress` - ip address of the interface
  - `netmask` - netmask of the interface
  - `mtu` - configures the __mtu__ value of the interface, default value is __32768__ (32KiB)
  - `up` - __true__/__false__ manages the interface initial state

Sample config:

```json
{
  "Klibs": ["tun"],
  "ManifestPassthrough": {
    "tun": {
      "wg": {
        "ipaddress": "172.16.0.1",
        "netmask": "255.255.255.0",
        "up": "true",
        "mtu": "1420"
      }
    }
  }
}
```

## Cloud Init - HTTP(s) to File/Env KLIB

Cloud Init has 3 functions.

1) For Azure machines it is auto-included to check in to the meta server
to tell Azure that the machine has completed booting. This is necessary,
otherwise Azure will think it failed.

2) One can include this on any platform to download one or more extra
files to the instance for post-deploy config options. This is useful
when security or ops teams are separate from dev or build teams and they
might handle deploying tls certificates or secrets post-deploy. All
files are downloaded before execution of the main program.

3) One can include this on any platform to populate the environment
of the user process with variables whose name and value are retrieved
from an HTTP(S) server during startup.

The cloud_init klib supports a configuration option to overwrite previous files: it's called `overwrite`.
If you specify this option for a given file, by inserting an `overwrite` JSON attribute with any string value,
cloud_init will re-download the file at every boot.

The cloud_init klib also supports simple authentication mechanisms by using `auth` config option.
It uses HTTP Authorization request header `Authorization: <auth-scheme> <authorization-parameters>`
where `<auth-scheme>` and  `<authorization-parameters>` are configurable.

Certain caveats to be aware of:

* Only direct download links are supported today. (no redirects)
* HTTP chunked transfer encoding is not supported, (don't try to download a movie).
  If the source server uses this encoding, a file download may never complete.
* When cloud_init cannot download one or more files, the kernel does not start the user program.
  The rationale for this is that we want all files to be ready and accessible when the program starts.
* When used to populate the user environment, only string-valued attributes are converted to environment variables (**non-string-valued attributes are ignored**).
* The `cloud_init` klib (`download_env` functionality) is **not meant** to be used to set environment variables _whose value is used in other klibs or in the kernel code_
  (e.g. the `"IMAGE_NAME"` environment variable used by the `syslog` klib), because the code that uses an environment variable _can be executed before_ `cloud_init` sets a value for the variable.

Also, be aware that you set an appropriate minimum image base size to
accomodate your files.

Example Go program:

```go
package main

import (
	"fmt"
	"os"
)

func main() {
	body, err := os.ReadFile("/nanos.md")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Print(string(body))

}
```

Example config - _no overwrite_ - existing destination file won't be changed/overwritten:

```json
{
  "BaseVolumeSz": "20m",
  "Klibs": ["cloud_init", "tls"],

  "ManifestPassthrough": {
    "cloud_init": {
      "download": [
        {
          "src": "https://raw.githubusercontent.com/nanovms/ops-documentation/master/README.md",
          "dest": "/nanos.md"
        }
      ]
    }
  }

}
```

Example config - _overwrite_ - existing destination file will be replaced/overwritten at every boot:

```json
{
  "BaseVolumeSz": "20m",
  "Klibs": ["cloud_init", "tls"],

  "ManifestPassthrough": {
    "cloud_init": {
      "download": [
        {
          "src": "https://raw.githubusercontent.com/nanovms/ops-documentation/master/README.md",
          "dest": "/nanos.md",
          "overwrite": "t"
        }
      ]
    }
  }

}
```

Example config, basic access authentication - _auth_ - `Authorization` header will be added to the request:

```json
{
  "BaseVolumeSz": "20m",
  "Klibs": ["cloud_init", "tls"],

  "ManifestPassthrough": {
    "cloud_init": {
      "download": [
        {
          "src": "https://httpbin.org/hidden-basic-auth/user/passwd",
          "dest": "/basic_auth_test.txt",
          "auth": "Basic dXNlcjpwYXNzd2Q="
        }
      ]
    }
  }

}
```

Example config, with environment variables management - `download_env` config:

The configuration syntax in the manifest to use this functionality is as in the following example:

```json
  "ManifestPassthrough": {
    "cloud_init": {

      "download_env": [
        {
          "src": "http://10.0.2.2:8200/v1/secret/data/hello",
          "auth": "Bearer hvs.6v6yY5yZf32uZzaa7HhiX6AZ",
          "path": "attr1/attr2"
        }
      ]

    }
  },
```

The `download_env` attribute is an array where each element specifies
 - `src`  - download source URL
 - `auth` - _optional_ authentication header
 - `path` -  _optional_ attribute path

For each element in the `download_env` attribute, the klib executes an HTTP request to the specified URL, and if the peer responds successfully,
the response body is parsed as a JSON object, and from this object an "environment object" is retrieved.

If the attribute path (i.e. the path element in the manifest) is not present (or is empty), the environment object corresponds to the root JSON object of the response body, otherwise,
for each element in the attribute path (`where the element separator is the / character`), a _nested_ JSON object is retrieved from the response body by looking up an attribute named after the element
(**the corresponding attribute value must be a JSON object**): _the environment object is the nested object corresponding to the last element of the attribute path_.

Once the environment object is identified, **all string-valued attributes** in this object are converted to environment variables (**non-string-valued attributes are ignored**).

Examples:

an empty attribute path can be used to retrieve the environment variables from the following response body:

```json
{
  "VAR1": "value1",
  "VAR2": "value2"
}
```

an attribute path set to "obj1/obj2" can be used to retrieve the environment variables from the following response body:

```json
{
  "obj1": {
    "obj2": {
      "VAR1": "value1",
      "VAR2": "value2"
    }
  }
}
```

`"VAR1"` and `VAR2`, being **non-string-valued attributes**, will be **ignored** from the following response body:

```json
{
  "VAR1": 1,
  "VAR2": true,
  "VAR3": "value3"
}
```

Full example:

nanos config:

```json
{
  "BaseVolumeSz": "20m",
  "Klibs": [
    "cloud_init",
    "tls"
  ],
  "ManifestPassthrough": {
    "cloud_init": {
      "download": [
        {
          "src": "https://httpbin.org/hidden-basic-auth/user/passwd",
          "dest": "/cloud_init_test.json",
          "overwrite": "t",
          "auth": "Basic dXNlcjpwYXNzd2Q="
        }
      ],
      "download_env": [
        {
          "src": "https://httpbin.org/hidden-basic-auth/user/passwd",
          "auth": "Basic dXNlcjpwYXNzd2Q=",
          "path": ""
        }
      ]
    }
  }
}

```

go program sample:

```go
package main

import (
	"fmt"
	"os"
)

const (
	AUTH_RESULT_FILE  = "cloud_init_test.json" // {"authenticated": true, "user": "user"}
	ENV_AUTHENTICATED = "authenticated"
	ENV_USER          = "user"
)

func main() {
	// ManifestPassthrough.cloud_init.download
	authResult, err := os.ReadFile(AUTH_RESULT_FILE)
	if err != nil {
		fmt.Printf("error reading file - %s (%s)\n", AUTH_RESULT_FILE, err.Error())
	} else {
		fmt.Printf("%s - content:\n", AUTH_RESULT_FILE)
		fmt.Printf("%s\n", string(authResult))
	}

	// ManifestPassthrough.cloud_init.download_env
	authenticated, ok := os.LookupEnv(ENV_AUTHENTICATED)
	if !ok {
		fmt.Printf("ENV: %q - not found\n", ENV_AUTHENTICATED)
	} else {
		fmt.Printf("ENV: %q = %q\n", ENV_AUTHENTICATED, authenticated)
	}

	// ManifestPassthrough.cloud_init.download_env
	user, ok := os.LookupEnv(ENV_USER)
	if !ok {
		fmt.Printf("ENV: %q - not found\n", ENV_USER)
	} else {
		fmt.Printf("ENV: %q = %q\n", ENV_USER, user)
	}
}
```

from the result, as expected, `"authenticated"` - being **non-string-valued attribute**, is not available in the environment:

```sh
booting /home/ops/.ops/images/cloudinit_test ...
...

cloud_init_test.json - content:
{
  "authenticated": true,
  "user": "user"
}

ENV: "authenticated" - not found
ENV: "user" = "user"
...
```

## Firewall

This klib implements a __network firewall__. The firewall can drop IP packets received from any network interface, based on a set of rules defined in the manifest.
Each rule is specified as a tuple located in the rules array of the firewall tuple in the manifest. Valid attributes for a firewall rule are the following:

* `ip`: matches IPv4 packets, and is a tuple that can have the following attributes:
  * `src`: matches packets based on the __source IPv4 address__, which is specified with the standard _dotted notation_ __aaa.bbb.ccc.ddd__,
           can be _prefixed_ by an optional __!__ character which makes the rule match packets with an address different from the provided value,
           and can be _suffixed_ with an __optional netmask__ (with format /<n>, where <n> can have a value from 1 to 32) which matches packets based on the first part of the provided address

* `ip6`: matches IPv6 packets, and is a tuple that can have the following attributes:
  * `src`: matches packets based on the __source IPv6 address__, which is specified with the standard notation for IPv6 addresses,
           and similarly to its IPv4 counterpart can be _prefixed_ with a __!__ character and _suffixed_ with a __netmask (with allowed values from 1 to 128)__

* `tcp`: matches TCP packets, and is a tuple that can have the following attributes:
  * `dest`: matches packets based on the __TCP destination port__ (whose value can be prefixed with a __!__ character to negate the logical comparison with the port value in a packet)

* `udp`: matches UDP packets, and is a tuple that can have the following attributes:
  * `dest`: matches packets based on the __UDP destination port__ (whose value can be prefixed with a __!__ character to negate the logical comparison with the port value in a packet)

* `action`: indicates which action should be performed by the firewall when a matching packet is received:
            _allowed_ values are __"accept"__ and __"drop"__; if this attribute is not present, __the default action for the rule is to drop matching packets__

Firewall rules are _evaluated for each received packet in the order they are defined_,
until a matching rule (i.e. a rule where all the attributes match the packet contents) is found and the corresponding action is executed.
_If a packet does not match any rule, it is_ __accepted__.

Example contents of Ops configuration file:

* accept all TCP packets to port 8080, drop all other packets:

```json
{
  "Klibs": ["firewall"],
  "ManifestPassthrough": {
    "firewall": {
      "rules": [
        {"tcp": {"dest": "8080"}, "action": "accept"},
	    {"action": "drop"}
      ]
    }
  }
}
```

* accept all packets coming from IP address 10.0.2.2, drop packets from other addresses unless they are to TCP port 8080:

```json
{
  "Klibs": ["firewall"],
  "ManifestPassthrough": {
    "firewall": {
      "rules": [
        {"ip": {"src": "10.0.2.2"}, "action": "accept"},
        {"tcp": {"dest": "8080"}, "action": "accept"},
	    {"action": "drop"}
      ]
    }
  }
}
```

* drop all packets coming from IP address 10.0.2.2:

```json
{
  "Klibs": ["firewall"],
  "ManifestPassthrough": {
    "firewall": {
      "rules": [
        {"ip": {"src": "10.0.2.2"}, "action": "drop"}
      ]
    }
  }
}
```

* drop IPv4 packets coming from addresses other than 10.0.2.2:

```json
{
  "Klibs": ["firewall"],
  "ManifestPassthrough": {
    "firewall": {
      "rules": [
        {"ip": {"src": "!10.0.2.2"}, "action": "drop"}
      ]
    }
  }
}
```

* drop all UDP packets coming from IP addresses in the range 10.0.2.0-10.0.2.255:

```json
{
  "Klibs": ["firewall"],
  "ManifestPassthrough": {
    "firewall": {
      "rules": [
        {"ip": {"src": "10.0.2.0/24"}, "udp": {}, "action": "drop"}
      ]
    }
  }
}
```

* drop all packets coming from IPv6 address FE80::FF:7762:

```json
{
  "Klibs": ["firewall"],
  "ManifestPassthrough": {
    "firewall": {
      "rules": [
        {"ip6": {"src": "FE80::FF:7762"}, "action": "drop"}
      ]
    }
  }
}
```

## Sandbox

This klib implements a __sandboxing mechanism__ by which the capabilities of the running process can be _restricted_ by _overriding certain syscall handlers_.

The current implementation supports the following OpenBSD syscalls:
 - `pledge` - https://man.openbsd.org/pledge.2
 - `unveil` - https://man.openbsd.org/unveil.2

A `pledge` invocation forces the process into a restricted-service operating mode by limiting the set of syscalls (and in some cases the allowed values of syscall arguments) that can be invoked.
Syscalls that are present in both Nanos and OpenBSD are handled by following the pledge implementation in OpenBSD, except for syscalls that are not applicable to unikernels (e.g. those related to inter-process communication).
Syscalls that are present (or could be implemented in the future) in Nanos but not in OpenBSD are handled based in the same way as "similar" or related OpenBSD syscalls when such syscalls could be found,
and are always forbidden when no related syscalls could be found in OpenBSD.

The `unveil` syscall allows adding and removing (or restricting) visibility of filesystem paths for the running process.

The `pledge` and `unveil` features are enabled in the __sandbox__ _klib_ if the __manifest__ contains a `sandbox` tuple with a `pledge` and `unveil` tuple, respectively.

```json
{
  "Klibs": ["sandbox"],
  "ManifestPassthrough": {
    "sandbox": {
      "pledge": {},
      "unveil": {}
    }
  }
}

```

### C

The `pledge` syscall can be invoked in a C program by calling the `pledge()` function from the following code:

```c
int pledge(const char *promises, const char *execpromises)
{
    return syscall(335, promises, execpromises);
}
```


It can be invoked in a C program by calling the `unveil()` function from the following code:

```c
int unveil(const char *path, const char *permissions)
{
    return syscall(336, path, permissions);
}
```

### Go

The following Go code provides the basis for a `nanos_sandbox` package:

```go
package nanos_sandbox

import (
	"syscall"
	"unsafe"
)

const (
	// OpenBSD syscalls, mapped to unused syscall numbers in Linux
	SYS_pledge = 335
	SYS_unveil = 336
)

// Pledge implements the pledge syscall.
//
// For more information see pledge(2).
func Pledge(promises, execpromises string) error {
	pptr, err := syscall.BytePtrFromString(promises)
	if err != nil {
		return err
	}

	// pass execpromises to the syscall.
	exptr, err := syscall.BytePtrFromString(execpromises)
	if err != nil {
		return err
	}

	_, _, e := syscall.Syscall(SYS_pledge, uintptr(unsafe.Pointer(pptr)), uintptr(unsafe.Pointer(exptr)), 0)
	if e != 0 {
		return e
	}

	return nil
}

// PledgePromises implements the pledge syscall.
//
// This changes the promises and leaves the execpromises untouched.
//
// For more information see pledge(2).
func PledgePromises(promises string) error {
	// This variable holds the execpromises and is always nil.
	var exptr unsafe.Pointer

	pptr, err := syscall.BytePtrFromString(promises)
	if err != nil {
		return err
	}

	_, _, e := syscall.Syscall(SYS_pledge, uintptr(unsafe.Pointer(pptr)), uintptr(exptr), 0)
	if e != 0 {
		return e
	}

	return nil
}

// Unveil implements the unveil syscall.
// For more information see unveil(2).
// Note that the special case of blocking further
// unveil calls is handled by UnveilBlock.
func Unveil(path string, flags string) error {
	pathPtr, err := syscall.BytePtrFromString(path)
	if err != nil {
		return err
	}

	flagsPtr, err := syscall.BytePtrFromString(flags)
	if err != nil {
		return err
	}

	_, _, e := syscall.Syscall(SYS_unveil, uintptr(unsafe.Pointer(pathPtr)), uintptr(unsafe.Pointer(flagsPtr)), 0)
	if e != 0 {
		return e
	}

	return nil
}

// UnveilBlock blocks future unveil calls.
// For more information see unveil(2).
func UnveilBlock() error {
	// Both pointers must be nil.
	var pathUnsafe, flagsUnsafe unsafe.Pointer

	_, _, e := syscall.Syscall(SYS_unveil, uintptr(pathUnsafe), uintptr(flagsUnsafe), 0)
	if e != 0 {
		return e
	}

	return nil
}

```

### JavaScript

There are 2 npm packages published and ready for use.

- `pledge` - https://www.npmjs.com/package/nanos-pledge
- `unveil` - https://www.npmjs.com/package/nanos-unveil

## Out-of-tree klibs

In addition to the above klibs, whose source code is included in the Nanos kernel source tree, out-of-tree klibs can also be created to enhance Nanos with additional functionality. Provided that such klibs are compiled against the exact version of the kernel being used, they can be added to a given image and will be loaded by the kernel during initialization just like in-tree klibs.

### gpu_nvidia

This klib, whose source code is available on [GitHub](https://github.com/nanovms/gpu-nvidia/), implements a driver for NVIDIA Graphical Processing Units. It is a port to the Nanos kernel of the open-source Linux driver released by NVIDIA for its GPU cards; at the time of this writing, the gpu_nvidia klib is based on version 535.113.01 of the NVIDIA driver.

As with any out-of-tree klib, in order to build this klib the source code of the Nanos kernel version being used needs to be available in the development machine; then, the following command can be used to build the klib (replace `/path/to/nanos/kernel/source` with the actual filesystem path where the kernel source is located):

```bash
make NANOS_DIR=/path/to/nanos/kernel/source
```

The resulting klib binary file will be located at kernel-open/_out/Nanos_x86_64/gpu_nvidia in the klib source tree. In order for this file to be found by Ops, either the file has to be copied (or symlinked) in the folder containing the in-tree klibs for the kernel version being used (e.g. ~/.ops/0.1.47/klibs/), or the `KlibDir` configuration option has be to added to the Ops configuration file to point to the folder where the klib file is located; example using the latter approach:

```json
{
  "KlibDir": "/usr/src/gpu-nvidia/kernel-open/_out/Nanos_x86_64",
  "Klibs": ["gpu_nvidia"]
}
```

The NVIDIA driver requires a firmware file to be available in the image, so that this file can be transferred to the GPU card during initialization. A GPU firmware file is tied to a specific kernel version; in order to retrieve the correct firmware files, download the NVIDIA Linux driver package for Linux 64-bit from <https://www.nvidia.com/Download/Find.aspx?lang=en-us>, then extract the package: firmware files will be located in the `firmware` subfolder of the extracted package contents. For driver version 535.113.01, there are two separate firmware files (gsp_ga10x.bin and gsp_tu10x.bin), each of which is used for a subset of the supported GPUs; which of these files is needed by the driver during initialization depends on the type of NVIDIA card attached to the instance: for example, GeForce 3090 and 4090 cards use the gsp_ga10x.bin file. The firmware file has to be put in the unikernel image in the `/nvidia/<driver_version>/` folder; for example, to use an NVIDIA GeForce 3090 GPU with driver version 535.113.01, the /nvidia/535.113.01/gsp_ga10x.bin file has to be included in the image.

The Ops configuration options to deploy a Nanos image to a GPU-equipped instance are "GPUs" (which specifies the number of GPUs to be attached to the instance) and "GPUType" (which specifies the type of GPU, and can be used on certain cloud providers such as GCP which allow attaching different GPU types to the same instance type). Example configuration for GCP:

```json
{
  "CloudConfig" :{
    "ProjectID" :"my-proj",
    "Zone": "us-west1-b",
    "BucketName":"my-bucket",
    "Flavor":"n1-standard-1"
  },
  "RunConfig": {
    "GPUs": 1,
    "GPUType": "nvidia-tesla-t4"
  }
}
```

For on-prem instances, if the host machine is equipped with one or more GPUs, it is possible to attach (a subset of) these GPUs to a Nanos instance via PCI passthrough, by specifying the "GPUs" configuration option with the desired number of GPUs. For example:

```json
{
  "RunConfig": {
    "GPUs": 1
  }
}
```

PCI passthrough is only available on x86_64 Linux host machines, and requires I/O virtualization to be supported and enabled in the host: this may require enabling VT-d (for Intel CPUs) or AMD IOMMU (for AMD CPUs) in the BIOS settings, and adding the `intel_iommu=on iommu=pt` (for Intel CPUs) or `amd_iommu=on iommu=pt` (for AMD CPUs) options to the Linux kernel command line. In addition, the vfio-pci Linux kernel driver must be loaded and bound to the GPU device(s) to be attached to an instance: if the driver is built into the kernel binary, add `vfio-pci.ids=:<vvvv>:<dddd>` (where `<vvvv>` is the PCI vendor ID and `<dddd>` is the PCI device ID of the host GPU) to the kernel command line, otherwise (if the driver is built as a kernel module) ensure that the driver is loaded with the "ids" option set to the PCI vendor and device ID of the GPU (for example, create a file named /etc/modprobe.d/vfio.conf which contains `options vfio-pci ids=10de:1eb8"`). In order for VFIO devices to be accessible by the hypervisor process, their file attributes must be properly configured, e.g. with the following udev rule: `SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"`.
