# Bhyve Integration

Nanos works on Bhyve with some caveats:

* Nanos uses ELF files so this support is intended more to run Nanos
  images not necessarily build them since the default file format on
  FreeBSD is a.out.

Nanos has been test on 13.6.0 and 14.x.

Install bhyve firmware:

```
pkg install sysutils/bhyve-firmware 
```

Create a tap/bridge:

```
# ifconfig tap0 create
# sysctl net.link.tap.up_on_open=1
net.link.tap.up_on_open: 0 -> 1
# ifconfig bridge0 create
# ifconfig bridge0 addm em0 addm tap0
# ifconfig bridge0 up
```

Create/run a Nanos VM:

```
# bhyve -AHP -s 0:0,hostbridge -s 1:0,virtio-blk,./disk.raw \
  -s 2:0,virtio-net,tap0 -s 3:0,virtio-rnd -s 31:0,lpc \
  -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
  -l com1,stdio nanos
```

To stop the VM:

```
killall bhyve
```

When building with OPS include the UEFI loader in your config.json:

```
{
  "Uefi": true
}
```
