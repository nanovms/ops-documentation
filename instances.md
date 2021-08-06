Instances
========================

Instances are virtual machines that are created from disk images.

To list all instances:
```
ops instance list
```

To create a new instance from an existing image:
```
ops instance create -i <name> <image name or ref>
```
For instances run locally; as each instance writes to the same image file, each image can only have a single instance running. Attempting to create a second local instance from an image that already has a local instance will fail. Likewise multiple local instances attempting to use the same network port will also fail.
Instances running on a cloud provider do not have this restriction.

To delete an instance:
```
ops instance delete <name or ref>
```
