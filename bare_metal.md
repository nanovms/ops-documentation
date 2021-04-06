Bare Metal Integration
========================

Ops can run on bare metal (eg: linux on real hardware) just fine.

## Pre-requisites


## Image Operations
### Build Image

```sh
$ ops build -e PORT=8080 -c config.json mylilwebserver -i mynewimg
```

### List Images

You can list existing images on bare metal with `ops image list`.

```sh
$ ops image list -t onprem
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

## Instance Operations
### Create Instance

```sh
ops instance create <image_name> -t onprem -z onprem -p 8080
```

### List Instances

```sh
ops instance list -t onprem -z onprem
```

## Get Logs for Instance

### Delete Instance

For the time being pids are used as instance ids. Perhaps this will
change in the future if more people opt to use this and they need
stronger prevention of data leakage.

```
ops instance delete 53502 -t onprem -z onprem
```
