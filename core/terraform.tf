variable "cloudflare_prod_email" {}
variable "cloudflare_prod_token" {}

variable "cloudflare_dev_email" {}
variable "cloudflare_dev_token" {}


provider "cloudflare" {
  alias = "prod"

  email = "${var.cloudflare_prod_email}"
  token = "${var.cloudflare_prod_token}"
}

provider "cloudflare" {
  alias = "dev"

  email = "${var.cloudflare_dev_email}"
  token = "${var.cloudflare_dev_token}"
}

// BEGIN ZONE fakerco.cz

resource "cloudflare_zone" "fakerco_cz" {
  provider = "cloudflare.prod"

  zone = "fakerco.cz"
}

resource "cloudflare_record" "fakerco_cz__mail1_mx" {
  provider = "cloudflare.prod"

  domain = "${cloudflare_zone.fakerco_cz.zone}"
  name    = "@"
  value   = "mail.oxs.cz"
  type    = "MX"
  priority = "99"
}

// END ZONE fakerco.cz

// BEGIN ZONE faker.cz

resource "cloudflare_zone" "faker_cz" {
  provider = "cloudflare.prod"

  zone = "faker.cz"
}

resource "cloudflare_record" "faker_cz__mail1_mx" {
  provider = "cloudflare.prod"

  domain = "${cloudflare_zone.faker_cz.zone}"
  name    = "@"
  value   = "mail.oxs.cz"
  type    = "MX"
  priority = "99"
}

// END ZONE faker.cz
