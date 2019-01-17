Frequently Asked Questions (FAQ)
================================

### Q: What hypervisors does `ops` currently support?
A: Currently, the only hypervisor that is supported is
[QEMU](https://www.qemu.org/).

### Q: What artifact does `ops` produce?
A: `ops` builds a disk image artifact that you can typically find (by default)
in the same current working directory after you run an instance, as the
filename "image". This is what is executed by `qemu` to run your code or
application.

### Q: Can I run `ops` inside a container? {#container}
A: Yes, it is possible to run `ops` within a container such as docker.
Although, it is NOT recommended to do so, especially for
production environments. You will likely run into performance related issues.

### Q: What if I need to 'shell out'?
A: We consider this an anti-pattern of software development and a
scourge on the software ecosystem. It is advised to utilize your native
language API and libraries to achieve the task instead.

### Q: What about the filesystem?
A: The tool was originally addressed for transient services yet full fs
functionality is on the way.

### Q: How do I run `ops` on a cloud provider with bridged networking?
A: Yes, it is possible to setup bridged networking on various cloud providers,
but it is recommended to run it on a physical linux server with an ethernet
connection.  In order to do so, you need to create a second network interface
on the instance. Use one interface for the network bridge, and the other for
your SSH connection.

##### Google Cloud Additional Interface
[https://cloud.google.com/vpc/docs/create-use-multiple-interfaces](https://cloud.google.com/vpc/docs/create-use-multiple-interfaces)

##### Digital Ocean Additional Interface
[https://www.digitalocean.com/community/questions/more-network-interfaces-for-droplet](https://www.digitalocean.com/community/questions/more-network-interfaces-for-droplet)

##### Amazon AWS EC2 Additional Interface
[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html)

### Q: My ssh connection gets terminated while running `ops net setup` {#ssh-terminate}
A: This also could happen on a cloud instance (AWS, digital ocean, google
cloud) when there is only a single network interface.

You can bridge on a different interface than the one you are ssh'ing on
to remedy this.
