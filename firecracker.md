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
    "kernel_image_path": "/Users/bob/.ops/0.1.26/kernel.img",
    "boot_args": "anything-in-here-is-ignored-by-nanos"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "/Users/bob/.ops/images/my_img.img",
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
    "mem_size_mib": 1024,
    "ht_enabled": false
  }
}
```

__Note__: At the moment, the only boot_args supported by `nanos` are those inserted by firecracker to describe the topology of __virtio_mmio__ devices (such as the _disk_ and _network interfaces_).
          There is _no support yet_ for __user-specified args__ such as `"boot_args": "console=ttyS0 reboot=k panic=1 pci=off random.trust_cpu=on ..."`

You should have dhcp listen on your tap:

```
sudo apt-get install isc-dhcp-server
```

Create a tap device:
```
sudo ip tuntap add dev tap0 mode tap
sudo ip addr add 10.0.2.1/24 dev tap0
sudo ip link set tap0 up
```

Sample dhcp config:
```

option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

ddns-update-style none;

INTERFACES="tap0";

subnet 10.0.2.0 netmask 255.255.255.0 {
    option routers 10.0.2.1;
range 10.0.2.10 10.0.2.255;
}
```

```sh
dhcpd -f -d tap0
```

If this is setup correctly you should see some arp requests fly by:

```
bob@box:/home/eyberg~ dhcpd -f -d tap0
Internet Systems Consortium DHCP Server 4.3.5
Copyright 2004-2016 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/
Config file: /etc/dhcp/dhcpd.conf
Database file: /var/lib/dhcp/dhcpd.leases
PID file: /var/run/dhcpd.pid
lease 10.0.2.0: no subnet.
Wrote 0 leases to leases file.
Listening on LPF/tap0/96:ea:ca:e0:76:63/10.0.2.0/24
Sending on   LPF/tap0/96:ea:ca:e0:76:63/10.0.2.0/24
Sending on   Socket/fallback/fallback-net
Server starting service.
DHCPDISCOVER from aa:fc:00:00:00:01 via tap0
DHCPOFFER on 10.0.2.10 to aa:fc:00:00:00:01 via tap0
DHCPREQUEST for 10.0.2.10 (10.0.2.1) from aa:fc:00:00:00:01 via tap0
DHCPACK on 10.0.2.10 to aa:fc:00:00:00:01 (uniboot) via tap0
DHCPREQUEST for 10.0.2.10 from aa:fc:00:00:00:01 (uniboot) via tap0
DHCPACK on 10.0.2.10 to aa:fc:00:00:00:01 (uniboot) via tap0
DHCPREQUEST for 10.0.2.10 from aa:fc:00:00:00:01 (uniboot) via tap0
DHCPACK on 10.0.2.10 to aa:fc:00:00:00:01 (uniboot) via tap0
DHCPREQUEST for 10.0.2.10 from aa:fc:00:00:00:01 (uniboot) via tap0
DHCPACK on 10.0.2.10 to aa:fc:00:00:00:01 (uniboot) via tap0
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

logs.sh:
```
#!/bin/sh

mkfifo log.fifo
mkfifo metrics.fifo

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/logger' \
-H "accept: application/json" \
-H "Content-Type: application/json" \
-d '{ "log_fifo": "log.fifo", "metrics_fifo": "metrics.fifo", "level":
"Info", "show_level": true, "show_log_origin": true }'
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
