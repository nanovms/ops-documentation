GPU
=======

Nanos is the only unikernel with native GPU support. This is sometimes
necessary for blockchain or AI based workloads. The GPU support targets
most common cloud and consumer Nvidia based GPUs.

On the cloud you can specify the number and GPU type via:

```
{
    "RunConfig": {
        "GPUs": 1,
        "GPUType": "nvidia-tesla-t4"
    }
}
```

You must also include the 'gpu_nvidia' klib and include the Nvidia
firwmware:

```
  "Klibs": ["gpu_nvidia"],
  "Dirs": ["nvidia"]
```

Nightly binary builds are built and uploaded to:

[https://storage.googleapis.com/nanos/release/nightly/gpu-nvidia-x86_64.tar.gz](https://storage.googleapis.com/nanos/release/nightly/gpu-nvidia-x86_64.tar.gz)

Note: For companies over 50 employees using for commercial purposes a
paid subscription is required at [https://nanovms.com/services/subscription](https://nanovms.com/services/subscription) for using binary builds NanoVMs builds. If you don't wish to sign up for that you can build the source yourself.

For more information checkout the tutorial at
https://nanovms.com/dev/tutorials/gpu-accelerated-computing-nanos-unikernels
and https://github.com/nanovms/ops/pull/1528 .

## OnPrem Instructions

* VT-d (Intel) or IOMMU (AMD) must be enabled in bios

* Add the proper kernel command line argument:

Intel:
    ```intel_iommu=on iommu=pt```

AMD:
    ```amd_iommu=on iommu=pt```

