Сгенерим проект используя maven и эту репу https://github.com/manedev79/archetype-java-junit: 

`mvn archetype:generate -DgroupId=demo -DartifactId=demo -Dversion=1.0-SNAPSHOT -DarchetypeGroupId=io.github.manedev79 -DarchetypeArtifactId=archetype-java-junit  -DarchetypeVersion=1.0.4  -DjavaVersion=17  -DgitInit=false -DinteractiveMode=false`{{execute}}

запустим сборку

`cd demo && mvn package `{{execute}}
