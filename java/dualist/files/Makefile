JAVA_HOME=@java_home@

JAVAC=$(JAVA_HOME)/bin/javac -encoding UTF-8 -cp lib/mallet.jar:lib/mecab.jar
JAR=$(JAVA_HOME)/bin/jar

TARGETS=lib/dualist-ja.jar

all : $(TARGETS)

$(TARGETS) : SimpleMecabPipe.java
	-mkdir -p classes
	$(JAVAC) -d classes $<
	$(JAR) cfv $@ -C classes .

clean:
	-rm -rf $(TARGETS) classes
