Firecracker Integration
========================

OPS works well with Firecracker from AWS. OPS doesn't currently interact
with the firecracker api but can produce disk images for you to use with
firecracker.


To run:

```
./firecracker --api-sock /tmp/firecracker.socket --config-file vm_config.json
```

You should replace the kernel.img file with the location of your kernel
and the my_img.img with the unikernel disk image of choice:

The vm_config.json:
```
{
  "boot-source": {
    "kernel_image_path": "/home/eyberg/.ops/nightly/kernel.img",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "/home/eyberg/.ops/images/g",
      "is_root_device": true,
      "is_read_only": false
    }
  ],
  "network-interfaces": [
    {
      "iface_id": "eth0",
      "guest_mac": "AA:FC:00:00:00:01",
      "host_dev_name": "tap0"
    }
  ],
  "machine-config": {
    "vcpu_count": 1,
    "mem_size_mib": 1024
  },
  "logger": {
    "log_path": "log.fifo",
    "level": "Info",
    "show_level": true,
    "show_log_origin": true
  }
}
```

You should have a dhcp listener. You can create a bridge and a dhcp
server by running:

```
ops network create
```

If you are running via ops we'll create and attach the tap device for
you but or firecracker you'll need to Create a tap device:
```
sudo ip tuntap add dev tap0 mode tap
sudo ip addr add 10.0.2.1/24 dev tap0
sudo ip link set tap0 up
```

and you should see the unikernel snag an ip:

```
Server started on port 8080
assigned: 10.0.2.10
assigned: 0.0.0.0
```

If you would like diagnostic logs you can try this before turning on the
vm:

boot.sh:
```
#!/bin/sh

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/boot-source' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"kernel_image_path": "/home/bob/.ops/0.1.26/kernel.img",
"boot_args": "console=ttyS0 reboot=k panic=1 pci=off" }'
```

drives.sh:
```
#!/bin/sh

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/drives/rootfs' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
      "drive_id": "rootfs",
      "path_on_host": "/home/bob/.ops/0.1.26/images/my_img.img",
      "is_root_device": true,
      "is_read_only": false

}'
```

machine.sh:
```
#!/bin/sh

 curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/machine-config' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
    "vcpu_count": 1,
    "mem_size_mib": 1024,
    "ht_enabled": false
}'
```

start.sh:
```
#!/bin/sh

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/actions' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"action_type": "InstanceStart"
}'
```

### Logs

logs.sh:
```
#!/bin/sh

mkfifo log.fifo

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/logger' \
-H "accept: application/json" \
-H "Content-Type: application/json" \
-d '{ "log_path": "log.fifo", "level": "Info", "show_level": true, "show_log_origin": true }'
```

Finally read your logs:

read_fifo.sh:
```
#!/bin/bash

while true
do
    if read line <$1; then
        if [[ "$line" == 'quit' ]]; then
            break
        fi
        echo $line
    fi
done

echo "Reader exiting"
```

```
 ./read_fifo.sh log.fifo
```

### Configuration

You can now dynamically re-configure your unikernel via the firecracker
kernel boot_args line such as adding tracing support:

```
"boot-source": {
    "kernel_image_path": "/Users/bob/.ops/nightly/kernel.img",
    "boot_args": "trace=t debugsyscalls=t"
  }
```

or you could set a static ipv4:

```
"boot-source": {
    "kernel_image_path": "/Users/bob/.ops/nightly/kernel.img",
    "boot_args": "en1.ipaddr=10.3.3.6 en1.netmask=255.255.0.0 en1.gateway=10.3.0.1"
}
```

or set an env var:

```
"boot-source": {
    "kernel_image_path": "/Users/bob/.ops/nightly/kernel.img",
    "boot_args": "environment.PROD=1"
}
```

or set arbitrary arguments:

```
"boot-source": {
    "kernel_image_path": "/Users/bob/.ops/nightly/kernel.img",
    "boot_args": "arguments.0=/python3 arguments.1=my_new_entrypoint.py"
}
```

### Known Limitations

Note the following limitations when running workloads under Firecracker.
These are *not* Nanos limitations but limitations imposed via
Firecracker because of its unique setup:

* No GPU support.
* No MQ (multi-queue) taps.

Note: If you're interested in using something like firecracker but need
GPU support check out
[https://www.cloudhypervisor.org/](https://www.cloudhypervisor.org/)
