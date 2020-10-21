Debugging
========================

If you think you found a problem in OPS or Nanos first thing is to
verify where the bug lies.

Generally if you turn on the '-d' flag and at the bottom you can tell if
it is in user or kernel:

```
1 general protection fault in user mode, rip 0x13783afe7
```

Clearly in this example we see a GPF in user.

Right now we don't have interactive debugging support with ops but we
plan on integrating it soon.

For now if you wish to have symbol access within your user program the
following conditions must be met:

* Ensure your program is statically linked.

* Ensure you have debugging symbols to begin with:

You can do this with c by doing the following:

__Example__

For this example will examine a segfault (that we purposely injected):

```
#include <stdio.h> 
#include <stdlib.h>

void mybad() {
  int x = 1;
  char *stuff = "asdf";

  printf("about to die\n");
  *(int*)0 = 0;
}

int main(void) {
  mybad();
  printf("should not get here\n");

  return 0; 
} 
```

We compile with debugging symbols and link statically:

```
cc main.c -static -g -o main
```

First (since we are missing interactive debug support in ops) you need
to modify ops to manually add the noaslr flag in lepton/image.go:

```
m.AddDebugFlag("noaslr", 't')
```

This is important because otherwise we randomize the location of the
.text and other parts of your program.

Next, we'll run without accel support:

```
ops run --accel=false main
```

Then we let it crash.

Now let's manually start qemu with gdb support:
(Not all of this is necessary but definitely ensure your 'drive file'
line matches where your disk image is)

Also the '-s -S' starts the remote gdb debugger:
```
qemu-system-x86_64 \
-device pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x3 \
-device pcie-root-port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x3.0x1 \
-device pcie-root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x3.0x2 \
-device virtio-scsi-pci,bus=pci.2,addr=0x0,id=scsi0 \
-device scsi-hd,bus=scsi0.0,drive=hd0 -no-reboot -cpu max -machine q35 \
-device isa-debug-exit -m 2G \
-drive file=/home/eyberg/.ops/images/main.img,format=raw,if=none,id=hd0 \
-device virtio-net,bus=pci.3,addr=0x0,netdev=n0 \
-netdev user,id=n0,hostfwd=tcp::8080-:8080,hostfwd=tcp::9090-:9090,hostfwd=udp::5309-:5309 \
-display none -serial stdio -s -S
```

This will pause waiting on a gdb to attach to it.

In another window, we'll launch gdb pointing it at whatever kernel you are using:

```
gdb ~/.ops/0.1.27/kernel.img 
```

We'll connect to qemu by specifying the remote:

```
(gdb) target remote localhost:1234
Remote debugging using localhost:1234
0x000000000000fff0 in ?? ()
```

Great - now we are connected.

Now we load the symbols for our program:

```
(gdb) symbol-file main
Load new symbol table from "main"? (y or n) y
Reading symbols from main...
```

You can see the source now:

```
(gdb) list
1       #include <stdio.h> 
2       #include <stdlib.h>
3
4       void mybad() {
5         int x = 1;
6         char *stuff = "asdf";
7
8         printf("about to die\n");
9        *(int*)0 = 0;
```

Let's set a breakpoint for 'mybad':

```
(gdb) b mybad
Breakpoint 1 at 0x401d35: file main.c, line 4.
```

Now let's continue:

```
(gdb) c
Continuing.

Breakpoint 1, mybad () at main.c:4
4       void mybad() {
```

You should see in your other window (where you started qemu) that the
program starts:

```
assigned: 10.0.2.15
```

Now if we single step through the program we can print out various
locals:

```
4       void mybad() {
(gdb) step
5         int x = 1;
(gdb) step
6         char *stuff = "asdf";
(gdb) step
8         printf("about to die\n");
(gdb) p x
$1 = 1
(gdb) p stuff
$2 = 0x495004 "asdf"
```

This should get you further down the path when you find various bugs in
your program. Hope this helps.

If your program isn't even starting there might be an issue with OPS.

However, if you open an issue in Nanos please provide the following:

Your OPS profile:
```
➜  ~  ops profile
Ops version: 0.1.9
Nanos version: 0.1.25
Qemu version: 4.1.90
Arch: darwin
```

Nightly vs Master?

Does this work on the nightly build? Running '-n' will run ops with
whatever was in the master branch last night.

Reproducible steps
