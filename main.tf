### PROVIDER
provider "google" {
  project = "advancedterraform-445218" #replace this with your project-id
  region  = "us-central1"
  zone    = "us-central1-a"
}

### NETWORK
data "google_compute_network" "default" { # VPC
  name                    = "default"
}

## SUBNET
resource "google_compute_subnetwork" "subnet-1" {
  #create new subnet in VPC default
  name                     = "subnet1"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = data.google_compute_network.default.self_link
  region                   = "us-central1"
  private_ip_google_access = true
}

resource "google_compute_firewall" "default" {
  #firewall rule
  name    = "test-firewall"
  network = data.google_compute_network.default.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000", "22"] # open port 80 = HTTP
  }

  source_tags = ["web"]
}

### COMPUTE ENGINE VM
## NGINX PROXY
resource "google_compute_instance" "nginx_instance" {
  name         = "nginx-proxy"
  machine_type = "f1-micro"
  tags = ["web"]
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
    access_config {
      
    }
  }
}

## WEB1 (web server)
resource "google_compute_instance" "web1" {
  name         = "web1"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
  }
}
## WEB2 (web server)
resource "google_compute_instance" "web2" {
  name         = "web2"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
  }
}
## WEB3 (web server)
resource "google_compute_instance" "web3" {
  name         = "web3"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
  }  
}

## DB (mysql)
resource "google_compute_instance" "mysqldb" {
  name         = "mysqldb"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
  }  
}