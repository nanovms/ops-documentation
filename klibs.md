Klibs
=======

Klibs are plugins which provide extra functionality to unikernels.

As of the 0.1.34 release there are 10 klibs:

* aws
* cloud_azure - use to check in to the Azure meta-data service
* cloud_init - used for Azure && env config init
* cloudwatch - use to implement cloudwatch agent for AWS
* ntp - used for clock syncing
* radar - a klib if using the external Radar service
* syslog - used to ship stdout/stderr to an external syslog - useful if you can't/won't modify code
* test - a simple test/template klib
* tls - used for radar/ntp and other klibs that require it
* tun - supports tun devices (eg: vpn gateways)

Not all of these are available to be included in your config. Only the
ones found in your ~/.ops/release/klibs folder can be specified.

Some of these are auto-included as they provide support that is required
by certain clouds/hypervisors. You should only include a klib if you
think you need it. The ones that are required for certain functionality
will be auto-included by ops. For instance if you are deploying to Azure
we'll auto-include the cloud_init and tls klibs.

## NTP

The `ntp` klib allows to set the configuration properties to synchronize the unikernel clock with a ntp server.

The allowed configuration properties are:
- `ntp_servers` - array of ntp servers, with each server specified using the format `<address>[:<port]`. The `<address>` string can contain an IP address or a fully qualified domain name; if it contains a numeric IPv6 address, it must be enclosed in square brackets, as per RFC 3986 (example: `"ntp_servers": ["[2610:20:6f97:97::4]", "[2610:20:6f97:97::5]:1234"]`)
- `ntp_poll_min` - the minimum poll time is expressed as a power of two. The default value is 4, corresponding to 16 seconds (2^4 = 16)
- `ntp_poll_max` - the maximum poll time is expressed as a power of two. The default value is 10, corresponding to 1024 seconds (2^10 = 1024)
- `ntp_reset_threshold` - This is a difference threshold expressed in seconds to use step/jump versus smearing on ntp - the default is set to 0 meaning it will never step/jump. If the difference is over this threshold then step/jump will be used allowing correction over much longer periods
- `ntp_max_slew_ppm` - maximum slewing rate for clock offset error correction, expressed in PPM; default value: 83333
- `ntp_max_freq_ppm` - maximum clock frequency error rate, expressed in PPM; default value: 25000

Use the configuration file to enable the `ntp` klib and setup the settings.
```json
{
  "RunConfig": {
    "Klibs": ["ntp"]
  },
  "ManifestPassthrough": {
    "ntp_servers": ["127.0.0.1:1234"],
    "ntp_poll_min": "5",
    "ntp_poll_max": "10"
  }
}
```

### Verifying your NTP is working:

To verify that NTP is working you can run this sample go program and
then manually adjust the clock on qemu:

```json
➜  g cat config.json
{
  "RunConfig": {
    "Klibs": ["ntp"]
  },
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

## Syslog

If you can point your app at a syslog we encourage you to do that:

https://nanovms.com/dev/tutorials/logging-go-unikernels-to-papertrail

However, if you have no control over the application than you can direct
Nanos to use the syslog klib and it will ship everything over.

Just pass in the desired syslog server along with the syslog
klib in your config.

For example, if running locally via user-mode you can use 10.0.2.2:

```json
{
  "ManifestPassthrough": {
    "syslog": {
      "server": "10.0.2.2"
    }
  },
  "RunConfig": {
    "Klibs": ["syslog"]
  }
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
  "RunConfig": {
    "Klibs": ["cloud_init", "tls"]
  },

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
  "RunConfig": {
    "Klibs": ["cloud_init", "tls"]
  },

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
  "RunConfig": {
    "Klibs": ["cloud_init", "tls"]
  },

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
  "RunConfig": {
    "Klibs": [
      "cloud_init",
      "tls"
    ]
  },
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
