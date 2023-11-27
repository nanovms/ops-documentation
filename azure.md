Azure Integration
========================

OPS can run on Microsoft Azure assuming your environment is setup.

## Pre-requisites

1. Create a new resource group.
2. Create a storage account - that is your bucket.
3. You might need to login first.

    ```sh
      az login --scope https://graph.windows.net//.default
    ```

4. Create a quickstart auth:

    ```sh
      az ad sp create-for-rbac --sdk-auth > quickstart.auth
    ```

5. Create a role using the clientID as the assignee inside quickstart.auth:

    ```sh
      az role assignment create --assignee dead-beef-feed-face --role Contributor
    ```

Most of the environment variables you need will be found in this json file.

## Image Operations
### Create Image

If you have already created an Ops project, you can update your existing `config.json`.
You need to add [CloudConfig](configuration.md#cloudconfig) which mentions specific details like `ProjectID`, `BucketName`.

```json
{
  "CloudConfig" :{
    "Zone": "us-west2-a",
    "BucketName":"nanostest"
  }
}
```

Once, you have updated `config.json` you can create an image in Azure with the following command.

```sh
#!/bin/sh

# used for uploading blob
export AZURE_STORAGE_ACCOUNT="nanostest"
export AZURE_STORAGE_ACCESS_KEY=""

# used for create
export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT=""
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""

# used for everything?
export AZURE_BASE_GROUP_NAME="bob"

GOOS=linux go build -o gtest2

ops image create <elf_file|program> -c config.json -t azure -a gtest2
```

### List Images

You can list existing images on Azure with `ops image list`.

```sh
export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT=""
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""
ops image list -t azure
```

### Delete Image

```sh
export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT=""
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""

ops image delete -t azure bob2
```

## Instance Operations
### Create Instance

```sh
export AZURE_STORAGE_ACCOUNT=""

export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT=""
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""

export AZURE_BASE_GROUP_NAME=""

ops instance create bob -z westus2 -t azure
```

#### VPC, Subnet and Security Group

By default, ops creates a VPC, a subnet and a security group per instance.

You can select a different VPC, subnet or security group using the configuration file. The keys to set are `RunConfig.VPC`, `RunConfig.Subnet` and `RunConfig.SecurityGroup`.
```json
{
    "RunConfig":{
        "VPC": "vpc-name",
        "Subnet": "subnet-name",
        "SecurityGroup": "sg-name"
    }
}
```

#### IP Forwarding

By default, IP forwarding is `disabled` on Azure.

If you would like to enable IP forwarding when creating the instance you can use the following:

```json
{
    "RunConfig":{
      "CanIPForward": true
    }
}
```

### List Instances

```sh
export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT=""
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""

export AZURE_BASE_GROUP_NAME=""

ops instance list -t azure -z us-west-2
```

### Get Logs for Instance

You can get logs from serial console of a particular instance using `ops instance logs` command.
The logs are stored in your cloud storage bucket.

```sh
export AZURE_STORAGE_ACCOUNT=""
export AZURE_STORAGE_ACCESS_KEY=""

export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT=""
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""

export AZURE_BASE_GROUP_NAME=""

ops instance logs -t azure gtest2-image -z us-west-2
```

### Delete Instance

## Volume Operations
### Create Volume

Create a small 1mb min. volume locally:
```
ops volume create avol
```

Upload and set the size to 50gb remotely:
```
#!/bin/sh

export AZURE_STORAGE_ACCOUNT=""
export AZURE_STORAGE_ACCESS_KEY=""

export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT="westus2"
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""

export AZURE_BASE_GROUP_NAME=""

ops volume create avol -s 50g -t azure
```

### List Volumes

```
#!/bin/sh

export AZURE_STORAGE_ACCOUNT=""
export AZURE_STORAGE_ACCESS_KEY=""

export AZURE_SUBSCRIPTION_ID=""
export AZURE_LOCATION_DEFAULT="westus2"
export AZURE_TENANT_ID=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""

export AZURE_BASE_GROUP_NAME=""

ops volume list -t azure
```

## Networking Considerations

### IPV6 Networking

IPV6 support differs from cloud to cloud.

You can enable IPV6 on Azure with the following config:

```json
{
  "CloudConfig" :{
    "EnableIPv6": true,
    }
}
```
