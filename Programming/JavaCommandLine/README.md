## Working with Java from Command Line

- Compile a Java source file into class file and place it into a directory:
```     
javac -Xlint -classpath lib1.jar:lib2.jar:lib3.jar -d Example_classes/ Example.java
```

- Run a Java class with adding classpath:
```
java -cp libfolder/*:anotherLib/* org.apache.tez.examples.OrderedWordCount input output
```

- Debug a Java program (it waits for the debugger to attach). Add the first line to your `bashrc`:
```        
alias javag='java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,address=9988,suspend=y'
javag -cp libfolder/*:anotherLib/* org.apache.tez.examples.OrderedWordCount input output
```

- Creating a jarfile from the compiled classes:

```        
jar -cvf  example.jar -C Example_classes/ .
```

- Add this line to bashrc to give arbitrary options to netbeans:
```
alias netbeans='netbeans -J-server -J-Xms10g -J-Xmx10g -J-XX:MaxDirectMemorySize=2G -J-XX:+AlwaysPreTouch -J-XX:+UseG1GC -J-XX:+ScavengeBeforeFullGC -J-XX:+DisableExplicitGC'
```
If you want to give these JVM options to any project, edit nbactions.xml in the corresponding project directory and edit the tag `<exec.args>` wherever you find in it.
