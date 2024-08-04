Examples
========

Check out this [list of examples here](#examples).

## Deploying a Static File Server
Lets start with a basic go static file server, copy-and-paste below to `server.go`:
```golang
package main

import (
    "log"
    "net/http"
)

func main() {
    fs := http.FileServer(http.Dir("static"))
    http.Handle("/", fs)

    log.Println("Listening...on 8080")
    http.ListenAndServe(":8080", nil)
}
```

Now build `server.go`:
```sh
$ GOOS=linux go build server.go
```

Prepare the HTML content:
```sh
$ mkdir static
$ cd static
```

Create `hello.html`:
```html
<!doctype html>
<html>
<head>
<meta charset="utf-8">
    <title>A static page</title>
</head>
<body>
    <h1>Hello from a static page</h1>
</body>
</html>
```

Create a config file named `config.json`:
```json
{
    "Dirs" : ["static"],
    "Files":["/lib/x86_64-linux-gnu/libnss_dns.so.2", "/etc/ssl/certs/ca-certificates.crt"]
}
```

If you are on linux you can use the above example to enable dns/tls, otherwise you can use this for local Mac examples.

**Note:** This is more than likely to change in the very near future.
```json
{
    "Dirs" : ["static"]
}
```

The directory structure should look like below after these steps:
```bash
.
├── config.json
├── server
└── static
    └── hello.html
```

Package and deploy:
```sh
$ ops run -p 8080 -c config.json server
```

Notice that we are using KVM user-mode networking and have to forward host port 8080 to VM.

Curl it:
```bash
curl http://localhost:8080/hello.html
```

To learn more about various config options visit [OPS GitHub repository](https://github.com/nanovms/ops).

### Examples

More examples can be found from the [`ops-examples` repository](https://github.com/nanovms/ops-examples).
- [ada](https://github.com/nanovms/ops-examples/tree/master/ada)
- [austral](https://github.com/nanovms/ops-examples/tree/master/austral)
- [bog](https://github.com/nanovms/ops-examples/tree/master/bog)
- [c](https://github.com/nanovms/ops-examples/tree/master/c)
- [c3](https://github.com/nanovms/ops-examples/tree/master/c3)
- [clojure](https://github.com/nanovms/ops-examples/tree/master/clojure)
- [cpp](https://github.com/nanovms/ops-examples/tree/master/cpp)
- [crystal](https://github.com/nanovms/ops-examples/tree/master/crystal)
- [cyber](https://github.com/nanovms/ops-examples/tree/master/cyber)
- [d](https://github.com/nanovms/ops-examples/tree/master/d)
- [dada](https://github.com/nanovms/ops-examples/tree/master/dada)
- [dotnet](https://github.com/nanovms/ops-examples/tree/master/dotnet)
- [elixir](https://github.com/nanovms/ops-examples/tree/master/elixir)
- [forth](https://github.com/nanovms/ops-examples/tree/master/forth)
- [golang](https://github.com/nanovms/ops-examples/tree/master/golang)
- [hare](https://github.com/nanovms/ops-examples/tree/master/hare)
- [haskell](https://github.com/nanovms/ops-examples/tree/master/haskell)
- [hvm](https://github.com/nanovms/ops-examples/tree/master/hvm)
- [Idris](https://github.com/nanovms/ops-examples/tree/master/Idris)
- [java](https://github.com/nanovms/ops-examples/tree/master/java)
- [javascript](https://github.com/nanovms/ops-examples/tree/master/javascript)
- [kotlin](https://github.com/nanovms/ops-examples/tree/master/kotlin)
- [lua](https://github.com/nanovms/ops-examples/tree/master/lua)
- [nature](https://github.com/nanovms/ops-examples/tree/master/nature)
- [nelua](https://github.com/nanovms/ops-examples/tree/master/nelua)
- [nginx](https://github.com/nanovms/ops-examples/tree/master/nginx)
- [nim](https://github.com/nanovms/ops-examples/tree/master/nim)
- [ocaml](https://github.com/nanovms/ops-examples/tree/master/ocaml)
- [odin](https://github.com/nanovms/ops-examples/tree/master/odin)
- [onyx](https://github.com/nanovms/ops-examples/tree/master/onyx)
- [pascal](https://github.com/nanovms/ops-examples/tree/master/pascal)
- [perl](https://github.com/nanovms/ops-examples/tree/master/perl)
- [php](https://github.com/nanovms/ops-examples/tree/master/php)
- [picat](https://github.com/nanovms/ops-examples/tree/master/picat)
- [polygon](https://github.com/nanovms/ops-examples/tree/master/polygon)
- [pony](https://github.com/nanovms/ops-examples/tree/master/pony)
- [prolog](https://github.com/nanovms/ops-examples/tree/master/prolog)
- [python](https://github.com/nanovms/ops-examples/tree/master/python)
- [raku](https://github.com/nanovms/ops-examples/tree/master/raku)
- [R](https://github.com/nanovms/ops-examples/tree/master/R)
- [ruby](https://github.com/nanovms/ops-examples/tree/master/ruby)
- [rune](https://github.com/nanovms/ops-examples/tree/master/rune)
- [rust](https://github.com/nanovms/ops-examples/tree/master/rust)
- [scala](https://github.com/nanovms/ops-examples/tree/master/scala)
- [scheme](https://github.com/nanovms/ops-examples/tree/master/scheme)
- [spark](https://github.com/nanovms/ops-examples/tree/master/spark)
- [swift](https://github.com/nanovms/ops-examples/tree/master/swift)
- [tarantool](https://github.com/nanovms/ops-examples/tree/master/tarantool)
- [typescript](https://github.com/nanovms/ops-examples/tree/master/typescript)
- [umka](https://github.com/nanovms/ops-examples/tree/master/umka)
- [wasm](https://github.com/nanovms/ops-examples/tree/master/wasm)
- [yaksha](https://github.com/nanovms/ops-examples/tree/master/yaksha)
- [zig](https://github.com/nanovms/ops-examples/tree/master/zig)
