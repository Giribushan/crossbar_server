# FROM openjdk:8-jre-alpine3.9
FROM crossbario/crossbar
# ENTRYPOINT [ "/bin/sh -c" ]
# CMD ["crossbar", "start", "--cbdir", "/node/.crossbar", "--loglevel", "debug" ]

# USER crossbar

USER root

RUN apt update
RUN apt -y install wget libasound2 libasound2-data

# JDK - working
# COPY ./jdk-11.0.10_linux-x64_bin.deb /usr/lib/jvm/jdk-11.0.10_linux-x64_bin.deb
# RUN dpkg -i /usr/lib/jvm/jdk-11.0.10_linux-x64_bin.deb
# ENV JAVA_HOME /usr/lib/jvm/jdk-11.0.10/
# RUN export JAVA_HOME
# ENV PATH $JAVA_HOME/bin:$PATH
# RUN whereis java
# RUN java -version

# install JDK headless
# RUN    apt update \
#     && apt install unzip wget openjdk-11-jdk-headless -y \
#     && apt clean \
#     && rm -rf /var/lib/apt/lists/
# RUN whereis java
# RUN java -version

ENV GRADLE_VERSION 6.4.1

#COPY ./gradle-6.4.1-bin.zip /tmp
RUN    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
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

#Android SDK part
# ENV ANDROID_HOME /usr/local/android-sdk-linux
# ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# COPY ./sdk-tools-linux-3859397.zip /tmp

# RUN unzip /tmp/sdk-tools-linux-3859397.zip -d $ANDROID_HOME \
#     && rm /tmp/sdk-tools-linux-3859397.zip

#old one - not working
# RUN /usr/bin/expect -c \
#     "spawn $ANDROID_HOME/tools/bin/sdkmanager \"platforms;android-27\" \"build-tools;27.0.3\"; set timeout -1; expect \"Accept? (y/N): \"; send \"y\r\n\"; expect done;"

#RUN chmod +x /workspace/accept_licences_sdk.sh

# ENV ANDROID_VERSION=29 \
#         ANDROID_BUILD_TOOLS_VERSION=29.0.3
# RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --update
# RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
#     "platforms;android-${ANDROID_VERSION}" \
#     "platform-tools"
# RUN /workspace/accept_licences_sdk.sh
    

# RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common


# ENV JAVA_VER 8
# ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# RUN apt-get update
# RUN apt-get install -y \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg \
#     lsb-release
# RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# RUN echo \
#   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   eoan stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >>  /etc/apt/sources.list && \
#     echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list 
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886


# RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | \
#  tee /etc/apt/sources.list.d/webupd8team-java.list

# RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | \
#  tee -a /etc/apt/sources.list.d/webupd8team-java.list

# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
# RUN apt-get update


# RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
#     echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
# RUN apt-get install -y wget apt-transport-https ca-certificates curl software-properties-common

# RUN deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable

# RUN curl -fsSL http://debian.opennms.org/ | apt-key add -
# RUN echo 'deb http://debian.opennms.org/ opennms-23 main' >> /etc/apt/sources.list && \
#     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
# RUN apt-get update && \
#     echo oracle-java${JAVA_VER}-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
#     apt-get install -y --force-yes --no-install-recommends oracle-java${JAVA_VER}-installer oracle-java${JAVA_VER}-set-default && \
#     apt-get clean && \
#     rm -rf /var/cache/oracle-jdk${JAVA_VER}-installer



# RUN update-java-alternatives -s java-8-oracle

# RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc

# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



# ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# USER crossbar
ENTRYPOINT [ "crossbar" ]
CMD ["start", "--cbdir", "/node/.crossbar", "--loglevel", "debug"]
#CMD ["/bin/sh", "-c", "#(nop) ","ENTRYPOINT [\"crossbar\" \"start\" \"--cbdir\" \"/node/.crossbar\"  \"--loglevel=debug\" ]"]
#CMD ["/bin/sh", "-c", "crossbar start --cbdir /node/.crossbar  --loglevel=debug"]
