Klibs
=======

Klibs are plugins which provide extra functionality to unikernels.

As of the 0.1.34 release there are 7 klibs:

cloud_init - used for Azure && env config init
ntp - used for clock syncing
radar - a klib if using the external Radar service
syslog - used to ship stdout/stderr to an external syslog - useful if
you can't/won't modify code
test - a simple test/template klib
tls - used for radar/ntp and other klibs that require it
tun - supports tun devices (eg: vpn gateways)

## NTP

The `ntp` klib allows to set the configuration properties to synchronize the unikernel clock with a ntp server.

The allowed configuration properties are:
- `ntpAddress` - the ntp server address;
- `ntpPort` - the ntp sever port;
- `ntpPollMin` - the minimum poll time is expressed as a power of two. The default value is 6, corresponding to 64 seconds (2^6 = 64);
- `ntpPollMax` - the maximum poll time is expressed as a power of two. The default value is 10, corresponding to 1024 seconds (2^10 = 1024).
- `ntpResetThreshold` - This is a difference threshold expressed in seconds to use step/jump versus smearing on ntp - the default is set to 0 meaning it will never step/jump. If the difference is over this threshold then step/jump will be used allowing correction over much longer periods.

Use the configuration file to enable the `ntp` klib and setup the settings.
```json
{
  "RunConfig": {
    "Klibs": ["ntp"]
  },
  "Env": {
    "ntpAddress": "127.0.0.1",
    "ntpPort": "1234",
    "ntpPollMin": "5",
    "ntpPollMax": "10"
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
  "Env": {
    "ntpAddress": "0.us.pool.ntp.org",
    "ntpPort": "123",
    "ntpPollMin": "4",
    "ntpPollMax": "6"
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

```
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
