Hardware Acceleration
=====================

Ops can utilize your CPU's virtualization extension through the various
supported hypervisors. Ops will only attempt to enable acceleration on systems
that support it.

If you deploy to Google Cloud or AWS hardware acceleration will always
be enabled however if you are developing locally you'll typically need
to turn it on manually.

Also bear in mind that currently the VDSO is tied to pvclock and that
requires hardware acceleration so you'll get another speed boost from
that as well.

### Linux

To have Ops enable hardware acceleration when running an image, first check to
see if your system's chip has the appropriate support. An easy way to do this on
modern Linux based systems is to run the following command:

```sh
$ grep -woE 'svm|vmx' /proc/cpuinfo | uniq
```

If you have a supported Intel CPU you should see the output `vmx`, for supported
AMD processors you should see `svm`. If your CPU does not support a
virtualization extension you will see no output. If you are certain that your
CPU provides virtualization support and yet you see no output, then please
ensure that the extension is enabled in your BIOS/UEFI system.

If using KVM you need to ensure that your user is a member of the `kvm` group.
Ops will not attempt to enable acceleration if your user is not a member of this
group. First check if your user is apart of the kvm group:

```sh
$ groups
```

If your user is a member of the group you should see `kvm` in the list. If not
already a member you can add yourself to the group with the following command:

```sh
$ usermod -aG kvm `whoami`
```

The change will take effect upon the next login.

You can then verify by issuing the groups command ensuring you are in
the kvm group:

```sh
$ groups
```

Finally, you can check to see
if Ops is using virtualization support by inspecting the command it uses to run
an image. You can do this by enabling verbose output when using the `run` or
`load` commands. So assuming I have hardware acceleration enabled in my runtime
configuration:

```json
{
    "RunConfig": {
        "Accel": true
    }
}
```

Then the following command should indicate that hardware acceleration is being used:

```sh
$ ops run -v hello -c config.json
...
qemu-system-x86_64 -drive file=${HOME}/.ops/images/hello.img,format=raw,if=virtio -device virtio-net,netdev=n0 -netdev user,id=n0 -enable-kvm -nodefaults -no-reboot -device isa-debug-exit -m 2G -display none -serial stdio
...
```

Notice that the Qemu command is generated with `-enable-kvm` option.

Accelaration support can also be enabled by providing the --accel(-x) flag to the ops `run` or `load` commands.

```sh
$ ops run --accel hello  # or ops run -x hello
```

### macOS

For macOS users things are a bit simpler. To check for virtualization support you can use the
sysctl(8) command with the argument `kern.hv_support`:

```sh
$ sysctl kern.hv_support
```

The output will be `kern.hv_support: 1` if support is enabled and
`kern.hv_support: 0` otherwise. Nothing more is needed on macOS, if hardware
support is enabled in your runtime configuration then Ops generated hypervisor
commands should include the appropriate acceleration options.
