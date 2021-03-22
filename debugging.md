Debugging
========================

## Using the GNU Debugger

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Gdb_archer_fish.svg/1200px-Gdb_archer_fish.svg.png" width="50%">

If you think you found a problem in OPS or Nanos first thing is to
verify where the bug lies. Generally, if you turn on the `-d` flag
and study the bottom you can tell if it is in user or kernel:

```
1 general protection fault in user mode, rip 0x13783afe7
```

Clearly in this example we see a GPF in user.

At this moment, we do not have interactive debugging support with ops, but we
plan on integrating it soon. For now if you wish to have symbol access within
your user program the following conditions must be met:

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

## GUI Debugger in VSCode
This part of the debugging guide shows how to use the GNU Debugger (GDB)
in combination with VSCode to get better visualization of the
debugging process. It requires that the
[Native Debug](https://marketplace.visualstudio.com/items?itemName=webfreak.debug)
extension is installed.

### Prerequisite
Launch the application in debug mode with `ops`:

```
$ ops run -d main
booting ~/.ops/images/main.img ...
You have disabled hardware acceleration

Waiting for gdb connection. Connect to qemu through "(gdb) target remote localhost:1234"
See further instructions in https://nanovms.gitbook.io/ops/debugging
```

### Attach the Debugger
1. Click the `Run` icon on the left sidebar (alternatively use `Ctrl+Shift+D`) and then `create a launch.json file`.
2. Select `GDB` as the environment. This will create an autogenerated `launch.json` file.
3. Replace the contents of the `launch.json` file with following:
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug",
            "type": "gdb",
            "request": "attach",
            "executable": "${workspaceFolder}/main",
            "target": "localhost:1234",
            "remote": true,
            "cwd": "${workspaceRoot}",
            "valuesFormatting": "parseText"
        }
    ]
}
```

4. Set a `Breakpoint` in the source file (`main.c`) and start the debugging session from the `Run` on the left sidebar (alternatively use `Ctrl+Shift+D`) and click on the `> Debug` icon.

It is now possible to use the debugging palette to debug the application code.

## Dump

Ops provides a tool that allow you to inspect image crash logs and image manifests.

If the application crashes the unikernel writes the error stack to a log file before exiting. You are able to see the log content if you run the command `dump -l <image_path>`.
```
$ dump -l ~/.ops/main.img
detected filesystem at 0x11600
klog offset: 0x10600
klog size: 4096 bytes
boot id: 0
exit code: 1

en1: assigned 10.0.2.15
2021/03/22 11:35:35 Failed
```

The image manifest has details about the image like:
- files and their paths in the filesystem;
- environment variable values, including nanos base image version used;
- program and arguments to run on initialization;
- static IP, gateway and netmask to configure the network interface;
- etc.
You can look into your image manifest by using the command `dump <image_path>`.
```
$ dump ~/.ops/main.img
detected filesystem at 0xc11600
Label:
UUID: ad63ee2d-58d1-336f-7484-9fc81f3bc835
metadata (
program:/main
arguments:(0:main)
environment:(PWD:/ NANOS_VERSION:0.1.32 USER:root)
children:(
    .:
    proc:(children:(
        .:
        ..:
        self:(mtime:6942441066663300181 atime:6942441066663300181 children:(
            .:
            ..:
            exe:(mtime:6942441066669261459 atime:6942441066669261459 linktarget:/main)
        ))
        sys:(children:(
            .:
            ..:
            kernel:(children:(
                .:
                ..:
                hostname:(extents:(0:(allocated:1 length:1 offset:5668)) filelength:7)
            ))
        ))
    ))
    etc:(children:(
        ssl:(children:(
            .:
            ..:
            certs:(children:(
                ca-certificates.crt:(extents:(0:(allocated:406 length:406 offset:1078)) filelength:207436)
                .:
                ..:
            ))
        ))
        passwd:(extents:(0:(allocated:1 length:1 offset:1485)) filelength:33)
        .:
        ..:
        resolv.conf:(extents:(0:(allocated:1 length:1 offset:1484)) filelength:18)
    ))
    ..:
    lib:(children:(
        .:
        ..:
        x86_64-linux-gnu:(children:(
            libnss_dns.so.2:(extents:(0:(allocated:53 length:53 offset:1025)) filelength:26936)
            .:
            ..:
        ))
    ))
    main:(extents:(0:(allocated:4182 length:4182 offset:1486)) filelength:2140732)
)
booted:)
```
