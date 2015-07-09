FROM ubuntu
MAINTAINER mwaeckerlin

ENV JENKINS_PREFIX /
VOLUME /var/lib/jenkins
VOLUME /var/log/jenkins
EXPOSE 8080
EXPOSE 50000

RUN apt-get install -y wget
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update -y
RUN apt-get install -y jenkins
RUN sed -i 's,JENKINS_ARGS="[^"]*,& --prefix=$JENKINS_PREFIX,' /etc/default/jenkins

WORKDIR /var/lib/jenkins
USER jenkins
CMD bash -c '. /etc/default/jenkins && ${JAVA} -jar ${JAVA_ARGS} ${JENKINS_WAR} ${JENKINS_ARGS}'
