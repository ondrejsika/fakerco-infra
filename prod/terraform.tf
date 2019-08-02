variable "cloudflare_prod_email" {}
variable "cloudflare_prod_token" {}
variable "digitalocean_prod_token" {}


provider "cloudflare" {
  email = "${var.cloudflare_prod_email}"
  token = "${var.cloudflare_prod_token}"
}


provider "digitalocean" {
  token = "${var.digitalocean_prod_token}"
}


resource "digitalocean_ssh_key" "ondrejsika" {
  name       = "ondrejsika"
  public_key = "${file("../ssh/ondrejsika.pub")}"
}


resource "digitalocean_droplet" "gitlab" {
  image  = "gitlab-ee-18-04"
  name   = "gitlab"
  region = "fra1"
  size   = "s-2vcpu-4gb"
  ssh_keys = [
    digitalocean_ssh_key.ondrejsika.id
  ]
}

resource "cloudflare_record" "gitlab" {
  domain = "fakerco.cz"
  name   = "gitlab"
  value  = "${digitalocean_droplet.gitlab.ipv4_address}"
  type   = "A"
  proxied = false
}

resource "cloudflare_record" "registry" {
  domain = "fakerco.cz"
  name   = "registry"
  value  = "gitlab.fakerco.cz"
  type   = "CNAME"
  proxied = false
}

resource "cloudflare_record" "pages" {
  domain = "fakerco.cz"
  name   = "pages"
  value  = "gitlab.fakerco.cz"
  type   = "CNAME"
  proxied = false
}

resource "cloudflare_record" "pages_wildcard" {
  domain = "fakerco.cz"
  name   = "*.pages"
  value  = "gitlab.fakerco.cz"
  type   = "CNAME"
  proxied = false
}
