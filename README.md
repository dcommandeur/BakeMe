# BakeMe - Docker Tutorial

A sample project for demonstrating how to use Docker Buildx Bake.

Docker Buildx is a CLI plugin that extends the capabilities of the Docker CLI to work with BuildKit. BuildKit is a new build subsystem for Docker that provides a modern build features and better performance. Buildx introduces the concept of a builder instance, which is a container running the BuildKit server. This allows you to create multiple builder instances and use them to build images concurrently.

Read the guide here: <https://docs.docker.com/guides/bake/>

# Introduction

In this tutorial, you will learn how to setup Docker Buildx, create a Dockerfile and build a Docker image using Docker Buildx. You will also learn how to use the docker buildx bake command to build Docker images using a build configuration file.

The docker-bake.hcl file defines three targets: default, test, and lint. The default target builds the Docker image, the test target runs the tests and the lint target runs the linter. The group block defines a group of targets that can be run together. 
The default target specifies the following: 

- target : The target to run. 
- tags : The tags to apply to the image. 
- attest : The attestation types to use. 
- platforms : The platforms to build the image for. 

The test and lint targets specify the output as type=cacheonly to discard the build output. 

## Step 3: Build the Docker image 
To build the Docker image, run the following command:

```bash
docker buildx bake

# For contrast, here's what this build command would look like without Bake:

docker buildx build \
 --target=image \
 --tag=bakeme:latest \
 --provenance=true \
 --sbom=true \
 --platform=linux/amd64,linux/arm64,linux/riscv64 \
.
```

The docker buildx bake command builds the Docker image using the docker-bake.hcl file.

## Step 4: Run the tests

You can also use Bake to run your tests, effectively using BuildKit as a task runner.

- Unit testing with go test.
- Linting for style violations with golangci-lint.

For test runs, you don't need to export the build output — only the test execution matters.

To run the tests, run the following command: 

```bash
docker buildx bake test
```

The docker buildx bake test command runs the tests using the test target defined in the docker-bake.hcl file.

## Step 5: Run the linter

To run the linter, run the following command:

```bash
docker buildx bake lint
```

The docker buildx bake lint command runs the linter using the lint target defined in the docker-bake.hcl file.

## Conclusion 

You now have a basic understanding of how to use Docker Buildx with BuildKit to build Docker images.
You learned how to setup Docker Buildx, create a Dockerfile and build a Docker image using the docker buildx build command. You also learned how to use the docker buildx bake command to build Docker images using a build configuration file.

To learn more about Docker Buildx, visit the official documentation <https://docs.docker.com/guides/bake/>.
