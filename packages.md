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
ops load --local mypkg -a b.php -v
```
