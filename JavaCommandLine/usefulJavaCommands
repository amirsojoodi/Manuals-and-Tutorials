
# run a java class with adding classpath
java -cp libfolder/*:anotherLib/* org.apache.tez.examples.OrderedWordCount input output

# debug a java program and waits till the debugger attaches to it
# add the first line to your bashrc that you always have it:
alias javag='java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,address=9988,suspend=y'
javag -cp libfolder/*:anotherLib/* org.apache.tez.examples.OrderedWordCount input output

# compile a java class with its libraries into a directory
javac -Xlint -classpath lib1.jar:lib2.jar:lib3.jar -d Example_classes/ Example.java

# creating jarfile from compile classes
jar -cvf  example.jar -C Example_classes/ .
