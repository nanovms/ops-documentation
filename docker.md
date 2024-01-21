# Docker Integration

It is important to note that docker containers and unikernels are fairly
differernt and are not at all the same thing. Most notably a docker
container typically has a large userland that can run many different
programs whereas a unikernel can only run one. Not only that but a
unikernel is single process (however has support for multi-threading).

In practice this means that sometimes there are tweaks that need to
happen for you to run something as a unikernel vs a container, these
tend to come with substantial security and performance benefits.

Many applications can be imported from docker containers into unikernels
quite easily as shown in:

https://docs.ops.city/ops/packages#create-a-package-from-docker

On can set the arguments for the package that is created from the docker
export as they sometimes will differ from a Dockerfile.

For example to export a nextjs docker container to a unikernel package:

```
ops pkg from-docker njs2 -c -f /usr/local/bin/node -a app/server.js
ops pkg load --local njs --nanos-version=3c1fb76
```
