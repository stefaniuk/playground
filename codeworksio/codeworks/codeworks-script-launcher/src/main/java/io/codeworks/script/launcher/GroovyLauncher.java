package io.codeworks.script.launcher;

import groovy.lang.GroovyClassLoader;
import groovy.lang.GroovyCodeSource;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.lang.reflect.Method;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("rawtypes")
public class GroovyLauncher<T extends RunnerEventListener> implements Launcher<T> {

    private static Logger logger = LoggerFactory.getLogger(GroovyLauncher.class);

    private List<T> listeners = new ArrayList<>();

    private GroovyClassLoader loader = new GroovyClassLoader();

    private Object script;

    private Class<Runner<?>> clazz;

    private Map<String, Method> methods = new HashMap<String, Method>();

    private Runner<T> instance;

    public GroovyLauncher(String code, T listener) {

        addListener(listener);
        script = code;
    }

    public GroovyLauncher(File file, T listener) {

        addListener(listener);
        script = file;
    }

    public GroovyLauncher(URL url, T listener) {

        addListener(listener);
        script = url;
    }

    @Override
    public void addListener(T listener) {

        listeners.add(listener);
    }

    @Override
    public void removeListener(T listener) {

        listeners.remove(listener);
    }

    @SuppressWarnings("unchecked")
    public void run(String methodName, Object... arguments) throws LauncherException {

        try {

            // load class
            if(clazz == null) {
                clazz = loader.parseClass(getGroovyCodeSource(script));
                logger.debug("load class [ " + clazz + " ] ");
                for(T listener: listeners) {
                    listener.onLoad(clazz);
                }
                for(Method method: clazz.getMethods()) {
                    methods.put(method.getName(), method);
                }
            }

            // create instance
            if(instance == null) {
                instance = (Runner<T>) clazz.newInstance();
                logger.debug("create instance [ " + instance + " ] ");
                instance.setListeners(listeners);
                for(T listener: listeners) {
                    listener.onCreate(instance);
                }
            }

            // run
            logger.debug("run [ " + instance + " -> " + methodName + " ] ");
            Method method = methods.get(methodName);
            for(T listener: listeners) {
                listener.onRun(instance, method, arguments);
            }
            method.invoke(instance, arguments);

        }
        catch(Exception e) {
            throw new LauncherException("Error launching class", e);
        }
    }

    private GroovyCodeSource getGroovyCodeSource(Object script) throws IOException {

        if(script instanceof String) {
            String name = "script" + System.currentTimeMillis() + Math.abs(((String) script).hashCode()) + ".groovy";
            return new GroovyCodeSource((String) script, name, "/groovy/script");
        }
        if(script instanceof Reader) {
            String name = "script" + System.currentTimeMillis() + Math.abs(((String) script).hashCode()) + ".groovy";
            return new GroovyCodeSource((Reader) script, name, "/groovy/script");
        }
        if(script instanceof File) {
            return new GroovyCodeSource((File) script);
        }
        if(script instanceof URL) {
            return new GroovyCodeSource((URL) script);
        }

        return null;
    }

}
