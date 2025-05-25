variable "version" {
  default = "1"
}

target "devcontainer-base" {
  context = "."
  dockerfile = "devcontainer-base/Dockerfile"
  tags = [
    "amredev/devcontainer-base:latest",
    "amredev/devcontainer-base:${version}"
  ]
}
