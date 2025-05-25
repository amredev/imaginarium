target "docker-metadata-action" {}

target "devcontainer-base" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "devcontainer-base/Dockerfile"
}

target "devcontainer-decondenser" {
  inherits = ["devcontainer-base"]
  context = "."
  dockerfile = "devcontainer-decondenser/Dockerfile"
}
