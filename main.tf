provider "google" {
  credentials = file("~/identity/project-test-fazry-cc4a5f245b69.json")
  project     = "project-test-fazry"
  region      = "asia-southeast1"  # Set the desired region
}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins-server"
  machine_type = "n1-standard-2"  # Set the desired machine type
  zone         = "asia-southeast1-b"  # Set the desired zone
  tags         = ["allow-http"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"  # Set the desired OS image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  # metadata_startup_script = file("~/terraform_demo/ansible-playbook.sh")  # Provide the path to your Ansible playbook script
  metadata_startup_script = file("~/terraform_demo/setup-jenkins.sh")
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "google_compute_firewall" "allow_http"{
  name    = "allow-http-rule"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_tags = ["allow-http"]

  source_ranges = ["0.0.0.0/0"]

  priority = 1000

}

output "public_ip_address" {
  value = google_compute_address.vm_static_ip.address
}