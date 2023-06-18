Cloud Hypervisor Integration
============================

OPS works well with [Cloud Hypervisor](https://www.cloudhypervisor.org/) starting from [v32.0](https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v32.0).
OPS doesn't currently interact with the _Cloud Hypervisor_ api but can produce disk images for you to use with it.

To run:

You should replace the `kernel.img` file with the location of your kernel
and the `my_img.img` with the unikernel disk image of choice:

```sh
./cloud-hypervisor \
  --cpus "boot=1,max=2" \
  --memory size=256M \
  --rng "src=/dev/urandom" \
  --console off \
  --serial tty \
  --disk path=/Users/bob/.ops/images/my_img.img \
  --kernel /Users/bob/.ops/0.1.45/kernel.img \
  --net tap=tap0,mac=AA:C6:00:00:00:01 \
  --api-socket /tmp/ch-api.socket
```

`Note`: you can use `--serial file=/tmp/ch-serial.log` instead of `--serial tty`

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
DHCPDISCOVER from aa:c6:00:00:00:01 via tap0
DHCPOFFER on 10.0.2.10 to aa:c6:00:00:00:01 via tap0
DHCPREQUEST for 10.0.2.10 (10.0.2.1) from aa:c6:00:00:00:01 via tap0
DHCPACK on 10.0.2.10 to aa:c6:00:00:00:01 (uniboot) via tap0
DHCPREQUEST for 10.0.2.10 from aa:c6:00:00:00:01 (uniboot) via tap0
DHCPACK on 10.0.2.10 to aa:c6:00:00:00:01 (uniboot) via tap0
DHCPREQUEST for 10.0.2.10 from aa:c6:00:00:00:01 (uniboot) via tap0
DHCPACK on 10.0.2.10 to aa:c6:00:00:00:01 (uniboot) via tap0
DHCPREQUEST for 10.0.2.10 from aa:c6:00:00:00:01 (uniboot) via tap0
DHCPACK on 10.0.2.10 to aa:c6:00:00:00:01 (uniboot) via tap0
```

and you should see the unikernel snag an ip:

```
Server started on port 8080
assigned: 10.0.2.10
assigned: 0.0.0.0
```
