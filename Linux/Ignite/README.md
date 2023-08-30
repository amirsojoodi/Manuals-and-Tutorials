# Instruction to run an example on an Ignite cluster (Ubuntu 16.04)

Download the binary version from ignite homepage, unzip it and place it in an arbitrary directory. (e.g /usr/local)

```bash
wget https://www-eu.apache.org/dist//ignite/2.6.0/apache-ignite-fabric-2.6.0-bin.zip
unzip apache-ignite-fabric-2.6.0-bin.zip
sudo mv apache-ignite-fabric-2.6.0-bin/ /usr/local
```

Now set `IGNITE_HOME` variable in your bashrc:

```bash
export IGNITE_HOME="/usr/local/apache-ignite-fabric-2.6.0-bin/"
```

To setup the cluster, the only thing you need to do is to run this:

```bash
$IGNITE_HOME\bin\ignite.sh 
```

Without any option passed it will load the default configuration file. You can run the command with `-i` option for interactive run. You have to do these steps for all of the nodes in the network. They will find eachother immediately. You can check the state of the cluster with:

```bash
ignitevisorcmd.sh
```

To run an example on the cluster, change current directory to `IGNITE_HOME/examples` and build the sources:

```bash
mvn clean install
```

After a successful build go to `IGNITE_HOME/examples/target` directory and run one of the examples. (you have to include libs, libs/optional, libs/ignite-spring and ignite-examples.jar to your java classpath):

```bash
java -cp ../../libs/*:../../libs/optional/*:../../libs/ignite-spring/*:ignite-examples-2.6.0.jar org.apache.ignite.examples.computegrid.ComputeBroadcastExample
```

## Detailed Instructions to build Ignite

### It's recommended to update mvn at least to version 3.5.x

But it's not mandatory. If the process failed, try this option.

### Get the source code

```bash
git clone https://git-wip-us.apache.org/repos/asf/ignite
```

It will take some time according to your network speed.
Then you have to checkout to a stable version of the code. (Currently 2.6.0)
And then create a simple branch.

```bash
git checkout 2.6.0
git checkout -b newBranch
```

### Build Commands

When you are in the base folder run this command:

```bash
mvn clean install -Pall-java,all-scala,licenses -DskipTests
```

### If you are using Nexus or a repository manager

Because the project has some file-type repositories inside the project directory, don't send all the requests to Nexus. You can change this line in your settings file (~/.m2/settings.xml)

```xml
<mirrorOf>*</mirrorOf>
```

to

```xml
<mirrorOf>external:*</mirrorOf>
```

You have to add these maven repositories(proxy) to the Nexus:
(It's pretty simple. but don't forget to add all of them to the proxy group)

- http://clojars.org/repo/
- http://central.maven.org/maven2/
- https://repository.ow2.org/nexus/content/repositories/public
- http://h2database.com/m2-repo
- https://repository.apache.org/content/repositories/public/

Sometimes you have to use -U for maven to force update the packages through Nexus.

### Netbeans configuarions for example projects

In this path: run -> configuarion -> customise
Add these options to the the run config:

```bash
-Xms10g
-Xmx10g
-server
-XX: MaxDirectMemorySize = 2G
-XX: +AlwaysPreTouch
-XX: +UseG1GC
-XX: +ScavengeBeforeFullGC
-XX: +DisableExplicitGC
```

### You can check Ignite tutorials and docs pages for more

https://ignite.apache.org
