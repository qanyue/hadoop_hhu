FROM ubuntu:20.04
LABEL maintainer="luckman@hhu.edu.cn"


RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean

WORKDIR /usr/local
COPY jdk-8u281-linux-x64.tar.gz .

RUN	tar -zxvf jdk-8u281-linux-x64.tar.gz && \
	rm -f jdk-8u281-linux-x64.tar.gz && \
	apt-get update && apt-get install -y openssh-server wget&& \
	mkdir -p /soft/apache/hadoop/

WORKDIR /soft/apache/hadoop/
RUN wget http://mirrors.ustc.edu.cn/apache/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && \
	tar -xzvf hadoop-3.3.1.tar.gz && \
    rm hadoop-3.3.1.tar.gz
# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ENV HADOOP_HOME=/soft/apache/hadoop/hadoop-3.3.1
ENV HADOOP_CONFIG_HOME=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

WORKDIR $HADOOP_HOME
COPY config/* /tmp/
RUN mkdir tmp namenode datanode && \
	mkdir -p ~/.ssh && \
	echo "export JAVA_HOME=/usr/local/jdk1.8.0_281" >> $HADOOP_CONFIG_HOME/hadoop-env.sh && \
	mv /tmp/hdfs-site.xml $HADOOP_CONFIG_HOME/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_CONFIG_HOME/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_CONFIG_HOME/mapred-site.xml && \
    mv /tmp/workers $HADOOP_CONFIG_HOME/workers && \
    mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod go-w ~/.ssh/config

RUN hadoop namenode -format
WORKDIR /root

CMD [ "sh", "-c", "service ssh start; bash"]







