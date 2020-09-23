OpenStack Integration
========================

OPS works perfectly fine with OpenStack.

For most operations you'll want to use the following config and you'll
need a handful of env vars.

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

These examples have been tested out on vexxhost.net:

## Image Operations
### Create Image

```sh
#!/bin/sh

export OS_USERNAME=""
export OS_PASSWORD=""
export OS_DOMAIN_NAME="Default"
export OS_AUTH_URL="https://auth.vexxhost.net/"
export OS_REGION_NAME="sjc1"
export OS_PROJECT_NAME=""
export OS_PROJECT_ID=""

GOOS=linux go build -o gtest

ops image create -c config.json -t openstack -a gtest
```

### List Images

```sh
#!/bin/sh

export OS_USERNAME=""
export OS_PASSWORD=""
export OS_DOMAIN_NAME="Default"
export OS_AUTH_URL="https://auth.vexxhost.net/"
export OS_REGION_NAME="sjc1"
export OS_PROJECT_NAME=""
export OS_PROJECT_ID=""

ops image list -t openstack
```

### Delete Image

```sh

#!/bin/sh

export OS_USERNAME=""
export OS_PASSWORD=""
export OS_DOMAIN_NAME="Default"
export OS_AUTH_URL="https://auth.vexxhost.net/"
export OS_REGION_NAME="sjc1"
export OS_PROJECT_NAME=""
export OS_PROJECT_ID=""

ops image delete -t openstack gtest
```

## Instance Operations
### Create Instance

```sh

#!/bin/sh

export OS_USERNAME=""
export OS_PASSWORD=""
export OS_DOMAIN_NAME="Default"
export OS_AUTH_URL="https://auth.vexxhost.net/"
export OS_REGION_NAME="sjc1"
export OS_PROJECT_NAME=""
export OS_PROJECT_ID=""

ops instance create -z us-west2-a -t openstack -i gtest
```

### List Instances

```sh
#!/bin/sh

export OS_USERNAME=""
export OS_PASSWORD=""
export OS_DOMAIN_NAME="Default"
export OS_AUTH_URL="https://auth.vexxhost.net/"
export OS_REGION_NAME="sjc1"
export OS_PROJECT_NAME=""
export OS_PROJECT_ID=""

ops instance list -t openstack -z us-west-2
```

## Get Logs for Instance

### Delete Instance

