#
# VERSION 1.0
#

FROM centos
MAINTAINER kylin "liuzhuan.lz@alibaba-inc.com""

#set aliyum mirrors mirrors.aliyuncs.com
RUN sed -i -e 's/^mirrorlist/#mirrorlist/g' -e 's/^#baseurl=http:\/\/mirror.centos.org/baseurl=http:\/\/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/CentOS-Base.repo

# update
RUN yum -y update

# require packages
RUN yum -y install wget


# Install Oracle jdk8
ENV JAVA_VERSION 8u131
ENV JAVA_BUILD 8u131-b11
ENV JAVA_DL_HASH d54c1d3a095b4ff2b6607d096fa80163

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 http://download.oracle.com/otn-pub/java/jdk/${JAVA_BUILD}/${JAVA_DL_HASH}/jdk-${JAVA_VERSION}-linux-x64.rpm && \
 rpm -Uvh jdk-${JAVA_VERSION}-linux-x64.rpm && \
 rm jdk-${JAVA_VERSION}-linux-x64.rpm

# Timezone
RUN rm -rf /etc/localtime
RUN ln -s ../usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# clean
RUN yum clean all

# set java env
RUN echo "JAVA_HOME=$(rpm -ql $(rpm -qa | grep ^jdk) | grep release | sed 's/\/release//')" > /etc/profile.d/java_env.sh && \
echo "JRE_HOME=\$JAVA_HOME/jre" >> /etc/profile.d/java_env.sh && \
echo "PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin" >> /etc/profile.d/java_env.sh && \
echo "CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar:\$JRE_HOME/lib" >> /etc/profile.d/java_env.sh && \
echo "export JAVA_HOME JRE_HOME PATH CLASSPATH" >> /etc/profile.d/java_env.sh
