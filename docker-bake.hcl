target "default" {
  target = "image"
  tags = [
    "bakeme:latest",
  ]
  attest = [
    "type=provenance,mode=max",
    "type=sbom",
  ]
  platforms = [
    "linux/amd64",
    "linux/arm64",
    "linux/riscv64",
  ]
}

target "test" {
  target = "test"
  # Using type=cacheonly ensures that the build output is effectively discarded; 
  # the layers are saved to BuildKit's cache, but Buildx will not attempt to load the 
  # result to the Docker Engine's image store.
  output = ["type=cacheonly"]
}

target "lint" {
  target = "lint"
  output = ["type=cacheonly"]
}

group "validate" {
  targets = ["test", "lint"]
}
  
