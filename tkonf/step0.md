Go example клонируем, собираем

`git clone https://github.com/webngt/literate-spork && \
    cd literate-spork && \
    GOOS=linux go build -ldflags="-w -s" -o ../main cmd/app/main.go && \
    cd -`{{execute}}

запустим Go example

`./main`{{execute}}

Java example клонируем, собираем

`git clone https://github.com/jabedhasan21/java-hello-world-with-maven.git && \
    cd java-hello-world-with-maven && mvn package && cd -`{{execute}}

запустим Java example

`cd java-hello-world-with-maven/target && \
    java -cp jb-hello-world-maven-0.2.0.jar hello.HelloWorld && \
    cd -`{{execute}}


pip example

`pip install hello-world-python`{{execute}}
