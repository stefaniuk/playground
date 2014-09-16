package io.codeworks.script.launcher;

import java.lang.reflect.Method;
import java.util.EventListener;

@SuppressWarnings("rawtypes")
public interface RunnerEventListener<T extends Runner> extends EventListener {

    public void onLoad(Class<T> clazz);

    public void onCreate(T instance);

    public void onRun(T instance, Method method, Object... arguments);

}
