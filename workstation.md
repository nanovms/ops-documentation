VMWare Workstation
========================

These are notes from a user about working with VMWare Workstation:

1) Create a raw disk image following the instructions in the Bare Metal
guide for ops. I've tested a few options including using DHCP and a
static IP and they seem to work fine. I also did my testing with VMWare
Workstation 15, and ESXi 6.7

2) Convert the raw image created by ops using qemu-img convert. The command
I used was qemu-img convert -f raw -O vmdk old.img new.vmdk

3) In VMWare Workstation Create a new VM, by going to File-> New Virtual
Machine

4) In the popup window Click "Custom (advanced)" before clicking "Next"

5) Select your hardware compatibility. If you plan on running it on
Workstation, you can leave it set to the default. For me that was
Workstation 15.X. If you plan on uploading it to ESXi select an ESXi
version from the dropdown (this can be changed at a later point) and
click "Next"

6) On the next page select "I will install the operating system later" and
click "Next"

7) On the next screen it asks what the Guest operating system is. I
selected Other, and Other. It's possible there are other combinations,
like Linux that might work fine here.

8) Continue through the next several screens selecting the options that are
most appropriate for your nanos image, name, cores, ram, etc.) until you
get to the "Select a Disk" screen.

9) Select the option for "Use an existing disk", click next, and browse to
find the vmdk you created using qemu-img convert. When you click "Next"
you may get asked if you want "Convert existing virtual disk to newer
format" In my testing so far, you have to select "Convert" in order for
it to work properly, but I have not dug to deep to see if you could keep
the format and still have it working.

10) After it converts click finish, before running the VM, open up the VMs
".vmx" file Look for a line starting with ethernet0.virtualDev and make
sure it is set to = "vmxnet3". It's possible this line won't exist and
needs to be added (as was the case in my testing)

11) Boot your nanos vm and it should work.
