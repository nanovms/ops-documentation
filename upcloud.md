UpCloud Integration
========================

Ops can integrate with your existing UpCloud account. You can use Ops CLI to create and upload an image in UpCloud account.
Once, you have uploaded image, you can also create an instance with a particular image using CLI.

## Pre-requisites

1. Create an UpCloud account ([https://upcloud.com/signup/](https://upcloud.com/signup/)).
2. Set next environment variables.
```
$ export UPCLOUD_USER=<your account username>

$ export UPCLOUD_PASSWORD=<your account password>

$ export UPCLOUD_ZONE=<location of your images and instances>
```

**Note:** Check the available zones in [Upcloud Documentation](https://developers.upcloud.com/1.2/5-zones/).

## Image Operations
### Create Image
You can create an image in UpCloud with the following command.

```sh
$ ops image create <elf_file> -i <image_name> -t upcloud
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ ops image create -c config.json -p node_v14.2.0 -a ex.js -i <image_name> -t upcloud
```

### List Images

You can list existing images on Upcloud with `ops image list -t upcloud`.

```sh
$ ops image list -t upcloud
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

`ops image delete <imagename>` can be used to delete an image from UpCloud.

```
$ ops delete image nanos-main-image -t upcloud
```

## Instance Operations
### Create Instance

After the successful creation of an image in UpCloud, we can create an instance from an existing image.
```
$ ops instance create -t upcloud -i <image_name>
```

### List Instances

You can list instance on UpCloud using `ops instance list` command.

```sh
$ ops instance list -t upcloud
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
|                  ID                  |          NAME          | STATUS  | PRIVATE IPS |               PUBLIC IPS                |
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
| 00d954cc-9603-43a0-915b-5c2ae75772b6 | nanos-main-image-15566 | stopped | 10.8.3.63   | 209.151.144.166                         |
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
```

### Get Logs for Instance

Work in progress.

### Delete Instance

`ops instance delete` command can be used to delete instance on UpCloud.

```sh
$ ops instance delete my-instance-running -t upcloud
```
