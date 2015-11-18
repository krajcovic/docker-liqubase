FROM krajcovic/centos-base:local

MAINTAINER Dusan Krajcovic

# Variables
#ENV hostname node.base.docker.monetplus.cz
ENV container docker
ENV liquibase-version 3.4.1
ENV mysql-connector-version 5.1.37

RUN yum -y update --skip-broken;yum install -y jdk1.8.0_25;

# download liquibase
COPY lib/liquibase-3.4.1-bin.tar.gz /tmp/liquibase-3.4.1-bin.tar.gz

# Create a directory for liquibase
RUN mkdir /opt/liquibase

# Unpack the distribution
RUN tar -xzf /tmp/liquibase-3.4.1-bin.tar.gz -C /opt/liquibase
RUN chmod +x /opt/liquibase/liquibase

# Symlink to liquibase to be on the path
RUN ln -s /opt/liquibase/liquibase /usr/local/bin/

# Get the postgres JDBC driver from http://jdbc.postgresql.org/download.html
# COPY lib/postgresql-9.3-1102.jdbc41.jar /opt/jdbc_drivers/
COPY lib/mysql-connector-java-5.1.37-bin.jar /opt/jdbc_drivers/

# RUN ln -s /opt/jdbc_drivers/postgresql-9.3-1102.jdbc41.jar /usr/local/bin/
RUN ln -s /opt/jdbc_drivers/mysql-connector-java-5.1.37-bin.jar /usr/local/bin/

# Add command scripts
ADD scripts /scripts
RUN chmod -R +x /scripts

VOLUME ["/changelogs"]

WORKDIR /

ENTRYPOINT ["/bin/bash"]