# OPS Documentation
This contains documentation for [OPS](https://github.com/nanovms/ops)

OPS is the command-line interface to [NanoVms](https://nanovms.com/) custom Unikernel.
Most Unikernels out there are specialized for a high-level language, but NanoVms unikernel 
is capable of executing any valid ELF binary. This include ahead of time(AOT) compiled 
languages like golang, rust and C. Interpreted as well as languages that do not directly 
produce an ELF(JIT compiled) can use packages provided by Nanovms. This technical preview 
has packages for PHP and Node and more is on the way.

**IMPORTANT NOTE** This is a technical preview and is actively developed.
It is subject to significant changes and refactoring. Not recommended for 
production environments at this time.

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
