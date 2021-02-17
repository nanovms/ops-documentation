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
