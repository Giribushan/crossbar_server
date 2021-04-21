# FROM openjdk:8-jre-alpine3.9
FROM crossbario/crossbar

# USER crossbar
USER root

RUN apt update
RUN apt -y install wget libasound2 libasound2-data

# JDK - working
# COPY ./jdk-11.0.10_linux-x64_bin.deb /usr/lib/jvm/jdk-11.0.10_linux-x64_bin.deb
#RUN wget -P /usr/lib/jvm/ --user hertzAI --password hertzAI https://www.mcgroce.com/hertzDrive-v1.0/api/download?fileName=jdk-11.0.10_linux-x64_bin.deb
RUN touch /usr/lib/jvm/jdk-11.0.10_linux-x64_bin.deb
RUN wget --user hertzAI --password hertzAI https://www.mcgroce.com/hertzDrive-v1.0/api/download?fileName=jdk-11.0.10_linux-x64_bin.deb -O /usr/lib/jvm/jdk-11.0.10_linux-x64_bin.deb
RUN dpkg -i /usr/lib/jvm/jdk-11.0.10_linux-x64_bin.deb
ENV JAVA_HOME /usr/lib/jvm/jdk-11.0.10/
RUN export JAVA_HOME
ENV PATH $JAVA_HOME/bin:$PATH
RUN whereis java
RUN java -version




ENV GRADLE_VERSION 6.4.1

#COPY ./gradle-6.4.1-bin.zip /tmp
RUN wget -P /tmp https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip 
RUN mkdir /opt/gradle 

RUN apt update \
    && apt install -y unzip net-tools procps expect vim\
    && apt clean \
    && rm -rf /var/lib/apt/lists/

RUN unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
   && rm /tmp/gradle-${GRADLE_VERSION}-bin.zip

ENV PATH=$PATH:/opt/gradle/gradle-${GRADLE_VERSION}/bin

WORKDIR /workspace

# copy the demo app 
COPY . /workspace
RUN ls -a /workspace

RUN cd /workspace/demo-gallery

# Build the workspace
RUN gradle installDist -PbuildPlatform=netty -PbuildVersion=20.7.1

RUN ls -a /workspace

# USER crossbar
ENTRYPOINT [ "crossbar" ]
CMD ["start", "--cbdir", "/node/.crossbar", "--loglevel", "debug"]
