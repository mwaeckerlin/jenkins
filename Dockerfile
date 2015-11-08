FROM ubuntu:wily
MAINTAINER mwaeckerlin

ENV MAINTAINER_NAME ""
ENV MAINTAINER_COMMENT ""
ENV MAINTAINER_EMAIL ""
ENV TIMEZONE="Europe/Zurich"
ENV JENKINS_PREFIX /
ENV BUILD_PACKAGES \
                    automake \
                    autotools-dev \
                    binutils-dev \
                    cordova-cli \
                    curl \
                    debhelper \
                    default-jdk \
                    doxygen \
                    expect \
                    graphviz \
                    lib32gcc1 \
                    lib32ncurses5 \
                    lib32stdc++6 \
                    lib32z1 \
                    libboost-thread-dev \
                    libc6-i386 \
                    libconfuse-dev \
                    libcppunit-dev \
                    libgnutls-dev \
                    libiberty-dev \
                    libmysqlclient-dev \
                    libp11-kit-dev \
                    libpcsclite-dev \
                    libpcscxx-dev \
                    libpkcs11-helper1-dev \
                    libproxy-dev \
                    libqt5svg5-dev \
                    libqt5webkit5-dev \
                    libqt5x11extras5-dev \
                    libqt5xmlpatterns5-dev \
                    libssl-dev \
                    libtool \
                    libxml-cxx-dev \
                    libz-dev \
                    lsb-release \
                    cgroup-lite \
                    lxc-docker \
                    mingw-w64 \
                    mrw-c++-dev \
                    mscgen \
                    openssh-client \
                    pkg-config \
                    proxyface-dev \
                    qt5-default \
                    qtbase5-dev \
                    qtbase5-dev-tools \
                    qttools5-dev \
                    qttools5-dev-tools \
                    quilt \
                    reprepro \
                    schroot \
                    subversion \
                    subversion-tools \
                    sudo \
                    svn2cl \
                    xml2 \
                    xvfb \
                    zip \
                    zlib1g-dev
ENV ANDROID_HOME /android
ENV LANG en_US.UTF-8
EXPOSE 8080
EXPOSE 50000

RUN locale-gen ${LANG}
RUN update-locale LANG=${LANG}
RUN apt-get update -y
RUN apt-get install -y wget software-properties-common apt-transport-https
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN bash -c "wget -O- https://dev.marc.waeckerlin.org/repository/PublicKey | apt-key add -"
RUN apt-add-repository https://dev.marc.waeckerlin.org/repository
RUN apt-add-repository ppa:cordova-ubuntu/ppa
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y jenkins
RUN sed -i 's,JENKINS_ARGS="[^"]*,& --prefix=$JENKINS_PREFIX,' /etc/default/jenkins
RUN apt-get install -y ${BUILD_PACKAGES}
RUN adduser jenkins docker

VOLUME /VOLUME /var/lib/jenkins
VOLUME /var/log/jenkins
WORKDIR /var/lib/jenkins

USER root
CMD if test -e "${ANDROID_HOME}"; then chown -R jenkins.jenkins "${ANDROID_HOME}"; fi && \
    if test -n "${MAINTAINER_NAME}" -a -n "${MAINTAINER_COMMENT}" -a -n "${MAINTAINER_EMAIL}" \
            -a ! -d ~jenkins/.gnupg ; then \
      ( echo "Key-Type: RSA"; \
        echo "Key-Length: 4096"; \
        echo "Subkey-Type: RSA"; \
        echo "Subkey-Length: 4096"; \
        echo "Name-Real: ${MAINTAINER_NAME}"; \
        echo "Name-Comment: ${MAINTAINER_COMMENT}"; \
        echo "Name-Email: ${MAINTAINER_EMAIL}"; \
        echo "Expire-Date: 0"; \
        echo "%echo generating key for ${MAINTAINER_NAME} ..."; \
        echo "%commit"; \
        echo "%echo done."; ) \
      | sudo -Hu jenkins gpg -v -v --gen-key --batch; \
    fi; \
    echo "${TIMEZONE}" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata && \
    if which cgroups-mount 1>&2 > /dev/null && which docker 1>&2 > /dev/null; then \
      cgroups-mount && service docker start; \
    fi; \
    apt-get install -y ${BUILD_PACKAGES} && \
    ( test -f /var/lib/jenkins/.ssh/id_rsa || \
      sudo -EHu jenkins ssh-keygen -b 4096 -N "" -f /var/lib/jenkins/.ssh/id_rsa ) && \
    cat /var/lib/jenkins/.ssh/id_rsa.pub && \
    sudo -EHu jenkins bash -c 'export TERMINAL=dumb; export ANDROID_HOME="'"${ANDROID_HOME}"'"; . /etc/default/jenkins && export JENKINS_HOME && ${JAVA} -jar ${JAVA_ARGS} -Dfile.encoding=UTF-8 ${JENKINS_WAR} ${JENKINS_ARGS}'
