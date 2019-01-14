# OPS Documentation
This contains documentation for [OPS](https://github.com/nanovms/ops)

OPS is rethinking cloud infrastructure through the use of unikernels.

This is a technical preview of what is possible with unikernels and we
have focused on ease of use first. Some goals are farther along than
others.

OPS is under active development by a full time team of kernel engineers.

#### What are Unikernels?

Unikernels are specialised single process operating systems.

Unikernels dramatically shrink the attack surface and resource footprint of cloud services while providing a much better isolation model.
They are machine images that can be ran on a hypervisor such as Xen or
KVM. Since hypervisors power all public cloud computing infrastructure such as Amazon EC2 and Google Cloud, this lets your services run cheaper, more securely and with finer control than with a full general purpose operating system such as Linux.

##### Improved security
Unikernels reduce the amount of code deployed, which reduces the attack surface, improving security. They also don't allow you to ssh into them and most importantly they embrace the single process model.

##### Small footprints
Unikernel images are often orders of magnitude smaller than traditional OS deployments.

##### Highly optimised
Unikernels can achieve greater performance from their single process
nature and greater pairing with the kernel.

##### Fast Boot
Unikernels can boot extremely quickly, with boot times measured in milliseconds if you are running on servers you control.

#### How do I get started?
To get started, go to the [getting started](getting_started.md) section.
