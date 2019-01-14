Frequently Asked Questions (FAQ)
================================

### Q: My ssh connection gets terminated while running `ops net setup` {#ssh-terminate}
A: This may occur when the machine you are running is using a wireless
internet connection over a wired connection. This also could happen on a cloud
instance (AWS, digital ocean, google cloud) when there is only a single
network interface.

### Q: Can I run `ops` inside a container? {#container}
A: Yes, it is possible to run `ops` within a container such as docker,
virtualbox, etc. Although, it is recommended NOT to do so, especially for
production environments. You will likely run into performance related issues.
