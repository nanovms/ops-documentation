Klibs
=======

Klibs are plugins which provide extra functionality to unikernels.


## NTP

The `ntp` klib allows to set the configuration properties to synchronize the unikernel clock with a ntp server.

The allowed configuration properties are:
- `ntpAddress` - the ntp server address;
- `ntpPort` - the ntp sever port;
- `ntpPollMin` - the minimum poll time is expressed as a power of two. The default value is 6, corresponding to 64 seconds (2^6 = 64);
- `ntpPollMax` - the maximum poll time is expressed as a power of two. The default value is 10, corresponding to 1024 seconds (2^10 = 1024).

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
