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

Bridged networking should only be used when you want full control over
the networking. Generally speaking this means you are on real hardware,
running linux. If you are deploying to the public cloud you will want to
use ops normally and *NOT* setup this as it'l be slow.

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

It is important to know that on a MAC you typically won't be able to
bridge since you probably don't have an actual ethernet card. There
still are options by using the [virtualbox provider](https://nanovms.gitbook.io/ops/virtual_box). Virtualbox has it's own tap kext driver.

There is now experimental support to run bridged newtorking on Big Sur
and beyond. The [macBridging](https://github.com/nanovms/ops/compare/master...macBridging) branch provides vmnet-bridged support. You can use this if you are using qemu 7.1 or qemu HEAD from brew. You currently need to be root or set the suid bit (chmod +s) to the qemu binary. We haven't enabled it because it requires a special entitlement from Apple.

## IPv6

IPv6 support varies from cloud to cloud. Please consult the individual
instructions found for each cloud:

[Google Cloud](google_cloud.md)
[AWS](aws.md)
