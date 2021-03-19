OCI Integration
========================

Ops can integrate with your existing Oracle Cloud Infrastructure account. You can use Ops CLI to create and upload an image in OCI account.
Once, you have uploaded image, you can also create an instance with a particular image using CLI.

## Pre-requisites

1. Create an Oracle Cloud Infrastructure account ([https://www.oracle.com/cloud/](https://www.oracle.com/cloud/)).
2. Set up a config file with the required credentials.
    1. Go to `User Settings` page, whose link should be seen after clicking on profile avatar in top navigation bar.
    2. Click on `API Keys` link.
    3. Click on `Add API Key` button. A modal with further instructions will appear.
    4. Download the private key.
    5. Click on `Add` button. You should see a configuration preview in the modal.
    6. Copy configuration preview content to `~/.oci/config` file in your machine. Create the directory `.oci` in your home folder if it does not exist yet.
    7. Update the `key_file` in OCI configuration file with the path of the file you downloaded in step 4.
3. You are now able to use ops commands to interact with your OCI Account


```
# OCI configuration file preview
[DEFAULT]
user=ocid1.user.oc1..<user_ocid>
fingerprint=38:9d:75:00:71:6c:b7:e0:21:d4:08:82:e4:db:bc:a7
tenancy=ocid1.tenancy.oc1..<tenancy_ocid>
region=<region>
key_file=<path to your private keyfile> # TODO
```


## Image Operations
### Create Image
You can create an image in OCI with the following command.

```sh
$ ops image create -a <elf file> -t oci
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ ops image create -c config.json -p node_v14.2.0 -a ex.js -i <image name> -t oci
```

### List Images

You can list existing images on OCI with `ops image list -t oci`.

```sh
$ ops image list -t oci
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

`ops image delete <imagename>` can be used to delete an image from OCI.

```
$ ops delete image nanos-main-image -t oci
```

## Instance Operations
### Create Instance

After the successful creation of an image in OCI, we can create an instance from an existing image.
```
$ ops instance create -t oci -i <image_name>
```

### List Instances

You can list instance on OCI using `ops instance list` command.

```sh
$ ops instance list -t oci
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
|                  ID                  |          NAME          | STATUS  | PRIVATE IPS |               PUBLIC IPS                |
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
| 00d954cc-9603-43a0-915b-5c2ae75772b6 | nanos-main-image-15566 | stopped | 10.8.3.63   | 209.151.144.166                         |
+--------------------------------------+------------------------+---------+-------------+-----------------------------------------+
```

### Get Logs for Instance

Work in progress.

### Delete Instance

`ops instance delete` command can be used to delete instance on OCI.

```sh
$ ops instance delete my-instance-running -t oci
```
