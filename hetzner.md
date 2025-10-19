Hetzner Cloud Cloud Integration
========================

Ops can deploy unikernels to Hetzner by utilizing a build-server
approach.

Most operations will require the following env vars to be set:

```
export HCLOUD_TOKEN=api-token
export OBJECT_STORAGE_DOMAIN=hel1.your-objectstorage.com
export OBJECT_STORAGE_KEY=storage-pub-key
export OBJECT_STORAGE_SECRET=storage-priv-key
```

## Image Operations
### Create Image

If you have already created an Ops project, you can update your existing
`config.json`. Set uefi to true and set your bucket.

```json
{
 "Uefi": true,
 "CloudConfig": {
    "BucketName": "nanostest"
  }
}
```

Once, you have updated `config.json` you can create an image in Hetzner with the following command.

```sh
$ ops image create -t hetzner -c config.json <program>
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ ops image create -c config.json -p node_v14.2.0 -a ex.js -i <image_name> -t hetzner
```

### List Images

You can list existing images on Hetzner with:

 `ops image list -t hetzner`.

### Delete Image

`ops image delete <imagename>` can be used to delete an image from
Hetzner.

```sh
$ ops delete image nanos-main-image -t hetzner
```

## Instance Operations
### Create Instance

Alternatively, you can pass config, if you have mentioned project-id and zone in project's config.json.

```sh
$ ops instance create -t hetzner -c config.json myprogram -p 8080
```

### List Instances

```
ops instance list -t hetzner -c config.json
```

### Get Logs for Instance

This currently is not supported.

### Delete Instance

`ops instance delete` command can be used to delete instance on Hetzner.
