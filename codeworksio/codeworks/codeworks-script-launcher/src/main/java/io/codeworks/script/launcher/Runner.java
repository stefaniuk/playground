package io.codeworks.script.launcher;

import java.util.List;

@SuppressWarnings("rawtypes")
public interface Runner<T extends RunnerEventListener> {

    public void setListeners(List<T> listeners);

}
