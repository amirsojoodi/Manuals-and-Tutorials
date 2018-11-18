## Instruction to setup an Apache Spark cluster - Standalone mode (Ubuntu 16.04)

First make sure you have installed all the dependencies in all nodes. (master and clients):
```
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install scala
```
Create a user of same name in master and all slaves to make your tasks easier during ssh and also switch to that user in master.

####Add entries in hosts file (master and slaves)

Edit hosts file.
```
sudo vim /etc/hosts
```
And add entries of master and slaves in hosts file
```
<MASTER-IP> master
<SLAVE01-IP> slave01
<SLAVE02-IP> slave02
```
####Configure SSH (needed on master, but recommended to do on all nodes)
Install Open SSH Server-Client and Generate key pairs, then copy your key to all nodes to make passwordless ssh available.
```
sudo apt-get install openssh-server openssh-client
ssh-keygen -t rsa -P ""
ssh-copy-id your-user@slave-01
ssh-copy-id your-user@slave-02
```
Download spark binaries, extract it and put it in (/usr/local/spark)
```
wget http://www-us.apache.org/dist/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz
tar xvf spark-2.3.2-bin-hadoop2.7.tgz
sudo mv spark-2.3.2-bin-hadoop2.7 /usr/local/spark
```
Set up the environment for Spark
```
vim ~/.bashrc
# add these two lines at the end of the file(remove the #s):
# export SPARK_HOME="/usr/loca/spark"
# export PATH=$PATH:/usr/local/spark/bin
source ~/.bashrc
```
Make a copy of spark-env-template and Update its content
```
cd /usr/local/spark/conf
cp spark-env.sh.template spark-env.sh
vim spark-env.sh
# add these two lines to the file (remove the #s):
# export SPARK_MASTER_HOST='SERVER-IP'
# export JAVA_HOME=<JAVA_PATH>
```
Add these lines to the slave file (in the current directory):
```
master
slave01
slave02
```
```
mvn clean install
```

