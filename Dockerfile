FROM mwaeckerlin/ubuntu-base
MAINTAINER mwaeckerlin

ENV MAINTAINER_NAME ""
ENV MAINTAINER_COMMENT ""
ENV MAINTAINER_EMAIL ""
ENV TIMEZONE="Europe/Zurich"
ENV JENKINS_PREFIX /
ENV ADDITIONAL_PACKAGES ""
ENV ANDROID_HOME /android
ENV FIX_ACCESS_RIGHTS 0
ENV BUILD_PACKAGES \
                    cgroup-lite \
                    createrepo \
                    curl \
                    default-jdk \
                    docker.io \
                    gnupg \
                    graphviz \
                    jenkins \
                    npm \
                    qemu-user \
                    qemu-utils \
                    binfmt-support \
                    reprepro \
                    schroot \
                    subversion \
                    sudo \
                    zip
EXPOSE 8080
EXPOSE 50000

RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-add-repository ppa:cordova-ubuntu/ppa
RUN apt-get update && apt-get install -y jenkins tzdata ${BUILD_PACKAGES}
RUN sed -i 's,JENKINS_ARGS="[^"]*,& --prefix=$JENKINS_PREFIX,' /etc/default/jenkins
RUN adduser jenkins docker

VOLUME /var/lib/jenkins
VOLUME /var/log/jenkins
WORKDIR /var/lib/jenkins

ADD jenkins.sh /jenkins.sh
ADD start.sh /start.sh
USER root
CMD /start.sh
