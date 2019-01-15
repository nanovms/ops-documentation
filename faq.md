Frequently Asked Questions (FAQ)
================================

### Q: Can I run `ops` inside a container? {#container}
A: Yes, it is possible to run `ops` within a container such as docker.
Although, it is NOT recommended to do so, especially for
production environments. You will likely run into performance related issues.

### Q: How do I run `ops` on a cloud provider with bridged networking?
A: Yes, it is possible to setup bridged networking on various cloud providers.
In order to do so, you need to create a second network interface on the
instance. Use one interface for the network bridge, and the other for your SSH
connection.

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
