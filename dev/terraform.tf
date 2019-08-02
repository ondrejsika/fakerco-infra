variable "cloudflare_dev_email" {}
variable "cloudflare_dev_token" {}
variable "digitalocean_dev_token" {}


provider "cloudflare" {
  email = "${var.cloudflare_dev_email}"
  token = "${var.cloudflare_dev_token}"
}


provider "digitalocean" {
  token = "${var.digitalocean_dev_token}"
}


resource "digitalocean_ssh_key" "ondrejsika" {
  name       = "ondrejsika"
  public_key = "${file("../ssh/ondrejsika.pub")}"
}


resource "digitalocean_droplet" "runner" {
  image  = "docker-18-04"
  name   = "runner"
  region = "fra1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
    digitalocean_ssh_key.ondrejsika.id
  ]
}

resource "cloudflare_record" "runner" {
  domain = "fakerdev.cz"
  name   = "runner"
  value  = "${digitalocean_droplet.runner.ipv4_address}"
  type   = "A"
  proxied = false
}


resource "digitalocean_droplet" "web1" {
  image  = "docker-18-04"
  name   = "prod"
  region = "fra1"
  size   = "s-2vcpu-4gb"
  ssh_keys = [
    digitalocean_ssh_key.ondrejsika.id
  ]
}

resource "cloudflare_record" "web1" {
  domain = "fakerdev.cz"
  name   = "web1"
  value  = "${digitalocean_droplet.web1.ipv4_address}"
  type   = "A"
  proxied = false
}

resource "cloudflare_record" "web1_wildcard" {
  domain = "fakerdev.cz"
  name   = "*.web1"
  value  = "web1.fakerdev.cz"
  type   = "CNAME"
  proxied = false
}
