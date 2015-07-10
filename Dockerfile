FROM ubuntu
MAINTAINER mwaeckerlin

ENV JENKINS_PREFIX /
ENV BUILD_PACKAGES schroot autotools-dev binutils-dev debhelper doxygen graphviz libboost-thread-dev libconfuse-dev libcppunit-dev libgnutls-dev libiberty-dev libmysqlclient-dev libp11-kit-dev libpcsclite-dev libpcscxx-dev libpkcs11-helper1-dev libqt4-dev libssl-dev libz-dev lsb-release mrw-c++-dev pkg-config qt4-dev-tools qtbase5-dev qtbase5-dev-tools qttools5-dev quilt zlib1g-dev
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

CMD apt-get install ${BUILD_PACKAGES} && \
    sudo -EHu jenkins bash -c '. /etc/default/jenkins && export JENKINS_HOME && ${JAVA} -jar ${JAVA_ARGS} ${JENKINS_WAR} ${JENKINS_ARGS}'
