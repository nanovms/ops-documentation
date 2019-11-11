Frequently Asked Questions (FAQ)
================================

### Q: What hypervisors does `ops` currently support?
A: Currently, nanos can run on both qemu and xen [QEMU](https://www.qemu.org/).
We are obviously open to adding more
support for other various hypervisors but there are considerations to be
had.

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
A: We do not suggest running ops on a cloud provider on top of linux. We
suggest using the native way of provisioning your unikernels so they run
by themselves standalone and you won't have do any network
configuration.

### Q: My ssh connection gets terminated while running `ops net setup` {#ssh-terminate}
A: This is only necessary if you wish to create your own bridges and
attach tap interfaces to them. It's not a task we suggest most people do
though.

### Q: Does this work with kubernetes?
A: This could work with kubernetes but kubernetes is a container
orchestrator and is typically deployed on top of an existing virtual
machine whereas the intention for these are to run *as* virtual
machines.
