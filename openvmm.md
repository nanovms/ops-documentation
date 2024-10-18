OpenVMM Integration
========================

OPS works well with the OpenVMM VMM from Microsoft.

You'll need to enable uefi for your image:

config.json:

```
{
    "Uefi": true
}
```

You'll need to download the firmware from https://github.com/microsoft/mu_msvm/releases - it's in the 'FV' folder.

If you don't want to build openvmm from source you can grab a binary
from the ci system at
https://github.com/microsoft/openvmm/actions/workflows/openvmm-ci.yaml .

To run:

```
./openvmm --uefi --uefi-firmware MSVM.fd --disk file:/home/myuser/.ops/images/myimage --hv
```
