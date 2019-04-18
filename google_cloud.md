Google Cloud Integration
========================

Ops can integrate with your existing Google Cloud Platform (GCP) account. You can use Ops CLI to create and upload an image in GCP account.
Once, you have upload image, you can also create an instance with a particular image using CLI.

## Pre-requisites

1. Create a Service Account (SA) in your GCP account and download the Service Account key json file.
2. Please make sure your Service Account has access to the Google Compute Engine and Google Storage.
3. Get the name of your Google Cloud account project where you would be creating images and instances.
4. Create a bucket in Google Cloud storage for image artifacts storage.

## Creating Image on Google Cloud

If you have already created an Ops project, you can update your existing `config.json`.
You need to add [CloudConfig](configuration.md#cloudconfig) which mentions specific details like `ProjectID`, `BucketName`.

```json
{
 "CloudConfig" :{
 "ProjectID" :"prod-1000",
 "BucketName":"my-deploy"
 },
 "RunConfig" : {"Memory": "2G"}
}
```

Once, you have updated `config.json` you can create an image in Google Cloud with the following command.

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=~/service-key.json 
$ ops image create -c config.json <image_name>
```

For creating an image using a particular package, you need to provide the package name to `ops image create` command with `-p` option.

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=~/service-key.json 
$ ops image create -c config.json -p node_v11.5.0 -a ex.js
```

## Creating Instance on Google Cloud

After the successful creation of an image in Google Cloud, we can create an instance from an existing image.

```sh
$ GCLOUD_PROJECT=proj-1000
$ export GOOGLE_APPLICATION_CREDENTIALS=~/service-key.json 
$ ops instance new -n $GCLOUD_PROJECT <image_name>
```