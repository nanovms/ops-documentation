# OPS Compose

OPS has 'docker-compose' style functionality where you can orchestrate
locally many unikernels. This allows you to bring up a set of services
together and utilize service discovery. This is currently for macs.

You can either download the official installer from
https://ops.city/downloads with the functionality turned on or you can
enable it manually. We highly recommend using the installer if you can.

If you run into any issue please let us know via the ops github.

If you aren't using the official installer you'll need to do the
following:

First find out which qemu you are using:
```
which qemu-system-x86_64
```

Then using that path (if for instance it is in /usr/local/bin):

```
sudo chown -R root:admin /usr/local/bin/qemu
chmod u+s /usr/local/bin/qemu-system-x86_64
```

This is done in order to utilize bridge networking. There are other ways
of accomplishing this as well.

Next you'll need to enable the OPSD build flag:

```
go build -ldflags "-X github.com/nanovms/ops/qemu.OPSD=true"
```

This is to ensure a seamless experience for those using or not using
this feature.

Now you create a compose.yaml file. For example we have 2 packages in
our local ~/.ops/local_packages/amd64:

```
packages:
  - pkg: myserver
    name: mynewserver_0.0.1
    local: true
  - pkg: myclient
    name: myclient_0.0.1
    local: true
```

If you've used 'ops run' in the past you can create a new pkg using the
same workflow like so:

```
ops pkg from-run client --name myclient --version 0.0.1
```

The 'pkg' itself is what will be used for dns resolution while the name
is pointing towards the package on your local system.

Here is an example where we have used two different packages from the
repo (notice the user namespace) and one package from our local which is
enabled via the 'local' flag.

As with other ops command by default the arch will default to whatever
your underlying platform is but you can set it to what the package is by
setting it different:

```
packages:
  - pkg: graylog
    name: eyberg/graylog:5.2.6
    arch: amd64
  - pkg: mongo
    name: eyberg/mongodb:7.0.8
    arch: amd64
  - pkg: myserver
    name: myserver_0.0.1
    arch: amd64
    local: true
```

Finally you need to have the ops-dns package installed which is a small
dns server that provides service discovery:

```
ops pkg get eyberg/ops-dns:0.0.1
```

Now you can boot your unikernels via:

```
ops compose up
```

You can turn them off via:

```
ops compose down
```

It is important to note that this feature is currently only for Mac. OPS
has had normal bridge support for linux for a while now but allows the
end-user to define that.

### Examples

While you can certainly find compose examples on
[https://repo.ops.city](https://repo.ops.city) we have [compose
examples](https://github.com/nanovms/compose-examples) here.
