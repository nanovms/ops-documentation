# Docker Integration

OPS can export docker containers to unikernel packages:

https://docs.ops.city/ops/packages#create-a-package-from-docker

On can set the arguments for the package that is created from the docker
export as they sometimes will differ from a Dockerfile.

For example to export a nextjs docker container to a unikernel package:

```
ops pkg from-docker njs2 -c -f /usr/local/bin/node -a app/server.js
ops pkg load --local njs --nanos-version=3c1fb76
```
