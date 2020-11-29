# Jenkins

Docker Image that runs Jenkins. Specify web prefix with option `-e JENKINS_PREFIX=/jenkins` (defaults to `/`). Specify time zone with `-e TIMEZONE="Europe/Zurich"` (defaults to `Europe/Zurich`). Specify the packages you need for your builds with `-e BUILD_PACKAGES="..."` (defaults, see `DOCKERFILE`). You can use the volume containers from `mwaeckerlin/android` for android builds and from `mwaeckerlin/schroots` for building all kind of Linux packages.

By default, it installs docker in docker, so that you can use the "CloudBees Docker Custom Build Environment Plugin". I recommend not to install more packages, but to use docker for setting up task specific docker container in a clearly defined status.

To run docker images, the image must either be started with option `--privileged` or with `-v /var/run/docker.sock:/var/run/docker.sock`.

Example:

```
docker run --name jenkins \
           -d --restart unless-stopped \
           --privileged \
           -p 8080:8080 \
           -v /var/lib/jenkins:/var/lib/jenkins \
           mwaeckerlin/jenkins
```
