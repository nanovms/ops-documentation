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

###  Stats

The onprem target is currently the only target that allows you to get
'stats' (for now in the form of guest memory utilization).

To get all the stats for all instances:

```sh
$ ops instance stats
```

To get the stats for just one instance:

```sh
$ ops instance stats - <instance_name>
```

## Volume Operations

### Create Volume

### List Volumes

### Delete Volume

### Attach Volume

To dynamically attach/detach volumes at run-time for the onprem target
you must be using QMP.

```
{
    "RunConfig": {
        "QMP": true
    }
}
```

### Detach Volume

To dynamically attach/detach volumes at run-time for the onprem target
you must be using QMP.

```
{
    "RunConfig": {
        "QMP": true
    }
}
```


Typically one invokes OPS for single commands and is scriptable and
callable from other libraries/projects however a daemon does exist in
daemon/ that can be built so that you can run OPS as a daemon that
serves up JSON and GRPC.

To build the daemon you'll need to have a handful of protobufs
dependencies installed:

```
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/bufbuild/buf/cmd/buf@latest

wget https://github.com/bufbuild/buf/releases/download/v1.13.1/buf-Linux-x86_64 && sudo mv buf-Linux-x86_64 /usr/bin/buf && sudo chmod +x /usr/bin/buf
wget https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v2.15.0/protoc-gen-openapiv2-v2.15.0-linux-x86_64 -o ~/go/bin/protoc-gen-openapiv2 && chmod +x ~/go/bin/protoc-gen-openapiv2
wget https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v2.15.0/protoc-gen-grpc-gateway-v2.15.0-linux-x86_64 -o ~/go/bin/protoc-gen-grpc-gateway && chmod +x ~/go/bin/protoc-gen-grpc-gateway
```

Then you can run 'make generate' which generates the protobufs.
