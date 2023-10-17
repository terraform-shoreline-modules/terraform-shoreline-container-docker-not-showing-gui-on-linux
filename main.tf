terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "gui_not_displaying_in_docker_container_on_linux" {
  source    = "./modules/gui_not_displaying_in_docker_container_on_linux"

  providers = {
    shoreline = shoreline
  }
}