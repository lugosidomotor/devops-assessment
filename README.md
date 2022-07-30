# Proof
![alt text](https://i.imgur.com/rE0yDWf.png)

# Requirements for agent
- kubectl
- helm
- docker

# Devops assessment
Implement a containerized application, Helm chart to deploy the application to a K8s cluster, and a Jenkins pipeline to build and run it.

The application should print a "Hello <USERNAME>!" message to stdout and exit with exit code 0. USERNAME is a value of an environment variable passed to the container from the Docker host.
"Hello World!" string should be default output. The container image should based on an official Alpine, Busybox or Ubuntu image pulled from DockerHub or a private registry if provided.

The Jenkins pipeline should perform following actions:
- checkout container source code repository.
- build container image with the "latest" tag and a tag unique to the build.
- run a container with a value of the USERNAME variable provided via build parameters.
- additionally, if the runDefault parameter of the build is true, run a container without variable USERNAME.
- pipeline should cleanup all temporary resources from the host.
- log of each container should be stored in build artifacts.

Note:
- Assume that any Jenkins agent available to the Jenkins server meets requirements of the pipeline.
- Any pipeline step from the official steps reference can be used.
