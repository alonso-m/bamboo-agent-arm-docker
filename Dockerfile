FROM ubuntu:18.04

MAINTAINER Bamboo/Atlassian

ENV BAMBOO_VERSION=6.10.4

ENV DOWNLOAD_URL=https://packages.atlassian.com/maven-closedsource-local/com/atlassian/bamboo/atlassian-bamboo-agent-installer/${BAMBOO_VERSION}/atlassian-bamboo-agent-installer-${BAMBOO_VERSION}.jar
ENV BAMBOO_USER=bamboo
ENV BAMBOO_GROUP=bamboo
ENV BAMBOO_USER_HOME=/home/${BAMBOO_USER}
ENV BAMBOO_AGENT_HOME=${BAMBOO_USER_HOME}/bamboo-agent-home
ENV AGENT_JAR=${BAMBOO_USER_HOME}/atlassian-bamboo-agent-installer.jar
ENV SCRIPT_WRAPPER=${BAMBOO_USER_HOME}/runAgent.sh
ENV INIT_BAMBOO_CAPABILITIES=${BAMBOO_USER_HOME}/init-bamboo-capabilities.properties
ENV BAMBOO_CAPABILITIES=${BAMBOO_AGENT_HOME}/bin/bamboo-capabilities.properties
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update -y && \
    apt-get upgrade -y && \
    # please keep Java version in sync with JDK capabilities below
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y curl && \
    apt-get install maven -y && \
    apt-get install git -y && \
    apt-get install jq -y && \
    apt-get install postgresql-10 postgresql-contrib-10 -y

RUN apt-get install apt-transport-https ca-certificates gnupg-agent software-properties-common -y

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get install docker-ce -y

RUN addgroup ${BAMBOO_GROUP} && \
     adduser --home ${BAMBOO_USER_HOME} --ingroup ${BAMBOO_GROUP} --disabled-password ${BAMBOO_USER}

RUN curl -L --output ${AGENT_JAR} ${DOWNLOAD_URL}
COPY bamboo-update-capability.sh  ${BAMBOO_USER_HOME}/bamboo-update-capability.sh 
COPY runAgent.sh ${SCRIPT_WRAPPER} 

RUN chmod +x ${BAMBOO_USER_HOME}/bamboo-update-capability.sh && \
    chmod +x ${SCRIPT_WRAPPER} && \
    mkdir -p ${BAMBOO_USER_HOME}/bamboo-agent-home/bin

RUN chown -R ${BAMBOO_USER} ${BAMBOO_USER_HOME}

USER ${BAMBOO_USER}

RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.jdk.JDK 1.8" /usr/lib/jvm/java-1.8-openjdk/bin/java


WORKDIR ${BAMBOO_USER_HOME}

ENTRYPOINT ["./runAgent.sh"]
