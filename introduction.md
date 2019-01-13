# Ops Documentation
Documentation for [Nano VMs Ops](https://github.com/nanovms/ops)

Ops is rethinking cloud infrastructure by using unikernals instead of
containerization like docker.

#### What are Unikernels?

Unikernels are specialised, single-address-space machine images constructed by using library operating systems.

Unikernels shrink the attack surface and resource footprint of cloud services. They are built by compiling high-level languages directly into specialised machine images that run directly on a hypervisor, such as Xen, or on bare metal. Since hypervisors power most public cloud computing infrastructure such as Amazon EC2, this lets your services run more cheaply, more securely and with finer control than with a full software stack.

##### Improved security
Unikernels reduce the amount of code deployed, which reduces the attack surface, improving security.

##### Small footprints
Unikernel images are often orders of magnitude smaller than traditional OS deployments.

##### Highly optimised
The unikernel compilation model enables whole-system optimisation across device drivers and application logic.

##### Fast Boot
Unikernels can boot extremely quickly, with boot times measured in milliseconds.

#### How do I get started?
To get started, go to the [getting started](getting_started.md) section.
