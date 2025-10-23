Scaleway Cloud Cloud Integration
========================

Ops can deploy unikernels to Scaleway.

Most operations will require the following env vars to be set:

```
export SCALEWAY_ACCESS_KEY_ID="access-key-id"
export SCALEWAY_SECRET_ACCESS_KEY="secret-access-key"
export SCALEWAY_ORGANIZATION_ID="my-org-id"
```

## Image Operations
### Create Image

If you have already created an Ops project, you can update your existing
`config.json`. Set uefi to true and set your bucket.

```json
{
 "CloudConfig": {
    "BucketName": "nanos-test",
    "Zone": "pl-waw-1"
  }
}
```

Once, you have updated `config.json` you can create an image in Scaleway with the following command.

```sh
$ ops image create -t scaleway -c config.json <program>
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ ops image create -c config.json -p node_v14.2.0 -a ex.js -i <image_name> -t scaleway
```

### List Images

You can list existing images on Scaleway with:

 `ops image list -t scaleway`.

### Delete Image

`ops image delete <imagename>` can be used to delete an image from
Scaleway.

```sh
$ ops delete image nanos-main-image -t scaleway
```

## Instance Operations
### Create Instance

Alternatively, you can pass config, if you have mentioned project-id and zone in project's config.json.

```sh
$ ops instance create -t scaleway -c config.json myprogram -p 8080
```

### List Instances

```
ops instance list -t scaleway -c config.json
```

### Get Logs for Instance

This currently is not supported.

### Delete Instance

`ops instance delete` command can be used to delete instance on Scaleway.
