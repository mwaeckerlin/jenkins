FROM ubuntu:latest
MAINTAINER mwaeckerlin

ENV MAINTAINER_NAME ""
ENV MAINTAINER_COMMENT ""
ENV MAINTAINER_EMAIL ""
ENV TIMEZONE="Europe/Zurich"
ENV JENKINS_PREFIX /
ENV BUILD_PACKAGES \
                    default-jdk \
                    gnupg \
                    cgroup-lite \
                    lxc-docker \
                    reprepro \
                    schroot \
                    jenkins \
                    graphviz \
                    zip \
                    sudo
ENV ANDROID_HOME /android
ENV LANG en_US.UTF-8
ENV TERM xterm
EXPOSE 8080
EXPOSE 50000

RUN locale-gen ${LANG}
RUN update-locale LANG=${LANG}
RUN apt-get update -y
RUN apt-get install -y lsb-release
RUN lsb_release -a
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

VOLUME /var/lib/jenkins
VOLUME /var/log/jenkins
WORKDIR /var/lib/jenkins

ADD jenkins.sh /var/lib/jenkins/jenkins.sh
ADD start.sh /start.sh
USER root
CMD /start.sh
