# OPS Documentation
This contains documentation for [OPS](https://github.com/nanovms/ops), a
compilation and orchestration tool for the Nanos unikernel.

Most Unikernels out there are specialized for a high-level language, but Nanos
is capable of executing any valid ELF binary. We provide pre-tested packages for
common linux software including support for interpreted languages to
provide a similar Linux like experience.

This technical preview has packages for [PHP](examples.md),
[Node](examples.md), Ruby, Lua, Perl and more is on the way. Note that
you are not required to used a package. OPS is explicitly built to be
able to run stand-alone static binaries like Go and C as well.

**IMPORTANT NOTE** This is a technical preview and is actively developed and sponsored by [NanoVMs](https://www.nanovms.com). It is subject 
to significant changes and refactoring.

Significant planned upcoming changes include the following categories:

  * libraries
  * security

#### What are Unikernels?

Unikernels are specialised single process operating systems.

Unikernels dramatically shrink the attack surface and resource footprint of cloud services while providing a much better isolation model.
They are machine images that can be run on a hypervisor such as Xen or
KVM. Since hypervisors power all public cloud computing infrastructure such as Amazon EC2 and Google Cloud, this lets your services run cheaper, more securely and with finer control than with a full general purpose operating system such as Linux.

##### Improved security
Unikernels reduce the amount of code deployed, which reduces the attack surface, improving security. They also don't allow you to ssh into them and most importantly they embrace the single process model.

Note: This does have implications for some software. See the [FAQ](faq.md) for more details.

##### Small footprints
Unikernel images are often orders of magnitude smaller than traditional OS deployments. You can create and deploy sub megabyte unikernels depending on what you want/need.

##### Highly optimised
Unikernels can achieve greater performance from their single process
nature and greater pairing with the kernel.

##### Fast Boot
Unikernels can boot extremely quickly, with boot times measured in milliseconds if you are running on servers you control.

#### How do I get started?
To get started, go to the [getting started](getting_started.md) section.
