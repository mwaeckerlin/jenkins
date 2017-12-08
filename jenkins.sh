#!/bin/bash -e

export MORE_JAVA_ARGS=${JAVA_ARGS}
export MORE_JENKINS_ARGS=${JENKINS_ARGS}
export TERMINAL=dumb
export ANDROID_HOME="${ANDROID_HOME}"
. /etc/default/jenkins
export JENKINS_HOME
${JAVA:-java} -jar ${JAVA_ARGS} ${MORE_JAVA_ARGS} -Dfile.encoding=UTF-8 \
              ${JENKINS_WAR} ${JENKINS_ARGS} ${MORE_JENKINS_ARGS}
