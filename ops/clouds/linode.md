Linode Cloud Integration
========================

OPS has support for creating unikernel images and deploying them as
instances to Linode.

## Pre-requisites

Create a token and export it:

```sh
$ export TOKEN="somethinguniqueandrandom"
```

## Image Operations
### Create Image

```sh
$ ops image create -t linode <program> -c config.json
```

### List Images

You can list existing images on Linode with `ops image list`.

```sh
$ ops image list -t linode
+--------------------+--------+-------------------------------+
|        NAME        | STATUS |            CREATED            |
+--------------------+--------+-------------------------------+
| nanos-main-image   | READY  | 2019-03-21T15:06:17.567-07:00 |
+--------------------+--------+-------------------------------+
| nanos-node-image   | READY  | 2019-04-16T23:16:03.145-07:00 |
+--------------------+--------+-------------------------------+
| nanos-server-image | READY  | 2019-03-21T15:50:04.456-07:00 |
+--------------------+--------+-------------------------------+
```

### Delete Image

`ops image delete <imagename>` can be used to delete an image from Linode.

```
$ ops delete image -t linode nanos-main-image
```

## Instance Operations
### Create Instance

You need to export `TOKEN`.

```sh
$ export TOKEN=<token>
$ ops instance create <image_name> -t linode -c config.json
```

### List Instances

You can list instance on Linode using `ops instance list` command.

You need to export `TOKEN`:

```sh
$ export TOKEN=token
$ ops instance list -t linode
+-----------------------------+---------+-------------------------------+-------------+--------------+
|            NAME             | STATUS  |            CREATED            | PRIVATE IPS |  PUBLIC IPS  |
+-----------------------------+---------+-------------------------------+-------------+--------------+
| nanos-main-image-1556601450 | RUNNING | 2019-04-29T22:17:34.609-07:00 | 10.240.0.40 | 34.83.204.40 |
+-----------------------------+---------+-------------------------------+-------------+--------------+
```

### Get Logs for Instance

### Delete Instance

## Volume Operations
### Create Volume

### List Volumes

### Delete Volume

### Attach Volume

### Detach Volume
