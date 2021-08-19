Images
========================

Images (disk images) are the artifacts produced by OPS. These disk
images can be ran on a variety of hypervisors including the top public
cloud providers such as AWS and Google Cloud.

All local images are stored locally in `~/.ops/images/` and can be viewed
like:

```
$ ops image list -t onprem
```

OPS has several commands that allow one to work on disk images when not
running them. This can help provide debugging support.

### ls

```ops image ls myimage```

Provides a 'ls' style listing of files in image.

### cp

```ops image cp -r redis-server lib .```

Recursively copies the output of the folder '/lib' into the host from
the image 'redis-server'.

### tree

```ops image tree redis-server```

Displays the tree output of the image 'redis-server'.
