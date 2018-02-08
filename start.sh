#!/bin/bash -e

# add user to group that has access to /var/run/docker.sock
addgroup --gid $(stat -c '%g' /var/run/docker.sock) extdock || true
usermod -a -G $(stat -c '%g' /var/run/docker.sock) jenkins || true

if test "${FIX_ACCESS_RIGHTS}" != 0; then
    echo "**** Fixing Access Rights:"
    chown -R jenkins.jenkins /var/lib/jenkins
    if test -e "${ANDROID_HOME}"; then
        chown -R jenkins.jenkins "${ANDROID_HOME}";
    fi
fi
if test -n "${MAINTAINER_NAME}" -a -n "${MAINTAINER_COMMENT}" -a -n "${MAINTAINER_EMAIL}" -a ! -d /var/lib/jenkins/.gnupg ; then
    echo "**** Generating Key For Maintainer ${MAINTAINER_NAME}:"
    ( echo "Key-Type: RSA"
      echo "Key-Length: 4096"
      echo "Subkey-Type: RSA"
      echo "Subkey-Length: 4096"
      echo "Name-Real: ${MAINTAINER_NAME}"
      echo "Name-Comment: ${MAINTAINER_COMMENT}"
      echo "Name-Email: ${MAINTAINER_EMAIL}"
      echo "Expire-Date: 0"
      echo "%echo generating key for ${MAINTAINER_NAME} ..."
      echo "%commit"
      echo "%echo done." ) \
        | sudo -Hu jenkins gpg -v -v --gen-key --batch
fi
export DEBIAN_FRONTEND=noninteractive
if test -n "${ADDITIONAL_PACKAGES}"; then
    echo "**** Installing Additional Packages:"
    apt-get -y update
    apt-get -y install "${ADDITIONAL_PACKAGES}"
fi
if test "${TIMEZONE}" != "$(</etc/timezone)"; then
    echo "**** Setting Timezone to ${TIMEZONE}:"
    echo "${TIMEZONE}" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
fi
if which cgroups-mount 1>&2 > /dev/null && which docker 1>&2 > /dev/null; then
    echo "**** Enabling Docker in Docker:"
    cgroups-mount && service docker start
fi
test -f /var/lib/jenkins/.ssh/id_rsa || sudo -EHu jenkins ssh-keygen -b 4096 -N "" -f /var/lib/jenkins/.ssh/id_rsa
echo "**** Jenkins' SSH public key (to give jenkins access to other hosts):"
cat /var/lib/jenkins/.ssh/id_rsa.pub
echo "**** Starting Jenkins:"
sudo -EHu jenkins /jenkins.sh
