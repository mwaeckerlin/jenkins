FROM ubuntu
MAINTAINER mwaeckerlin

ENV JENKINS_PREFIX /
ENV BUILD_PACKAGES automake autotools-dev binutils-dev curl debhelper doxygen graphviz libboost-thread-dev libconfuse-dev libcppunit-dev libgnutls-dev libiberty-dev libmysqlclient-dev libp11-kit-dev libpcsclite-dev libpcscxx-dev libpkcs11-helper1-dev libqt5svg5-dev libqt5webkit5-dev libqt5x11extras5-dev libqt5xmlpatterns5-dev libssl-dev libtool libxml-cxx-dev libz-dev lsb-release mingw-w64 mrw-c++-dev mscgen openssh-client pkg-config proxyface-dev qt5-default qtbase5-dev qtbase5-dev-tools qttools5-dev qttools5-dev-tools quilt reprepro schroot subversion subversion-tools xml2 zip zlib1g-dev
EXPOSE 8080
EXPOSE 50000

RUN apt-get install -y wget software-properties-common apt-transport-https
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-add-repository https://dev.marc.waeckerlin.org/repository
RUN wget -O- https://dev.marc.waeckerlin.org/repository/PublicKey | apt-key add -
RUN apt-get update -y
RUN apt-get install -y jenkins
RUN sed -i 's,JENKINS_ARGS="[^"]*,& --prefix=$JENKINS_PREFIX,' /etc/default/jenkins
RUN apt-get install -y ${BUILD_PACKAGES}

VOLUME /var/lib/jenkins
VOLUME /var/log/jenkins
WORKDIR /var/lib/jenkins

USER jenkins
RUN ssh-

USER root
CMD apt-get update && apt-get install -y ${BUILD_PACKAGES} && \
    ( test -f /var/lib/jenkins/.ssh/id_rsa || \
      sudo -EHu jenkins ssh-keygen -b 4096 -N "" -f /var/lib/jenkins/.ssh/id_rsa ) && \
    cat /var/lib/jenkins/.ssh/id_rsa.pub && \
    sudo -EHu jenkins bash -c '. /etc/default/jenkins && export JENKINS_HOME && ${JAVA} -jar ${JAVA_ARGS} ${JENKINS_WAR} ${JENKINS_ARGS}'
