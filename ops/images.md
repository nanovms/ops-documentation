Images
========================

Images (disk images) are the artifacts produced by OPS. These disk
images can be ran on a variety of hypervisors including the top public
cloud providers such as AWS and Google Cloud.

All local images are stored locally in `~/.ops/images/` and can be viewed
like:

```ops image list -t onprem```

OPS has several commands that allow one to work on disk images when not
running them. This can help provide debugging support.

### ls

```ops image ls myimage```

Provides a 'ls' style listing of files in a local (on-prem) image from **rootfs** partition.

```ops image ls myimage --bootfs```

Provides a 'ls' style listing of files in a local (on-prem) image from **bootfs** partition.

### cat

```ops image cat g /etc/resolv.conf```

Cats the file out of an image.

### cp

```ops image cp -r redis-server lib .```

Recursively copies the output of the folder '/lib' into the host from the image 'redis-server' **rootfs** partition.

```ops image cp redis-server kernel . --bootfs```

Copies the 'kernel' into the host from the image 'redis-server' **bootfs** partition.

```ops image cp -r redis-server klib .```

Recursively copies the output of the folder '/klib' into the host from the image 'redis-server' **bootfs** partition.

### tree

```ops image tree redis-server```

Displays the tree output of local (on-prem) image from **rootfs** partition.

```ops image tree redis-server --bootfs```

Displays the tree output of local (on-prem) image from **bootfs** partition.

### env

```ops image env redis-server```

Displays the list of environment variables found in a local (on-prem) image.

### mirror

```ops image mirror myimage <src_region> <dst_region>```

Copies an image from one region to another. This command is for simple images or images that rely on ext. config stores.
