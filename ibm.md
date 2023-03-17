IBM Cloud Integration
========================

Ops can integrate with your existing IBM Cloud Platform (IBM) account. You can use Ops CLI to create and upload an image to your account.
Once, you have uploaded image, you can also create an instance with a particular image using CLI.

## Pre-requisites

Create a token and export it:

```sh
$ export TOKEN="somethinguniqueandrandom"
```

## Image Operations
### Create Image

If you have already created an Ops project, you can update your existing `config.json`.
You need to add [CloudConfig](configuration.md#cloudconfig) which mentions specific details like `ProjectID`, `BucketName`.

```json
{
  "RunConfig": {
    "Ports": ["8080"]
  },
  "CloudConfig" :{
    "Zone": "us-south-2",
    "BucketName":"nanos-test"
  }
}
```

Once, you have updated `config.json` you can create an image in IBM Cloud with the following command.

```sh
$ ops image create -t ibm <program> -c config.json
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ ops image create -c config.json -p node_v14.2.0 -a ex.js -i <image_name> -t ibm
```

### List Images

You can list existing images on IBM cloud with `ops image list`.

```sh
$ ops image list
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

`ops image delete <imagename>` can be used to delete an image from IBM Cloud.

```
$ ops delete image nanos-main-image
```

## Instance Operations
### Create Instance

After the successful creation of an image in IBM Cloud, we can create an instance from an existing image.

You need to export `TOKEN`.

```sh
$ export TOKEN=<token>
$ ops instance create <image_name> -t ibm -c config.json
```

### List Instances

You can list instance on IBM Cloud using `ops instance list` command.

You need to export `TOKEN`:

```sh
$ export TOKEN=token
$ ops instance list
+-----------------------------+---------+-------------------------------+-------------+--------------+
|            NAME             | STATUS  |            CREATED            | PRIVATE IPS |  PUBLIC IPS  |
+-----------------------------+---------+-------------------------------+-------------+--------------+
| nanos-main-image-1556601450 | RUNNING | 2019-04-29T22:17:34.609-07:00 | 10.240.0.40 | 34.83.204.40 |
+-----------------------------+---------+-------------------------------+-------------+--------------+
```

Alternatively you can pass zone with cli options.
```sh
$ ops instance list -t ibm
```

### Get Logs for Instance

### Delete Instance

`ops instance delete` command can be used to delete instance on IBM
Cloud.

You need to export `TOKEN`.

```sh
$ export TOKEN=mytoken
$ ops instance delete my-instance-running
```

Alternatively you can pass zone with cli options.
```sh
$ ops instance delete -z us-south-2 my-instance-running
```

## Volume Operations
### Create Volume

### List Volumes

### Delete Volume

### Attach Volume

### Detach Volume
