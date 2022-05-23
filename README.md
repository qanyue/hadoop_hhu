# 介绍

使用docker 一键搭建hadoop 集群 ,包含1个namenode，2个datanode

## 使用命令

以root权限运行

```shell
bash  ./start-container.sh
```

Hadoop网页管理地址:

* NameNode: http://192.168.1.128:9870
* ResourceManager: http://192.168.1.128:8088

  192.168.1.128为运行容器的主机的IP。

  ![img](image/README/1653316404666.png)

#### **运行wordcount测试**

```shell
./run-wordcount.sh
```

**运行结果**

```apache
input file1.txt:
Hello Hadoop
input file2.txt:
Hello Docker
wordcount output:
Docker	1
Hadoop	1
Hello	2
```

注意事项

1. 在运行 start-container.sh 后请勿再次运行该命令,再次运行会删除原有镜像。数据会消失
2. 如想进入hadoop操作界面 以root权限输入

   ```shell
   docker exec -it master bash 
   ```

来自
[kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker)
[墨天轮/Walrus](https://www.modb.pro/db/78682)
仅作打包和升级
