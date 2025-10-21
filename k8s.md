Kubernetes (K8S) Integration
========================

## Security Warning

Running unikernels under kubernetes diminishes some of their security
benefits, however, a lot of organizations still have heavy kubernetes
installations so these are some ways you can still run unikernels in
k8s.

## Pre-requisites

You need access to hardware virtualization. If you are in the cloud the
best way to get that is through [NanoVMs Inception](https://nanovms.com/inception) available on the AWS market.
[https://aws.amazon.com/marketplace/pp/prodview-lwk72eg6wfo3i](https://aws.amazon.com/marketplace/pp/prodview-lwk72eg6wfo3i).
This will allow you to run kube-virt on plain old normal ec2 instances
like an ec2.small without having to resort to expensive metal instances.

If you don't want to do that you'll either need a real physical computer
or use metal instances.

## Installing K8s / Initial Setup

Install KubeCtl:

```
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  mv kubectl /usr/local/bin/.
  sudo mv kubectl /usr/local/bin/.
  kubectl version --client
```

Install Minikube:

```
curl -Lo minikube
https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
&& chmod +x minikube
minikube start --vm-driver=kvm2
```

Install KVM tooling:
```
sudo apt-get install libvirt-daemon-system libvirt-clients bridge-utils
```

Ensure you are setup for KVM via libvirt and have associated
permissions:
```
virt-host-validate
```

```
groups
```

Install KubeVirt:

```
export KUBEVIRT_VERSION=$(curl -s
https://api.github.com/repos/kubevirt/kubevirt/releases | grep tag_name
| grep -v -- - | sort -V | tail -1 | awk -F':' '{print $2}' | sed
's/,//' | xargs)
  echo $KUBEVIRT_VERSION

  kubectl create -f
https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml
```

Create a Resource:

```
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml
```

Install Virtctl:

```
curl -L -o virtctl \
https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/virtctl-${KUBEVIRT_VERSION}-linux-amd64
chmod +x virtctl
```

Import CDI:

```
  wget https://raw.githubusercontent.com/kubevirt/kubevirt.github.io/master/labs/manifests/storage-setup.yml
  kubectl create -f storage-setup.yml
  export VERSION=$(curl -s https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -o "v[0-9]\.[0-9]*\.[0-9]*")
  kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
  kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml
  kubectl get pods -n cdi
```

## Building / Deploying

If you have the base kubernetes installation up and running you can move
on to the final part.

You need to compress the disk image in question to xz format.

```Bash
cp .ops/images/goweb.img .
xz goweb.img
```

Now you need to upload that to a url for k8s to import.

Download a sample PVC template:

```
wget https://raw.githubusercontent.com/kubevirt/kubevirt.github.io/master/labs/manifests/pvc_fedora.yml
```

Edit the line to point to your xz'd image:

```
cdi.kubevirt.io/storage.import.endpoint: "https://storage.googleapis.com/totally-insecure/goweb.img.xz"
```

Import:

```
kubectl create -f pvc_fedora.yml
kubectl get pvc fedora -o yaml
```

Create the Actual VM:

```
wget https://raw.githubusercontent.com/kubevirt/kubevirt.github.io/master/labs/manifests/vm1_pvc.yml
kubectl create -f vm1_pvc.yml
```

If you ```minikube ssh``` you should now be able to hit up your
instance.
