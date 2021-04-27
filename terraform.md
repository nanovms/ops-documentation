Terraform
========================

Terraform is a declarative way of setup your infrastructure, and may be used to deploy nanos instances with [terraform-ops-provider](https://registry.terraform.io/providers/nanovms/ops/latest) on supported cloud providers.

Download and install [terraform](https://www.terraform.io/downloads.html).

## GCP

See below an explanation of the resources needed to upload a nanos image and to launch an instance to google cloud provider. You can see the entire configuration file at the end of this section. All files required to run this example is in [ops terraform plugin repository](https://github.com/nanovms/terraform-provider-ops/tree/master/examples/gcp).

1. Start importing the ops terraform plugin and set your google cloud settings.
```
terraform {
  required_providers {
    ops = {
      source = "nanovms/ops"
    }
  }
}

provider "google" {
  project = "prod-1033"
  region  = "us-west2"
  zone    = "us-west2-a"
}

provider "ops" {

}
```

2. Create an image in your local machine with your application binary file. You have to specify your google cloud account settings in a configuration file and set the target cloud to `gcp`.
```
resource "ops_images" "walk_server_image" {
  name        = "walk-server"
  elf         = "./walk-server"
  config      = "./config.json"
  targetcloud = "gcp"
}
`

3. Upload the nanos image to google storage. The resources below create a bucket in google storage and upload the nanos image.
```
resource "google_storage_bucket" "images_bucket" {
  name          = "terraform-images"
  location      = "us"
  force_destroy = true
}

resource "google_storage_bucket_object" "walk_server_raw_disk" {
  name   = "walk-server.tar.gz"
  source = ops_images.walk_server_image.path
  bucket = google_storage_bucket.images_bucket.name
}
```

4. Use the path of the object uploaded to create the image.
```
resource "google_compute_image" "walk_server_image" {
  name = "walk-server-img"

  raw_disk {
    source = google_storage_bucket_object.walk_server_raw_disk.self_link
  }

  labels = {
    "createdby" = "ops"
  }

}
```

5. Use the image as base to launch an instance. Make sure you add firewall rules to make your application publicly available.
```
resource "google_compute_instance" "walk_server_instance" {
  name         = "walk-server"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = google_compute_image.walk_server_image.self_link
    }
  }

  labels = {
    "createdby" = "ops"
  }

  tags = ["walk-server"]

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_firewall" "walk_server_firewall" {
  name    = "walk-server-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["walk-server"]
}
```

After joining all pieces we get the next terraform configuration file.

```
terraform {
  required_providers {
    ops = {
      source = "nanovms/ops"
    }
  }
}

provider "google" {
  project = "prod-1033"
  region  = "us-west2"
  zone    = "us-west2-a"
}

provider "ops" {

}

resource "ops_images" "walk_server_image" {
  name        = "walk-server"
  elf         = "./walk-server"
  config      = "./config.json"
  targetcloud = "gcp"
}

resource "google_storage_bucket" "images_bucket" {
  name          = "terraform-images"
  location      = "us"
  force_destroy = true
}

resource "google_storage_bucket_object" "walk_server_raw_disk" {
  name   = "walk-server.tar.gz"
  source = ops_images.walk_server_image.path
  bucket = google_storage_bucket.images_bucket.name
}

resource "google_compute_image" "walk_server_image" {
  name = "walk-server-img"

  raw_disk {
    source = google_storage_bucket_object.walk_server_raw_disk.self_link
  }

  labels = {
    "createdby" = "ops"
  }

}

resource "google_compute_instance" "walk_server_instance" {
  name         = "walk-server"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = google_compute_image.walk_server_image.self_link
    }
  }

  labels = {
    "createdby" = "ops"
  }

  tags = ["walk-server"]

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_firewall" "walk_server_firewall" {
  name    = "walk-server-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["walk-server"]
}

output "image_path" {
  value = ops_images.walk_server_image.path
}

output "instance_ip" {
  value = google_compute_instance.walk_server_instance.network_interface[0].access_config[0].nat_ip
}
```

After running this configuration you will see the path where the image file was created locally and the ip address of the launched instance.
