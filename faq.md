Frequently Asked Questions (FAQ)
================================

### Q: What hypervisors does `ops` currently support?
A: Currently, nanos can run on both qemu and xen [QEMU](https://www.qemu.org/).
We are obviously open to adding more support for other various hypervisors but
there are considerations to be had.

Also - Nanos runs on Google Cloud && AWS.

### Q: What version of qemu is best?
A: We track latest qemu in homebrew as we have found issues before. The
latest qemu release is currently 4.2.X. If you don't have that release
try to install from brew:

```
brew tap nanovms/homebrew-qemu
brew install nanovms/homebrew-qemu/qemu
```

### Q: Can I contribute?
A: Sure! We accept pull requests and if you have prior kernel experience
please get in touch with NanoVMs - they might even want to pay you.

### Q: What artifact does `ops` produce?
A: `ops` builds a disk image artifact that you can find in ~/.ops/images.
. You can get a list of all your images via:

```
ops image list -t onprem
```

This disk image is ran by `qemu` to execute your application.

### Q: Can I run `ops` inside a container? {#container}
A: Yes, it is possible to run `ops` within a container such as docker.
Although, it is NOT recommended to do so, especially for
production environments. You will likely run into performance related issues.

### Q: What if I need to 'shell out'?
A: We consider this an anti-pattern of software development and a
scourge on the software ecosystem. It is advised to utilize your native
language API and libraries to achieve the task instead.

### Q: What about the filesystem?
A: Nanos currently makes use of the TFS filesystem and can run databases
and other things through the POSIX api you all know.

### Q: How do I run `ops` on a cloud provider with bridged networking?
A: We do not suggest running ops on a cloud provider on top of linux. We
suggest using the native way of provisioning your unikernels so they run
by themselves standalone and you won't have do any network
configuration.

Please see the following cloud documentation for whichever cloud
provider you wish to run on:

* [Google Cloud Integration](google_cloud.md)
* [AWS Integration](aws.md)
* [Digital Ocean](digital_ocean.md)
* [Vultr](vultr.md)

### Q: My ssh connection gets terminated while running `ops net setup` {#ssh-terminate}
A: This is only necessary if you wish to create your own bridges and
attach tap interfaces to them. It's not a task we suggest most people do
though.

### Q: Does this work with kubernetes?
A: This can work with kubernetes but kubernetes is a container
orchestrator and is typically deployed on top of an existing virtual
machine whereas the intention for these are to run *as* virtual
machines. Further, kubernetes has very serious security issues that
should be considered such as sharing a kernel amongst multiple tenants.

Please see [the documentation](k8s.md) for running Nanos under
kubernetes.

