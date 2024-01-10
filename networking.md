Networking
==========

Currently, `ops` supports two networking modes; usermode and bridged. In this
document we will dive into the differences between these networking modes and
when it makes sense to select one over the other.

## Native Networking

Note that by default you should probably just use the native networking
provided by your cloud provider. These instructions only exist if you
wish to build your own private cloud.

## Usermode Network
Usermode is the default and simplest mode of networking. It utilizes the ready
available network connection and shares it with the ops instance.

It is worth noting that the simplicity of usermode does come at a performance
cost. Therefore, while usermode is a good option for demos, testing, and local
development; it may not be a good choice for production environments.

No action is required to configure usermode networking, it is used by
default.

Usermode does nat on a port but sometimes you'll want to add dns. This
is fairly straight-forward to do. Again - this is *only* for dev/test
not production deploys:

server:
```go
package main

import (
  "fmt"
  "net/http"
)

func main() {
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Welcome to my website!")
  })

  fs := http.FileServer(http.Dir("static/"))
  http.Handle("/static/", http.StripPrefix("/static/", fs))

  http.ListenAndServe(":8080", nil)
}
```

build/run:
```bash
GO111MODULE=off GOOS=linux go build
ops run -p 8080 g
```

client:
```go
package main

import (
  "fmt"
  "io/ioutil"
  "net/http"
)

func main() {
  resp, err := http.Get("http://bob:8080")
  if err != nil {
    fmt.Println(err)
  }

  body, err := ioutil.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
  }

  fmt.Println(string(body))
}
```

You just need to include a /etc/hosts entry for your client to talk to
10.0.2.2:

Sample config:
```bash
➜  z tree
.
├── config.json
├── etc
│   └── hosts
├── main.go
└── z

➜  z cat etc/hosts
10.0.2.2       bob

ops run -c config.json z
```

## Bridged Network
Bridged networking connects a virtual machine to a network using the host
computer's Ethernet adapter. For more information about bridged networking,
see this [article](https://en.wikipedia.org/wiki/Bridging_%28networking%29).

We only recommend running bridge networking for local dev environments
or environments where you are planning on having full control over
orchestration. We do not recommend running this on the cloud as it'll be
slow. You should instead use the native cloud deploy options (eg: ```ops
instance create -t gcp```) as they will be using bridges underneath.

### Via Instance Create

If you are on a Mac M1, M2 or M3 we recommend grabbing [OPS
desktop](https://storage.googleapis.com/cli/darwin/ops.pkg) as it has
vmnet-bridged support enabled by default and is pre-setup to run
correctly. This way of working with bridges is much nicer too as you
don't have to configure anything. Using this 'ops instance create' for
the on-prem target will use bridge networking by default.

If you want to build yourself you need at least qemu 7.1 or qemu HEAD
from brew. You currently need to be root, or in a proper group or set the suid bit (chmod +s)
to the qemu binary.

On Mac creating a new instance with bridge support is easy as running:

```
ops instance create -p 8080 mywebserver
```

On Linux:

To create a new network and attach a dhcp server to it:

```
ops network create
```

Then you can create a new instance with this sample config:

```
{
    "RunConfig": {
        "Bridged": true,
        "TapName": tap1,
        "BridgeName": br1
    }
}
```

Then you can run it:

```
ops instance create -c myconfig.json mywebserver -p 8080
```

### Via Ops Run

Ops run currently only supports using a bridge on linux - not a mac. If
you are on a mac you should use 'instance create' with the 'onprem'
provider.

Here is a simple Go example demonstrating two applications sitting on
their respective tap interfaces:

```go
package main
import (
  "fmt"
  "io/ioutil"
  "log"
  "net/http"
  "os"
  "time"
)
func main() {
  clientIP := os.Args[1]
  URL := fmt.Sprintf("http://%s/hello", clientIP)
  client := http.Client{
    Timeout: time.Duration(5 * time.Second),
  }
  request, err := http.NewRequest("GET", URL, nil)
  if err != nil {
    log.Fatal(err)
  }
  ticker := time.NewTicker(5 * time.Second)
  quit := make(chan struct{})
  for {
    select {
    case <-ticker.C:
      resp, err := client.Do(request)
      if err != nil {
        fmt.Println(err)
      } else {
        defer resp.Body.Close()
        body, err := ioutil.ReadAll(resp.Body)
        if err != nil {
          fmt.Println(err)
        } else {
          fmt.Print(string(body))
        }
      }
    case <-quit:
      ticker.Stop()
      return
    }
  }
}
```

```go
package main
import (
  "fmt"
  "net/http"
)
func main() {
  hello := func(w http.ResponseWriter, req *http.Request) {
    fmt.Fprintf(w, "hello test 2\n")
  }
  headers := func(w http.ResponseWriter, req *http.Request) {
    for name, headers := range req.Header {
      for _, h := range headers {
        fmt.Fprintf(w, "%v: %v\n", name, h)
      }
    }
  }
  http.HandleFunc("/hello", hello)
  http.HandleFunc("/headers", headers)
  http.ListenAndServe(":8081", nil)
}
```

You'll either need the appropriate permissions or you can just give
yourself sudo then you can run:

```sh
ops run server -p 8081 -b -t tap0 --ip-address 192.168.42.19
ops run client -a 192.168.42.19:8081 -b -t tap1 --ip-address 192.168.42.20
```

Note: On the mac for 'ops run', you won't be able to use this syntax as there is no actual
ethernet card (for most laptops).

## IPv6

IPv6 support varies from cloud to cloud. Please consult the individual
instructions found for each cloud:

[Google Cloud](google_cloud.md)
[AWS](aws.md)
[Azure](azure.md)
