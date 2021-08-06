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
Each image can only have a single instance running, attempting to create a second instance from an image that already has an instance will fail.

To delete an instance:
```
ops instance delete <name or ref>
```
