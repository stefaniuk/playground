TODO
====

codeworks-script-launcher
-------------------------

 * Allow to load dependency classes or libraries
 * [Add ability to execute scripts](http://groovy.codehaus.org/Embedding+Groovy "Embedding Groovy")
 * Define two additional methods within launcher to load a class and create a new instance
 * Run class method via API call based on interface as an alternative to calling a method by its name using String
 * [Use Javassist to create dynamic proxy](http://www.csg.ci.i.u-tokyo.ac.jp/~chiba/javassist/ "Javaassist")
 * Perform security check while loading scripts AccessController.doPrivileged(new PrivilegedAction<GroovyCodeSource>() { ... });
 * https://gist.github.com/schup/5397811
