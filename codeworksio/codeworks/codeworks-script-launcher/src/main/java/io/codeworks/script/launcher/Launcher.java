package io.codeworks.script.launcher;

@SuppressWarnings("rawtypes")
public interface Launcher<T extends RunnerEventListener> {

    public void addListener(T listener);

    public void removeListener(T listener);

}
