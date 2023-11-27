OnPrem
========================

The Onprem target is for users that wish to handle their own
infrastructure. It is also the default target. While 'ops run' and 'ops
pkg load' target the local machine as well the onprem target runs
workloads in the background.

## Pre-requisites

## Image Operations
### Create Image

### List Images

### Delete Image

`ops image delete <imagename>` can be used to delete an image from IBM Cloud.

```
$ ops delete image nanos-main-image -t onprem
```

## Instance Operations
### Create Instance

### List Instances

### Get Logs for Instance

The onprem target is currentlty the only target that allows you to
'tail' serial logs:

```sh
$ ops instance logs --watch my-running-instance
```

### Delete Instance

## Volume Operations

### Create Volume

### List Volumes

### Delete Volume

### Attach Volume

To dynamically attach/detach volumes at run-time for the onprem target
you must be using QMP.

```
"RunConfig": {
    "QMP": true
  },
```

### Detach Volume

To dynamically attach/detach volumes at run-time for the onprem target
you must be using QMP.

```
"RunConfig": {
    "QMP": true
  },
```

