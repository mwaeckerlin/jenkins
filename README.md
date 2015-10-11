# jenkins

Docker Image that runs Jenkins. Specify web prefix with option `-e JENKINS_PREFIX=/jenkins` (defaults to `/`). Specify time zone with `-e TIMEZONE="Europe/Zurich"` (defaults to `Europe/Zurich`). Specify the packages you need for your builds with `-e BUILD_PACKAGES="..."` (defaults, see `DOCKERFILE`). You can use the volume containers from `mwaeckerlin/android` for android builds and from `mwaeckerlin/schroots` for building all kind of Linux packages.
