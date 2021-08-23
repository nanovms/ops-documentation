Packages
========

Packages are officially supported images with pre-compiled languages (ie
nodejs and php) or applications (ie Redis and Nginx). This makes it easier and
more convenient to execute code without needing to compile your own
interpreter(s).

### Listing Packages
To get a list of currently supported packages, run the following command...

```sh
$ ops pkg list
```

The package list can also be searched by simply providing a regular expression
to the `list` command's `--search` option (`-s` for short).

```sh
$ ops pkg list --search ^[lr]

+-------------+---------+----------+-------------+
| PACKAGENAME | VERSION | LANGUAGE | DESCRIPTION |
+-------------+---------+----------+-------------+
| ruby_2.3.1  | 2.3.1   | ruby     | ruby        |
+-------------+---------+----------+-------------+
| lua_5.2.4   | 5.2.4   | lua      | lua         |
+-------------+---------+----------+-------------+
```

### Getting package locally
Package can be downloaded to the local cache `~/.ops/packages` using `ops get` command.

```sh
$ ops pkg get <package_name>
```

### Information of Package
Package description provides common assumptions and settings required for running your application
with help of package. You can get package description using `ops pkg describe <package_name>` command.

```sh
$ ops pkg describe nginx_1.15.6
Information for nginx_1.15.6 package:
Sample Readme for Nginx Application
```

### Contents of Package
If you want see contents of a package, you can use `ops pkg contents <package_name>` command.

```sh
$ ops pkg contents perl_5.22.1
File :/package.manifest
File :/perl
Dir :/sysroot
Dir :/sysroot/lib
Dir :/sysroot/lib/x86_64-linux-gnu
File :/sysroot/lib/x86_64-linux-gnu/libc.so.6
File :/sysroot/lib/x86_64-linux-gnu/libcrypt.so.1
File :/sysroot/lib/x86_64-linux-gnu/libdl.so.2
File :/sysroot/lib/x86_64-linux-gnu/libm.so.6
File :/sysroot/lib/x86_64-linux-gnu/libnss_dns.so.2
File :/sysroot/lib/x86_64-linux-gnu/libpthread.so.0
Dir :/sysroot/lib64
File :/sysroot/lib64/ld-linux-x86-64.so.2
```

### Removing local packages
By default, downloaded packages are stored in `~/.ops/bin/.packages`. If you'd
like to remove a package from your hard drive, whether its to conserve space,
or to force a re-download of the package, you can do it here utilizing the
`rm` cli tool.

### Creating a Custom or Local Dev packages

https://github.com/nanovms/ops/blob/master/PACKAGES.md

then copy over an un-tarred dir to ~/.ops/local_packages

Finally you can run it via the local flag:

```
ops pkg load --local mypkg -a b.php -v
```

You can use the --missing-files flag on 'ops run' to hunt down any
missing shared libraries that might not be getting loaded from the ldd
output. For example with ruby:

```
$ ops run --missing-files /usr/local/bin/ruby
booting /home/eyberg/.ops/images/ruby.img ...
en1: assigned 10.0.2.15
`RubyGems' were not loaded.
`did_you_mean' was not loaded.
missing_files_begin
encdb.so
encdb.so.rb
encdb.so.so
ansi_x3_4_1968.so
ansi_x3_4_1968.so.rb
ansi_x3_4_1968.so.so
rubygems.rb
rubygems.so
did_you_mean.rb
did_you_mean.so
missing_files_end
```

You can also turn on '--trace' to find the locations it might be in. A
common idiom would to be run:

```
$ ops run --trace /usr/local/bin/ruby &>/tmp/missing
```

then grep through the output to find loads that failed.

If you wish to create your own local package you can use this as a
template with your program being 'test':

```
➜  test_0.0.1 tree
.
├── package.manifest
├── sysroot
└── test

1 directory, 2 files
```

At a minimum your package.manifest should have the following fields:

```
{
   "Program":"test_0.0.1/test",
   "Args" : ["test"],
   "Version":"0.0.1"
}
```

It is important to note that the Program path should be valid. If you
wish you may also add Language, Runtime, Description into the manifest
so they show up in the search.

These have been traditionally populated from
~/.ops/packages/manifest.json . You may also wish to include a README.md
inside the package.

Then we can directly add the package in question as we develop on it:

```
ops pkg add test_0.0.1 --name test_0.0.1
```

We can finally load the package:

```
ops pkg load -l test_0.0.1
```

### Create a Cloud Image from Local Package

Creating a cloud image from your local package is just like creating it
from a regular package but you pass the '-l' flag in:

```sh
ops image create -c test.json -l --package c2_0.0.1 -t gcp -i mytest2
```

### Create a Package from Docker

You can create a local package from an existing docker container. If the
container does not exist it will download it first and then convert it
into a unikernel. Currently this just grabs the binary and libraries
necessary to run it versus the entire filesystem that might be present.

```sh
$ ops pkg from-docker node:16.3.0 -f node

$ ops pkg load -l node-16.3.0 -a a.js
booting /Users/qtmsheep/.ops/images/program ...
en1: assigned 10.0.2.15
Hello
exit status 1
```
