# This is set on CI, and it contains the version of the images being released
variable "DOCKER_METADATA_OUTPUT_VERSION" {
  default = ""
}

# This is set on CI and it's filled with the tags and labels that contain the
# version info for the image and other useful metadata.
target "docker-metadata-action" {}

target "devcontainer-base" {
  inherits = [ "docker-metadata-action" ]
  dockerfile = "devcontainer-base/Dockerfile"
}

target "devcontainer-final" {
  inherits = [ "docker-metadata-action" ]
  context = "."
  contexts = {
    # On CI we want to reuse the build of the base image from the registry
    # that was pushed by a separate job. Locally, we can treat the base image
    # as a stage of a multi-stage build.
    "amredev-devcontainer-base" = (
      DOCKER_METADATA_OUTPUT_VERSION == ""
      ? "target:devcontainer-base"
      : "docker-image://ghcr.io/amredev/devcontainer-base:${DOCKER_METADATA_OUTPUT_VERSION}"
    )
  }
}

target "devcontainer-decondenser" {
  inherits = ["devcontainer-final"]
  dockerfile = "devcontainer-decondenser/Dockerfile"
}
