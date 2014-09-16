Codeworks Application
=====================

N-tier web application.

TODO
----

 * Check ObjectAid http://www.objectaid.com/
 * Application PID http://java.dzone.com/articles/managing-spring-boot
 * Application shell http://www.crashub.org/
 * Create responsive layout
    * Bootstrap
    * Thymeleaf
 * Embed default screens in JAR file using web fragments
 * Implement REST endpoints
    * Swagger
 * Implement message converters
    * JSON
    * XML
    * CSV
 * Implement profiles
 * Create best practices document
    * [Log levels](http://stackoverflow.com/questions/7839565/logging-levels-logback-rule-of-thumb-to-assign-log-levels)
 * Revise configuration properties format
    * YAML
 * Improve tests
    * [HtmlUnit](https://github.com/spring-projects/spring-test-mvc-htmlunit)
    * Selenium

Examples
--------

 * Repositories
    * [Spring Data Repositories - Best Practices](https://www.youtube.com/watch?v=hwNyzkWENE0) - youtube video
    * [Spring Data Repositories - A Deep Dive](https://github.com/olivergierke/repositories-deepdive) - github repository
    * [Spring Data - The Definitive Guide](https://github.com/spring-projects/spring-data-book/tree/master/rest) - github repository

Useful Maven Commands
---------------------

    mvn -o clean test -P local,h2,ut
    mvn -o clean integration-test -P local,h2,it

    mvn -o clean install -P local,h2,ut -DskipTests
    mvn cobertura:cobertura -P local,h2,ut

    mvn versions:set -DnewVersion=x.y.z-SNAPSHOT
    mvn versions:revert
    mvn versions:commit

    mvn clean package -P dev
    mvn clean package -P uat
    mvn clean package -P prod

    mvn tomcat7:deploy -P dev -s settings.xml
    mvn tomcat7:deploy-only -P dev -s settings.xml
    mvn tomcat7:redeploy -P dev -s settings.xml

    mvn site:site
    mvn javadoc:test-aggregate
    mvn source:jar javadoc:javadoc javadoc:test-javadoc javadoc:jar

    mvn dependency:tree -Doutput=/path/to/file
    mvn dependency:copy-dependencies

    mvn help:effective-pom
    mvn help:effective-settings

    mvn clean compile assembly:single

Licence
-------

See `LICENCE` file.

> Copyright (c) 2013 CodeworksIO
