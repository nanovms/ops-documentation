Examples
========

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

To learn more about various config options visit [OPS GitHub repository](https://github.com/nanovms/ops). More examples can be found from the [`ops-examples` repository](https://github.com/nanovms/ops-examples).
