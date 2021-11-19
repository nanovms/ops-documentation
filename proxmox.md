# Proxmox Integration

OPS works perfectly fine with Proxmox.

You'll want to create an API token on the datacenter in the proxmox UI.

You'll also want to ensure you have the correct permissions for that
user's token on both the datacenter and storage for the operations you'd like to
perform.

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
export API_URL="https://172.16.41.133:8006"
export TOKEN_ID="myuser@pam!tokenid"
export SECRET="some-uuid-goes-here"
ops image create g -t proxmox -c config.json
```

### List Images

```sh
export API_URL="https://172.16.41.133:8006"
export TOKEN_ID="myuser@pam!tokenid"
export SECRET="some-uuid-goes-here"

ops image list -t proxmox
```

### Delete Image

## Instance Operations

### Create Instance

```sh
export API_URL="https://172.16.41.133:8006"
export TOKEN_ID="myuser@pam!tokenid"
export SECRET="some-uuid-goes-here"
ops instance create g.img -t proxmox
```

### List Instances

```sh
export API_URL="https://172.16.41.133:8006"
export TOKEN_ID="myuser@pam!tokenid"
export SECRET="some-uuid-goes-here"
ops instance list -t proxmox
```

### Start Instance

```sh
export API_URL="https://172.16.41.133:8006"
export TOKEN_ID="myuser@pam!tokenid"
export SECRET="some-uuid-goes-here"
ops instance start 100 -t proxmox
```


### Stop Instance

```sh
export API_URL="https://172.16.41.133:8006"
export TOKEN_ID="myuser@pam!tokenid"
export SECRET="some-uuid-goes-here"
ops instance stop 100 -t proxmox
```

### Get Logs for Instance

### Delete Instance
