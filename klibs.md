Klibs
=======

Klibs are plugins which provide extra functionality to unikernels.


## NTP
The `ntp` klib allows to set the configuration properties to synchronize the unikernel clock with a ntp server. The allowed configuration properties are the ntp server address and port, and the minimum and the maximum poll time. Use the configuration file to setup the `ntp` klib.
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
