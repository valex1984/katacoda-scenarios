Сгенерим проект используя maven: 

`mvn archetype:generate -DgroupId=demo -DartifactId=demo -Dversion=1.0-SNAPSHOT -DarchetypeGroupId=org.jetbrains.kotlin -DarchetypeArtifactId=kotlin-archetype-jvm -DkotlinVersion=1.5.31 -DinteractiveMode=false`{{execute}}

запустим сборку

`cd demo && mvn package `{{execute}}
