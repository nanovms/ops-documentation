Virtual Box Integration
========================

You can use Ops to run your local nanos in Virtual Box. You can use Ops CLI to create a `.vdi` image and launch a virtual machine with the image.

## Pre-requisites

1. Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads) in your machine.
2. Ensure `VBoxManage` is in your shell path.

**Note:** If you are using WSL you may need to create a symlink in Windows filesystem with the name `VBoxManage` pointing to `VBoxManage.exe`.

## Image Operations
### Create Image
You can create an image with the following command.

```sh
$ ops image create <elf_file> -i <image_name> -t vbox
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `--package` option.

```sh
$ ops image create -c config.json --package eyberg/node:20.5.0 -a hi.js -i js -t vbox
```

The Ops CLI will store the image in the directory `vdi-images` inside Ops default directory.

### List Images

You can list existing images with `ops image list -t vbox`.

```sh
$ ops image list -t vbox
+--------------------------------------+------------------------+--------+---------+------------------+
|                 UUID                 |          NAME          | STATUS |  SIZE   |    CREATEDAT     |
+--------------------------------------+------------------------+--------+---------+------------------+
| 01071a8d-eb59-49c1-aa69-028f84cc6d06 | nanos-main-image       | online | 10.0 GB | 3 days ago       |
+--------------------------------------+------------------------+--------+---------+------------------+
| 01c5bd28-aa19-4883-a4c9-31f3ff9fd061 | nanos-node-image       | online | 10.0 GB | 1 month ago      |
+--------------------------------------+------------------------+--------+---------+------------------+
| 01cd3190-df52-47e8-b5c3-b05f7107819e | nanos-server-image     | online | 10.0 GB | 1 year ago       |
+--------------------------------------+------------------------+--------+---------+------------------+
```

### Delete Image

`ops image delete <imagename>` can be used to delete an image.

```
$ ops delete image nanos-main-image -t vbox
```

## Instance Operations
### Create Instance

After creating the image, we can launch a virtual machine from an existing image.
```sh
$ ops instance create <image_name> -t vbox
```

### List Instances

You can list the virtual machines running on Virtual Box using `ops instance list` command.

```sh
$ ops instance list -t vbox
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
|                  ID                  |          NAME          | STATUS  | PRIVATE IPS |               PUBLIC IPS                |
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
| 00d954cc-9603-43a0-915b-5c2ae75772b6 | nanos-main-image-15566 | running | 10.8.3.63   | 209.151.144.166                         |
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
```

### Get Logs for Instance

Work in progress.

### Delete Instance

`ops instance delete` command can be used to delete a virtual machine.

```sh
$ ops instance delete my-instance-running -t vbox
```
