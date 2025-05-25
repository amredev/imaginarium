target "docker-metadata-action" {}

target "devcontainer-base" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "devcontainer-base/Dockerfile"
}
