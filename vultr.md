# Vultr Integration

OPS works perfectly fine with Vultr.

For most operations you'll want to use the following config and you'll
need access to your API key and the access key and secret access key
found in your portal:

```json
{
  "CloudConfig": {
    "Zone": "ewr1",
    "BucketName": "nanos-test"
  }
}
```

```sh
package main

import (
  "fmt"
  "net/http"
)

func main() {
  fmt.Println("hello world!")

  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Welcome to my website!")
  })

  fs := http.FileServer(http.Dir("static/"))
  http.Handle("/static/", http.StripPrefix("/static/", fs))

  http.ListenAndServe("0.0.0.0:8080", nil)
}
```

## Image Operations

### Create Image

```sh
VULTR_TOKEN=my_api_token \
VULTR_ACCESS=my_access_token \
VULTR_SECRET=my_vultr_secret \
ops image create <elf_file|program> -i <image_name> -c config.json -z ewr1 -t vultr
```

### List Images

```sh
VULTR_TOKEN=my_api_token \
VULTR_ACCESS=my_access_token \
VULTR_SECRET=my_vultr_secret \
ops image list -z ewr1 -t vultr
```

### Delete Image

## Instance Operations

### Create Instance

```sh
VULTR_TOKEN=my_api_token \
VULTR_ACCESS=my_access_token \
VULTR_SECRET=my_vultr_secret \
ops instance create 6f5e4eebdf761 -z ewr1 -t vultr
```

### List Instances

```sh
VULTR_TOKEN=my_api_token \
VULTR_ACCESS=my_access_token \
VULTR_SECRET=my_vultr_secret \
ops instance list -z ewr1 -t vultr
```

### Get Logs for Instance

### Delete Instance
