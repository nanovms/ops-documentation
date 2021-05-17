Deploy
========================

`Ops` provides a command that allows to quickly update an image and an instance in a cloud provider from an elf file or a package.

The command format is `ops deploy <elf file> -t <cloud provider>`.

Internally, the command executes the next actions.
1. First, deletes an image with the same name of the elf file or the image name specified in configuration;
2. Next, creates an image with the instructions to execute the elf file program or the package program in the cloud provider.
3. Stops and deletes the instances that were launched from an image with the same name.
4. Finally, launches an instance with the image created.

Likewise on instance creation and on image creation, all the properties set in a configuration file are applied in this command.
