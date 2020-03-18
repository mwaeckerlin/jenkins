FROM mwaeckerlin/dockindock
MAINTAINER mwaeckerlin

ENV JAVA_ARGS "-Xmx4096m"
ENV JENKINS_ARGS ""
ENV MAINTAINER_NAME ""
ENV MAINTAINER_COMMENT ""
ENV MAINTAINER_EMAIL ""
ENV TIMEZONE="Europe/Zurich"
ENV JENKINS_PREFIX /
ENV ADDITIONAL_PACKAGES ""
ENV ANDROID_HOME /android
ENV FIX_ACCESS_RIGHTS 0
ENV BUILD_PACKAGES \
        binfmt-support \
        createrepo \
        curl \
        git \
        gnupg \
        graphviz \
        jenkins \
        npm \
        openjdk-8-jre-headless \
        qemu-user-static \
        reprepro \
        schroot \
        subversion \
        sudo \
        zip
EXPOSE 8080
EXPOSE 50000

ENV CONTAINERNAME="jenkins"
RUN $PKG_INSTALL wget software-properties-common gpg-agent \
 &&  wget -qO- https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - \
 && echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list \
 && apt-get update && apt-get install -y jenkins tzdata ${BUILD_PACKAGES} software-properties-common- \
 && sed -i 's,JENKINS_ARGS="[^"]*,& --prefix=$JENKINS_PREFIX,' /etc/default/jenkins \
 && adduser jenkins docker

VOLUME /var/lib/jenkins
VOLUME /var/log/jenkins
WORKDIR /var/lib/jenkins

ADD start.sh /start.sh
ADD jenkins.sh /jenkins.sh
USER root
