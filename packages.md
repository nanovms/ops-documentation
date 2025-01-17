Packages
========

Packages are officially supported images with pre-compiled languages (ie
nodejs and php) or applications (ie Redis and Nginx). This makes it easier and
more convenient to execute code without needing to compile your own
interpreter(s).

You can also create and upload your own public and private packages at
[https://repo.ops.city](https://repo.ops.city) as well.

### Listing Packages
To get a list of currently supported packages, run the following
command:

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

Note: This command will probably go away in the future in favor of
search.

### Getting package locally
Package can be downloaded to the local cache `~/.ops/packages` using `ops get` command.

```sh
$ ops pkg get <package_name>
```

Not sure what the latest package version would be? You can just grab the
latest by substituting the version with the ':latest' tag:

```
 ops pkg load eyberg/redis:latest -p 6379
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

If you want to create a packaeg manually you can follow these
instructions:

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

### Create a New Package from an existing Package

You can use an existing package as a base to create a new package. For
instance if you are deploying a node application you might have
something that looks like this:

```sh
ops pkg load eyberg/node:v18.9.0 -c config.json -p 8080
```

```
{
  "Files": ["hi.js"],
  "Args": ["hi.js"]
}
```

You can create a new package from this config like so:

```sh
ops pkg from-pkg eyberg/node:v18.9.0 -c config.json -n mypkg -v 0.0.1
```

and use it:

```
ops pkg load -l mypkg_0.0.1
```

Then you can upload it to [https://repo.ops.city](https://repo.ops.city):

```
ops pkg push mypkg_0.0.1
```

### Create a Package from Docker

You can create a local package from an existing docker container. If the
container does not exist it will download it first and then convert it
into a unikernel. Currently this just grabs the binary and libraries
necessary to run it versus the entire filesystem that might be present.

```sh
$ ops pkg from-docker node:16.3.0 --file node

$ ops pkg load -l node-16.3.0 -a a.js
booting /Users/qtmsheep/.ops/images/program ...
en1: assigned 10.0.2.15
Hello
exit status 1
```

If you would like to create a package from a local image try this
workflow:

Sample Dockerfile:

```
FROM debian
CMD ["/bin/ls"]
```

Note: Right now the build process is dependent upon a non-scratch
environment, for instance using ldd and cut.

```
docker build -t bob .
```

```
ops pkg from-docker bob -n bob --file ls
ops pkg load --local bob
```

### Create a Package from 'ops run' style

You can create a local package in the same style you use `ops run`

```sh
$ ops run myprogram
```

by using `ops pkg from-run`

```sh
$ ops pkg from-run --name mypackage --version v0.1 myprogram
creating new pkg
$

$ ops pkg list --local
+-----------+-------------+---------+----------+---------+--------------------------------+
| NAMESPACE | PACKAGENAME | VERSION | LANGUAGE | RUNTIME |          DESCRIPTION           |
+-----------+-------------+---------+----------+---------+--------------------------------+
|           | mypackage   | v0.1    |          |         |                                |
+-----------+-------------+---------+----------+---------+--------------------------------+

$ ops pkg load --local mypackage_v0.1
...
```

### Login to the OPS Repo

To upload private and public packages or use your private packages:

You'll need to initially create an account at https://repo.ops.city .
For now it just relies on github auth:

```
ops pkg login <api_key>
```

### Upload a Package

If you have an account from the above step you can login with your
apikey:

```
ops pkg login <api-key>
```

Then, for example, you could create a new node package from docker and
then push it up:

```
ops pkg from-docker node:16.3.0 --file node
ops pkg push node-16.3.0
```

### Search

You can search for a pakage on https://repo.ops.city like so:

```
ops pkg search gatsby
```

Then intention is that this will eventually deprecate 'ops pkg list'.

### Debugging

When working with scripting languages you might run into issues where
they load libraries at run-time that you aren't aware you need. There
are two ways to identify these:

You can turn on --trace with ops to look for it loading libraries:
```
ops run myprogram --trace &>/tmp/out
grep -B 1 "direct return: -" /tmp/out
```

You can use strace and run it normally and look for explicit dlopen
calls:

```
strace myprogram 2>&1 | grep -E '^open(at)?\(.*\.so' > /tmp/dlopen
```

Once you find the missing library you can create the proper directory in
your package and copy it in or put it into a local directory structure
if just using 'ops run'.

Sometimes when building a package you'll need to set some env vars that
are being set via a shell script or some nested scripts. Since Nanos
doesn't run this you'll want to extract them out. Ltrace comes in handy
here and can be ran like so:

```
ltrace -e getenv ./myprogram arg1
```

Sometimes you'll have a binary that was built but not installed on the
local linux system and so is linked to some libraries but they're not
being found.

For instance here we have a binary with some missing libraries, even
though we have them:

```
eyberg@venus:~/kn/knot-dns$ ldd knotd
        linux-vdso.so.1 (0x00007ffdc37d6000)
        libm.so.6 => /usr/lib/x86_64-linux-gnu/libm.so.6 (0x0000749ebf8ee000)
        libknot.so.15 => not found
        libdnssec.so.9 => not found
        libzscanner.so.4 => not found
```

If you don't know where the libraries should be you can patch the binary
using patchelf:

```
patchelf --replace-needed libknot.so.15 ./libknot.so.15 knotd
```

Now you'll see that it is finding it:

```
eyberg@venus:~/kn/knot-dns$ ldd knotd
        linux-vdso.so.1 (0x00007ffe904a4000)
        libm.so.6 => /usr/lib/x86_64-linux-gnu/libm.so.6 (0x00007aae3bb17000)
        ./libknot.so.15 (0x00007aae3bad1000)
```

### Manual Tips:

If you have a large number of libraries to copy you may try something
like this:

```
ldd /usr/bin/php8.2 | awk {'print $3'} | xargs cp -t ~/.ops/packages/amd64/eyberg/wordpress_6.6.1/sysroot/usr/lib/x86_64-linux-gnu/
```

Another useful way of doing this is like so:

```
ldd nntpit | grep usr/lib/x86_64-linux-gnu | awk {'print $3'} | xargs -I {} cp {} sysroot/usr/lib/x86_64-linux-gnu/.
```

Note: You may wish to replace any symlinks with copies of those files
using something like:

```
cp -L /etc/myfolder/symlinks .
```
