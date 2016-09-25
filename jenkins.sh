#!/bin/bash -e

export TERMINAL=dumb
export ANDROID_HOME="${ANDROID_HOME}"
. /etc/default/jenkins
export JENKINS_HOME
${JAVA} -jar ${JAVA_ARGS} -Dfile.encoding=UTF-8 ${JENKINS_WAR} ${JENKINS_ARGS}
