CrossBuilding
========================

OPS has initial support for cross-building Nanos unikernels on a Mac.
Nanos uses the ELF binary format just like Linux so when building with
OPS on Linux using 'run' or 'instance create' locally libraries are
resolved appropriately and loaded onto the disk image.

For many use-cases this works the same on Mac. For statically linked
builds produced by Go or Rust you won't have any trouble and for simple
projects using official Node, Ruby, Python packages you shouldn't have
any trouble.

However, there are times when you might need a native Linux environment
to build a c library and then load it in a package.

For instance if you wanted to use the redis-fast-driver in NPM, in the
past you might'e spun up a docker container and built it there or spun
up a Linux vm and built it there. This is where the OPS cross-build
environment capability comes into play. It spins up a small linux vm,
executes your build instructions and then allows you to spit out the
artifacts to your host system (MacOS in this case). This allows you to
build native add-ons without resorting to a full-blown Linux vm or
docker (which runs inside of a linux vm regardless).

#### Example

To get started first you need to create an env. This downloads and
instatitates a cross-build environment:

```
$ ops env install
```

Now we'll specify our build steps like so in a build.txt:

```
apt-get install -y nodejs make gcc g++
npm install redis-fast-driver --save
```

We'll also specify a config detailing what we'd like to extract from the
build-environment. In this case the node_modules directory and the node
binary with it's linked libraries:

```
{
  "Dirs": ["node_modules"],
  "Program": "/usr/bin/node"
}
```

Now we build. This runs the commands found in build.txt in the vm and
then copies the artifacts back out to the host:

```
$ ops env build build.txt -c config.json -r .
```

You'll notice you now have all the appropriate files:

```
$ redis-test ls
build.txt     config.json   config_1.json example.js    lib
lib64         node          node_modules  usr
```

```
$ redis-test tree lib*
lib
└── x86_64-linux-gnu
    ├── libc.so.6
    ├── libdl.so.2
    ├── libgcc_s.so.1
    ├── libm.so.6
    ├── libpthread.so.0
    └── libstdc++.so.6
lib64
└── ld-linux-x86-64.so.2

1 directory, 7 files
```

Now we can test with another json for running our custom node build on
Mac:

```
{
  "Dirs": ["node_modules"],
  "Files": ["/lib/x86_64-linux-gnu/libstdc++.so.6", "example.js"],
  "Program": "/usr/bin/node",
  "Args": ["example.js"]
}
```

Now your node example is running as a Nanos unikernel on Mac without a
linux vm involved.

```sh
$  redis-test ops run usr/bin/node -c config_1.json -r .

booting /Users/eyberg/.ops/images/node.img ...
en1: assigned 10.0.2.15
en1: assigned FE80::FC65:67FF:FEF2:F10D
====================================================
Start test: PING command 2500 times
```
