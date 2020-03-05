#!/bin/bash

set -x

HOSTNAME=$(hostname -f)
CURRENT_DIR=$(pwd)

# Install Dependencies
yum -y install maven wget mysql-connector-java* unzip zip tree

# Install Impala Driver
cp -r files/impala_jdbc_2.5.45.1065.zip /tmp
cd /tmp && unzip impala_jdbc_2.5.45.1065.zip 
cd /tmp/ClouderaImpalaJDBC_2.5.45.1065
unzip ClouderaImpalaJDBC41_2.5.45.zip

cd $CURRENT_DIR

# Create Kafka Topic
kafka-topics --create --zookeeper $HOSTNAME:2181/kafka --topic cdfworkshoplogs --partitions 1 --replication-factor 1

cd $CURRENT_DIR

# Configure NIFI Solr Collection
cp -r files/nifilogs.zip /opt/cloudera/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554/lib/solr/server/solr/configsets/
cd /opt/cloudera/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554/lib/solr/server/solr/configsets/ && unzip nifilogs.zip
cd /opt/cloudera/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554/lib/solr/server/solr/configsets/nifilogs/conf

# Create NIFI Collection
curl -X POST --header "Content-Type:application/octet-stream" --data-binary @nifilogs.zip "http://$HOSTNAME:8983/solr/admin/configs?action=UPLOAD&name=nifilogs"
curl -X POST --header "Content-Type:application/octet-stream" "http://$HOSTNAME:8983/solr/admin/collections?action=CREATE&name=nifi&&collection.configName=nifilogs&&numShards=1"

cd $CURRENT_DIR

# Configure Tweets Solr Collection
cp -r files/tweets.zip /opt/cloudera/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554/lib/solr/server/solr/configsets/
cd /opt/cloudera/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554/lib/solr/server/solr/configsets/ && unzip tweets.zip
cd /opt/cloudera/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554/lib/solr/server/solr/configsets/tweets/conf

# Create TWEETS Collection
curl -X POST --header "Content-Type:application/octet-stream" --data-binary @tweets.zip "http://$HOSTNAME:8983/solr/admin/configs?action=UPLOAD&name=tweets"
curl -X POST --header "Content-Type:application/octet-stream" "http://$HOSTNAME:8983/solr/admin/collections?action=CREATE&name=tweets&&collection.configName=tweets&&numShards=1"


# Configure Maven

cd /root
wget http://mirror.cogentco.com/pub/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xvf apache-maven-3.6.3-bin.tar.gz 
echo "export M2_HOME=/root/apache-maven-3.6.3" >> /etc/profile.d/maven
echo "export MAVEN_HOME=/root/apache-maven-3.6.3" >> /etc/profile.d/maven
echo "export PATH=${M2_HOME}/bin:${PATH}" >> /etc/profile.d/maven
source /etc/profile.d/maven 


