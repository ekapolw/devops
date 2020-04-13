# Ubuntu 16.04 LTS
# OpenJDK 8
# Maven 3.2.2
# Jenkins latest
# Git
# Nano

# pull base image Ubuntu 16.04 LTS (Xenial)
FROM ubuntu:xenial

MAINTAINER Ekapol W. (ekapolw@gmail.com)

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# install the OpenJDK 8 java runtime environment and curl
RUN apt update; \
  apt upgrade -y; \
  apt install -y openjdk-8-jdk curl wget git nano; \
  apt-get clean

ENV JAVA_HOME /usr
ENV PATH $JAVA_HOME/bin:$PATH

# get maven 3.6.3 and verify its checksum
RUN wget --no-verbose -O /tmp/apache-maven-3.6.3.tar.gz http://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz;

# install maven
RUN tar xzf /tmp/apache-maven-3.6.3.tar.gz -C /opt/; \
  ln -s /opt/apache-maven-3.6.3 /opt/maven; \
  ln -s /opt/maven/bin/mvn /usr/local/bin; \
  rm -f /tmp/apache-maven-3.6.3.tar.gz
ENV MAVEN_HOME /opt/maven

# install docker client
RUN apt update; \
  apt remove docker docker-engine docker.io; \
  apt install docker.io; \
  systemctl start docker; \
  systemctl enable docker

# copy jenkins war file to the container
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080

CMD [""]
