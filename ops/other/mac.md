MacOS
========================

OPS and Nanos work great on both x86 and arm based macs. This includes
the older x86 models from circa 2014, 2015 up to and including the arm64
m1 and m2s.

We've also added support for [ops desktop](https://ops.city/downloads)
for the m1 and m2 which is a graphical desktop interface.

We have set some (what we think) to be sane defaults.

If on x86 all operations such as 'image create', 'pkg load', 'ops run',
etc default to using x86 Nanos and expect a x86 binary/package.

If on arm64 (m1 and m2) all operations default to using arm64 Nanos and
expect an arm64 binary/package.

You may wish to create and/or run Nanos unikernels on a different
architecture and that is 100% supported. For instance it is common now
to do development on a Mac m2 which is arm64 based but deploy to an
x86-64 server on AWS or GCP.

If we want to build and run an x86 instance on a m2 we would do the
following (for example with go):

```sh
GOARCH=amd64 GOOS=linux go build myapp
ops run --arch=amd64 myapp
```

Or if we wish to crate an image:
```
ops image crate --arch=amd64
```

If you are using an x86 machine and you'd like to run an arm
payload you'd do the following:

```
ops run --arch=arm64 myapp
```

If you wish to use the native architecture you don't need to specify the
arch flag and ops will default to whatever the native arch is.

When enabling a different architecture than the one that is natively
present the underlying qemu binary will also be switched along with many
various flags.

It is important to note that you will get the best performance when
using the native arch. So if you are on arm64 for performance reasons
you'll want to use arm64 images/packages or vice-versa for x86.

We'd like to make this experience super seamless so if you have any
issues don't be shy on opening an issue on the ops repo.
