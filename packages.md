Packages
========

Packages are officially supported images with pre-compiled languages (ie
nodejs and php) or applications (ie Redis and Nginx). This makes it easier and
more convenient to execute code without needing to compile your own
interpreter(s).

### Listing Packages
To get a list of currently supported packages, run the following command...

```sh
$ ops list
```

The package list can also be searched by simply providing a regular expression
to the `list` command's `--search` option (`-s` for short).

```sh
$ ops list --search ^[lr]

+-------------+---------+----------+-------------+
| PACKAGENAME | VERSION | LANGUAGE | DESCRIPTION |
+-------------+---------+----------+-------------+
| ruby_2.3.1  | 2.3.1   | ruby     | ruby        |
+-------------+---------+----------+-------------+
| lua_5.2.4   | 5.2.4   | lua      | lua         |
+-------------+---------+----------+-------------+
```

### Removing local packages
By default, downloaded packages are stored `~/.ops/bin/.packages`. If you'd
like to remove a package from your hard drive, whether its to conserve space,
or to force a re-download of the package, you can do it here utilizing the
`rm` cli tool.
