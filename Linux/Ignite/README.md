## Detailed Instructions to build Ignite

### It's recommended to update mvn at least to version 3.5.x

But it's not mandatory. If the process failed, try this option.

### Get the source code

```
git clone https://git-wip-us.apache.org/repos/asf/ignite
```

It will take some time according to your network speed.
Then you have to checkout to a stable version of the code. (Currently 2.6.0)
And then create a simple branch.

```
git checkout 2.6.0
git checkout -b newBranch
```

### Build Commands

When you are in the base folder run this command:

```
mvn clean install -Pall-java,all-scala,licenses -DskipTests
```

### If you are using Nexus or a repository manager

Because the project has some file-type repositories inside the project directory, don't send all the requests to Nexus. You can change this line in your settings file (~/.m2/settings.xml)

```
<mirrorOf>*</mirrorOf>
```
to
```
<mirrorOf>external:*</mirrorOf>
```

You have to add these maven repositories(proxy) to the Nexus:
(It's pretty simple. but don't forget to add all of them to the proxy group)

  * http://clojars.org/repo/
  * http://central.maven.org/maven2/
  * https://repository.ow2.org/nexus/content/repositories/public
  * http://h2database.com/m2-repo
  * https://repository.apache.org/content/repositories/public/

Sometimes you have to use -U for maven to force update the packages through Nexus. 

### You can check Ignite tutorials and docs pages for more
https://ignite.apache.org
